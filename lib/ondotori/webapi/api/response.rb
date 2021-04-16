# frozen_string_literal: true

module Ondotori
  module WebAPI
    module Api
      class Response
        attr_reader :result

        def initialize(response)
          @response = response
          validate
          @result = JSON.parse(@response.body)
        end

        def validate
          unless @response.code == "200"
            result = JSON.parse(@response.body)
            if result.key?("error")
              code = result["error"]["code"]
              message = result["error"]["message"]
              ratelimit = Ondotori::WebAPI::Api::RateLimit.new(@response)
              raise Ondotori::WebAPI::Api::Errors::ResponseError.new(message, code, ratelimit)
            end

            # unknown error...
            raise Ondotori::WebAPI::Api::Errors::Error.new("Server response code [#{@response.code}]", 9996)
          end
        end
      end
    end
  end
end
