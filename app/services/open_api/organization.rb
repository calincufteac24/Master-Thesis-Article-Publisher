module OpenApi
  class Organization
    BASE_URL = 'https://api.openapi.ro/api/companies/'.freeze

    attr_accessor :fiscal_code

    def self.find(fiscal_code)
      new(fiscal_code).organization
    end

    def initialize(fiscal_code)
      @fiscal_code = fiscal_code
    end

    def organization
      self.fiscal_code = sanitize_fiscal_code
      return if fiscal_code.nil?

      result = fetch_organization

      if result.success?
        json = JSON.parse(result.body, symbolize_names: true)

        ::Organization.new(name: json[:denumire], fiscal_code: json[:cif],
                         address: json[:adresa], reg_com: json[:numar_reg_com])
      else
        Rails.logger.error("OpenAPI returned an #{result.status} response: #{result.body}")
        nil
      end
    rescue Faraday::ClientError, Faraday::ConnectionFailed, Faraday::Error, Net::OpenTimeout, Net::ReadTimeout => e
      Rails.logger.error("OpenAPI returned an error: #{e.message}")
      nil
    end

    private

    def fetch_organization
      conn = Faraday.new(url: "#{BASE_URL}#{fiscal_code}") do |faraday|
        faraday.response :logger
        faraday.headers['x-api-key'] = Rails.application.credentials.config[:open_api_key]
      end

      conn.get
    end

    def sanitize_fiscal_code
      fiscal_code.scan(/[0-9]{8}/).first
    end
  end
end
