# frozen_string_literal: true

module Ondotori
  module WebAPI
    module Api
      class Param
        API_KEY    = "api-key"
        LOGIN_ID   = "login-id"
        LOGIN_PASS = "login-pass"

        attr_reader :api_key, :login_id, :login_pass

        def initialize(params)
          validate(params)

          @api_key = params[Param::API_KEY]
          @login_id = params[Param::LOGIN_ID]
          @login_pass = params[Param::LOGIN_PASS]
        end

        def validate(params)
          unless params.key?(Param::API_KEY)
            raise Ondotori::WebAPI::Api::Errors::InitializeParameterNotFound.new(Param::API_KEY, 9999)
          end
          unless params.key?(Param::LOGIN_ID)
            raise Ondotori::WebAPI::Api::Errors::InitializeParameterNotFound.new(Param::LOGIN_ID, 9998)
          end
          unless params.key?(Param::LOGIN_PASS)
            raise Ondotori::WebAPI::Api::Errors::InitializeParameterNotFound.new(Param::LOGIN_PASS, 9997)
          end
        end
      end
    end
  end
end
