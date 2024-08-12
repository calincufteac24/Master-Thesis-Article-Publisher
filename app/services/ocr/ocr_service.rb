module Ocr
  class OcrService
      def self.service
        ::Ocr::GoogleVisionOcrService.new
      end

      def ocr
      end
  end
end
