json.extract! document, :id, :name, :content, :file, :created_at, :updated_at
json.url document_url(document, format: :json)
