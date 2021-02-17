# frozen_string_literal: true

require "test_helper"

module Ondotori
  module WebAPI
    module Api
      class URITest < Minitest::Test
        def test_japan_id
          uri = Ondotori::WebAPI::Api::URI.new("tbxx1234")
          assert_equal "https://api.webstorage.jp/v1/devices/", uri.uri
        end

        def test_japan_read_only
          uri = Ondotori::WebAPI::Api::URI.new("rbxx1234")
          assert_equal "https://api.webstorage.jp/v1/devices/", uri.uri
        end

        def test_abroad_id
          uri = Ondotori::WebAPI::Api::URI.new("tdxx1234")
          assert_equal "https://api.webstorage-service.com/v1/devices/", uri.uri
        end

        def test_abroad_id_read_only
          uri = Ondotori::WebAPI::Api::URI.new("rdxx1234")
          assert_equal "https://api.webstorage-service.com/v1/devices/", uri.uri
        end
      end
    end
  end
end
