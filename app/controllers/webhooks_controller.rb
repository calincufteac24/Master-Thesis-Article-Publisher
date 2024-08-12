class WebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, Rails.application.credentials[:stripe_webhook]
      )
    rescue JSON::ParserError
      Rails.logger.error("JSON parse error")
      render json: { error: 'Invalid payload' }, status: 400
      return
    rescue Stripe::SignatureVerificationError
      Rails.logger.error("Signature verification error")
      render json: { error: 'Invalid signature' }, status: 400
      return
    end

    Rails.logger.info("Received Stripe event: #{event.type}")

    case event.type
    when 'charge.updated'

      charge = event.data.object
      Rails.logger.info("Handling checkout session completed for session ID: #{charge.id}")
      notice_price = charge.amount.to_f / 100
      Rails.logger.info("#{notice_price}")
      # Find the record based on some criteria (e.g., price)
      @notice = Notice.find_by(price: notice_price)
      Rails.logger.info("Notice: #{@notice}")


      if @notice
        @notice.update(payment_successful: true)
        @notice.update(price: @notice.calculate_price)
        Rails.logger.info("Successfully updated notice ID: #{@notice.id}")
        @notice.reload
      else
        Rails.logger.warn("Notice with price #{charge.amount} not found")
      end
    else
      Rails.logger.warn("Unhandled event type: #{event.type}")
    end

    render json: { message: 'success' }, status: 200
  end
end
