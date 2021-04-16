# frozen_string_literal: true

module Ondotori
  module WebAPI
    module Api
      class RateLimit
        attr_reader :limit, :reset, :remaining

        def initialize(response)
          @limit     = response.get_fields("X-RateLimit-Limit")
          @reset     = response.get_fields("X-RateLimit-Reset")
          @remaining = response.get_fields("X-RateLimit-Remaining")
        end
      end
    end
  end
end
