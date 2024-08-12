module Analyzer
  class PdfAnalyzer < ActiveStorage::Analyzer

    def self.accept?(blob)
      blob.content_type == 'application/pdf'
    end

    def metadata
      parse_file do |pdf|
        {
          page_count: pdf.page_count
        }
      end
    end

    private

      def parse_file
        download_blob_to_tempfile do |file|
          pdf_doc = PDF::Reader.new(file)
          if pdf_doc
            yield pdf_doc
          else
            Rails.logger.info "Skipping PDF analysis because it's not a known PDF document format"
          end
        end
      end

  end
end