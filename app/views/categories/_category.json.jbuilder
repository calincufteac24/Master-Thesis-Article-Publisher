json.extract! category, :id, :name, :description, :about, :is_primary, :parent_id, :created_at, :updated_at
json.url category_url(category, format: :json)
