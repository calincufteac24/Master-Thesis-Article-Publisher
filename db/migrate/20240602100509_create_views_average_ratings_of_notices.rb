class CreateViewsAverageRatingsOfNotices < ActiveRecord::Migration[6.1]
  def change
    create_view :views_average_ratings_of_notices
  end
end
