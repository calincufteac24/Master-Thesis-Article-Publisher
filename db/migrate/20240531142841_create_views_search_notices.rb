class CreateViewsSearchNotices < ActiveRecord::Migration[6.1]
  def change
    create_view :views_search_notices, materialized: true
  end
end
