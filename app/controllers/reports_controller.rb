class ReportsController < ApplicationController
  def index
    start_date = params[:start_date] ? Date.parse(params[:start_date]) : 1.month.ago.to_date
    end_date = params[:end_date] ? Date.parse(params[:end_date]) : Date.today

    @users_chart = User.where(created_at: start_date.beginning_of_day..end_date.end_of_day).group_by_day(:created_at).count
    @notices_chart_by_status = Notice.where(created_at: start_date.beginning_of_day..end_date.end_of_day).group(:status).count
    @notices_chart_by_status = @notices_chart_by_status.transform_keys { |status| I18n.t("status.#{status}") }
    @average_ratings_of_notices = Views::AverageRatingsOfNotice.where(ad_type_created_at: start_date.beginning_of_day..end_date.end_of_day)
    @price_earnings = Views::PriceEarnings.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    @price_earnings_grouped = @price_earnings.group_by(&:category_name)

    respond_to do |format|
      format.html
      format.json { render json: {
        users_chart: @users_chart,
        notices_chart_by_status: @notices_chart_by_status,
        average_ratings_of_notices: @average_ratings_of_notices,
        price_earnings: @price_earnings_grouped.map { |category_name, earnings|
          {
            name: category_name,
            earnings: earnings.map { |chart| { notice_title: chart.notice_title, price: chart.price } }
          }
        }
      }
    }
    end
  end
end
