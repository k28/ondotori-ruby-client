# frozen_string_literal: true

require "test_helper"

module Ondotori
  module WebAPI
    module Api
      class DataRangeTest < Minitest::Test
        def test_success
          param = Ondotori::WebAPI::Api::DataRange.new
          refute_nil param
        end

        def test_success2
          from = Time.now - (3600 * 24)
          to   = Time.now
          limit = 173
          param = Ondotori::WebAPI::Api::DataRange.new(from: from, to: to, limit: limit)
          refute_nil param
        end

        def test_validation
          time = Time.now - (3600 * 24)
          limit = 173
          e = assert_raises Ondotori::WebAPI::Api::Errors::InvaildParameter do
            _ = Ondotori::WebAPI::Api::DataRange.new(from: time, to: "", limit: limit)
          end
          assert_equal 9992, e.code

          e = assert_raises Ondotori::WebAPI::Api::Errors::InvaildParameter do
            _ = Ondotori::WebAPI::Api::DataRange.new(from: "", to: time, limit: limit)
          end
          assert_equal 9992, e.code
        end
      end
    end
  end
end
