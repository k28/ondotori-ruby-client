# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module Ondotori
  module WebAPI
    class HttpWebAccess < WebAccess
      def make_headers
        { "Content-Type" => "application/json", "X-HTTP-Method-Override" => "GET" }
      end

      def access(uri, params)
        web_uri = URI.parse(uri)
        http = Net::HTTP.new(web_uri.host, web_uri.port)
        http.use_ssl = (web_uri.scheme == "https")

        response = http.request_post(web_uri.path, params.to_json, make_headers)
        case response
        when Net::HTTPSuccess
          response
        when Net::HTTPClientError, Net::HTTPServerError
          response
        else
          # response.value raises Eception...
          raise Ondotori::WebAPI::Api::Errors::HttpAccessError.new("#{response.message}", "#{response.code}", 9995)
        end
      end
    end
  end
end
