require "google/cloud/vision/v1"
require 'open-uri'

class OcrJob < ApplicationJob
  queue_as :default

  FILES_BUCKET = 'files-for-ocr'
  OCR_BUCKET   = 'files-ocr-results'
  OCR_SUFIX    = 'output-1-to-'
  MIME_TYPE    = 'application/pdf'

  def perform(*params)
    Rails.logger.info("Start to perform document ocr-isization....")
    Rails.logger.info("Start #{client.object_id}")
    file_key         = params[0][:file_key]
    page_count       = params[0][:page_count] || '1'

    file_remote_path = "gs://#{FILES_BUCKET}/#{file_key}"
    result_file_path = "gs://#{OCR_BUCKET}/#{file_key}"

    operation = client.document_text_detection(
      image:       file_remote_path,
      destination: result_file_path,
      mime_type:   ActiveStorage::Blob.find_by(key: file_key).content_type,
      async:       true
    )

    wait_for_response(operation.name, file_key, result_file_path, page_count)
  end

  private

    def wait_for_response(operation_name, file_key, result_file_path, page_count)
      operations = ::Google::Cloud::Vision::V1::ImageAnnotator::Operations.new

      begin
        operation = operations.get_operation(name: operation_name)
        ready_to_go = operation.done?
      end until ready_to_go or not sleep 1


      # Rails.logger.info("File path: #{operation.response.responses[0].output_config.gcs_destination.uri}")
      # Rails.logger.info("Done! Inspect: #{pp operation}. Finished processing. Result file path `#{result_file_path}`")

      update_document(file_key, full_ocr_file_path(result_file_path, page_count))
    end

    def update_document(file_key, ocr_remote_file_path)
      document = find_document(file_key)

      if document.nil?
        Rails.logger.info("OCRJob: Could not locate document for remote file: '#{file_key}'")
        return
      end

      document.update_attribute(:ocr_remote_file_path, ocr_remote_file_path)
      document.update_attribute(:ocr_text, donwload_ocr_text_for(ocr_remote_file_path))
    end

    def find_document(file_key)
      blob = ActiveStorage::Blob.find_by(key: file_key)
      return nil if blob.nil? || blob.attachments.empty?
      blob.attachments.first.record
    end

    def donwload_ocr_text_for(ocr_remote_file_path)
      # TODO:
      # Mai am de facut aici situatia in care un documennt PDF are mai mult de 10 pagini.
      # Atunci GV produce o suita de fisiere ca in exemplul: 1-to-10.json, 11-to-20.json, 21-to-30.json, 31-to-35.json
      ocr_remote_file = Google::Cloud::Storage.new.bucket(OCR_BUCKET).file(extract_file_name(ocr_remote_file_path))
      extract_ocr_text_from(JSON.parse(ocr_remote_file.download.read))
    end

    def extract_ocr_text_from(json)
      json["responses"].map do |response|
        response["fullTextAnnotation"]["text"]
      end.join
    end

    def extract_file_name(ocr_remote_file_path)
      ocr_remote_file_path.gsub!("gs://#{OCR_BUCKET}/", "")
    end

    def full_ocr_file_path(result_file_path, page_count)
      result_file_path + OCR_SUFIX + page_count.to_s + ".json"
    end

    def client
      Google::Cloud::Vision::V1::ImageAnnotator::Client.new
    end
end
