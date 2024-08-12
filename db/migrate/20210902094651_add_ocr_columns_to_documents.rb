class AddOcrColumnsToDocuments < ActiveRecord::Migration[6.1]
  def change
    add_column :documents, :ocr_remote_file_path, :string, null: true
    add_column :documents, :ocr_text, :text, null: true
  end
end
