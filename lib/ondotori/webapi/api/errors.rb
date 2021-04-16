# frozen_string_literal: true

module Ondotori
  module WebAPI
    module Api
      module Errors
        class Error < StandardError
          attr_reader :code

          def initialize(message, code = nil)
            super message
            @code = code
          end
        end

        class ResponseError < Error
          attr_reader :ratelimit

          def initialize(message, code, ratelimit)
            super message, code
            @ratelimit = ratelimit
          end
        end

        class InitializeParameterNotFound < Error; end

        class InvaildParameter < Error; end

        class HttpAccessError < Error
          attr_reader :detail

          def initialize(message, detail, code = nil)
            super message, code
            @detail = detail
          end
        end
      end
    end
  end
end
