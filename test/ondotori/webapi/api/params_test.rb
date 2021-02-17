# frozen_string_literal: true

require "test_helper"

module Ondotori
  module WebAPI
    module Api
      module ParamsTest
        def self.make_param
          params = { Param::API_KEY => "abcd", Param::LOGIN_ID => "tbxx1234", Param::LOGIN_PASS => "password" }
          Ondotori::WebAPI::Api::Param.new(params)
        end
      end

      class CurrentParamsTest < Minitest::Test
        def test_success
          param = Ondotori::WebAPI::Api::CurrentParams.new(ParamsTest.make_param, remote: [], base: [])
          refute_nil param
        end

        def test_failure
          e = assert_raises Ondotori::WebAPI::Api::Errors::InvaildParameter do
            Ondotori::WebAPI::Api::CurrentParams.new(ParamsTest.make_param, remote: ["SE12345"], base: ["BS12345"])
          end

          assert_equal 9998, e.code
        end

        def test_to_ondotori_param
          p = ParamsTest.make_param
          param = Ondotori::WebAPI::Api::CurrentParams.new(p, remote: [], base: [])
          ondo_param = param.to_ondotori_param

          assert_equal p.api_key, ondo_param["api-key"]
          assert_equal p.login_id, ondo_param["login-id"]
          assert_equal p.login_pass, ondo_param["login-pass"]
          assert_nil ondo_param["remote-serial"]
          assert_nil ondo_param["base-serial"]
        end
      end

      class CurrentParamsTest < Minitest::Test
      end
    end
  end
end
