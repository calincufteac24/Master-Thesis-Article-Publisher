class StripeCheckoutsController < ApplicationController
  def create
    @notice = Notice.find(params[:notice_id])
    session = Stripe::Checkout::Session.create({
      ui_mode: 'embedded',
      customer_email: @notice.creator.email,
      line_items: [{
        quantity: 1,
        price_data: {
          currency: 'ron',
          product_data: {
            name: @notice.ad_type.name,
            description: @notice.ad_type.description
          },
          unit_amount: (@notice.calculate_price * 100).to_i,
        }
      }],
      mode: 'payment',
      return_url: confirmation_notice_url(@notice),
    })

    if Rails.env.development?
      simulate_payment_success(@notice)
    end

    render json: { clientSecret: session.client_secret }
  end

  private

  def simulate_payment_success(notice)
    Thread.new do
      sleep 2 # Simulate delay
      notice.update(payment_successful: true)
      notice.update(price: notice.calculate_price)
    end
  end

end
