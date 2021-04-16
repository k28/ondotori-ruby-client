# frozen_string_literal: true

require "test_helper"

module Ondotori
  module WebAPI
    module Api
      class ClientTest < Minitest::Test
        def make_success_response
          body = %({"devices" : []})
          mock = Minitest::Mock.new
          mock.expect(:code, "200", [])
          mock.expect(:body, body, [])
          mock
        end

        def make_failure_response(code, message)
          body = %({"error" : { "code" : #{code}, "message" : "#{message}"}})
          mock = Minitest::Mock.new
          mock.expect(:code, "#{code}", [])
          mock.expect(:body, body, [])
          mock.expect(:get_fields, 60, ["X-RateLimit-Limit"])
          mock.expect(:get_fields, 57, ["X-RateLimit-Reset"])
          mock.expect(:get_fields, 12, ["X-RateLimit-Remaining"])
          mock
        end

        def test_success_response
          response = Ondotori::WebAPI::Api::Response.new(make_success_response)
          assert !response.nil?
        end

        def test_faild_response
          e = assert_raises Ondotori::WebAPI::Api::Errors::ResponseError do
            Ondotori::WebAPI::Api::Response.new(make_failure_response(400, "Bad Request"))
          end
          assert_equal 400, e.code
          assert_equal "Bad Request", e.message
          assert_equal 60, e.ratelimit.limit
        end
      end
    end
  end
end
