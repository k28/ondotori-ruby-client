# frozen_string_literal: true

require "test_helper"

module Ondotori
  module WebAPI
    module Api
      class ParamTest < Minitest::Test
        def make_param
          { Param::API_KEY => "abcd", Param::LOGIN_ID => "tbxx1234", Param::LOGIN_PASS => "password" }
        end

        def test_success
          param = Ondotori::WebAPI::Api::Param.new(make_param)
          refute_nil param
        end

        def test_failure
          tests = [
            { expect: 9999, key: Param::API_KEY },
            { expect: 9998, key: Param::LOGIN_ID },
            { expect: 9997, key: Param::LOGIN_PASS }
          ]
          tests.each do |test|
            params = make_param
            params.delete(test[:key])
            e = assert_raises Ondotori::WebAPI::Api::Errors::InitializeParameterNotFound do
              _ = Ondotori::WebAPI::Api::Param.new(params)
            end
            assert_equal test[:expect], e.code
          end
        end
      end
    end
  end
end
