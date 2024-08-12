class CreateViewsNoticesByDates < ActiveRecord::Migration[6.1]
  def change
    create_view :views_notices_by_dates, materialized: true
  end
end
