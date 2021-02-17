# frozen_string_literal: true

module Ondotori
  module WebAPI
    module Api
      class URI
        URI_JAPAN = "https://api.webstorage.jp/v1/devices/"
        URI_ABROAD = "https://api.webstorage-service.com/v1/devices/"

        def initialize(id)
          @id = id
        end

        def uri
          return URI_ABROAD if @id.match?(/^td.*/) || @id.match?(/^rd.*/)

          URI_JAPAN
        end
      end
    end
  end
end
