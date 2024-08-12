require 'open-uri'

module Ocr
  class GoogleVisionOcrService < OcrService
    def ocr(file)
      OcrJob.perform_now({ file_key: file.key, page_count: file.metadata[:page_count] })
    end
  end
end
