# frozen_string_literal: true

require "test_helper"

module Ondotori
  module WebAPI
    module Api
      class RateLimitTest < Minitest::Test
        def make_failure_response(code, message)
          body = %({"error" : { "code" : #{code}, "message" : "#{message}"}})
          mock = Minitest::Mock.new
          mock.expect(:code, "#{code}", [])
          mock.expect(:body, body, [])
          mock.expect(:get_fields, 60, ["X-RateLimit-Limit"])
          mock.expect(:get_fields, 59, ["X-RateLimit-Reset"])
          mock.expect(:get_fields, 57, ["X-RateLimit-Remaining"])
          mock
        end

        def test_success
          ratelimit = Ondotori::WebAPI::Api::RateLimit.new(make_failure_response(429, "Too Many Requests"))
          refute_nil ratelimit
          assert_equal 60, ratelimit.limit
          assert_equal 59, ratelimit.reset
          assert_equal 57, ratelimit.remaining
        end
      end
    end
  end
end
