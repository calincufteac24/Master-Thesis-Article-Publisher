class Views::NoticesByDates < ApplicationRecord
  self.primary_key = :id
  belongs_to :notice, foreign_key: 'notice_id'

  def readonly?
    true
  end

  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, concurrently: false, cascade: false)
  end
end
