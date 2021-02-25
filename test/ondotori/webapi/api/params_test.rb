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

      class LatestDataParamsTest < Minitest::Test
        def test_success
          param = Ondotori::WebAPI::Api::LatestDataParams.new(ParamsTest.make_param, serial: "SE12345")
          refute_nil param
        end

        def test_failure
          e = assert_raises Ondotori::WebAPI::Api::Errors::InvaildParameter do
            Ondotori::WebAPI::Api::LatestDataParams.new(ParamsTest.make_param, serial: "")
          end

          assert_equal 9994, e.code
        end

        def test_to_ondotori_param
          p = ParamsTest.make_param
          param = Ondotori::WebAPI::Api::LatestDataParams.new(p, serial: "SE12345")
          ondo_param = param.to_ondotori_param

          refute_nil ondo_param
          assert_equal p.api_key, ondo_param["api-key"]
          assert_equal p.login_id, ondo_param["login-id"]
          assert_equal p.login_pass, ondo_param["login-pass"]
          assert_equal "SE12345", ondo_param["remote-serial"]
        end
      end

      class LatestDataRTR500ParamsTest < Minitest::Test
        def test_success
          param = Ondotori::WebAPI::Api::LatestDataRTR500Params.new(ParamsTest.make_param, base: "BS12345", remote: "SE12345")
          refute_nil param
        end

        def test_failure
          tests = [
            { base: "",       remote: "" },
            { base: "BA1234", remote: "" },
            { base: "",       remote: "SE1234" }
          ]

          tests.each do |test|
            e = assert_raises Ondotori::WebAPI::Api::Errors::InvaildParameter do
              Ondotori::WebAPI::Api::LatestDataRTR500Params.new(ParamsTest.make_param, base: test[:base], remote: test[:remote])
            end
            assert_equal 9993, e.code
          end
        end

        def test_to_ondotori_param
          p = ParamsTest.make_param
          param = Ondotori::WebAPI::Api::LatestDataRTR500Params.new(p, base: "BS12345", remote: "SE12345")
          refute_nil param
          ondo_param = param.to_ondotori_param

          refute_nil ondo_param
          assert_equal p.api_key, ondo_param["api-key"]
          assert_equal p.login_id, ondo_param["login-id"]
          assert_equal p.login_pass, ondo_param["login-pass"]
          assert_equal "SE12345", ondo_param["remote-serial"]
          assert_equal "BS12345", ondo_param["base-serial"]
        end
      end

      class DataParamsTest < Minitest::Test
        def test_success
          param = Ondotori::WebAPI::Api::DataParams.new(ParamsTest.make_param)
          refute_nil param
        end

        def test_success_from_to
          from  = Time.now - (3600 * 24)
          to    = Time.now
          limit = 1000
          param = Ondotori::WebAPI::Api::DataParams.new(ParamsTest.make_param, from: from, to: to, limit: limit)
          refute_nil param
        end

        def test_parameter_failure
          time = Time.now
          limit = 1000
          e = assert_raises Ondotori::WebAPI::Api::Errors::InvaildParameter do
            _ = Ondotori::WebAPI::Api::DataParams.new(ParamsTest.make_param, from: "", to: time, limit: limit)
          end
          assert_equal 9992, e.code

          e = assert_raises Ondotori::WebAPI::Api::Errors::InvaildParameter do
            _ = Ondotori::WebAPI::Api::DataParams.new(ParamsTest.make_param, from: time, to: "", limit: limit)
          end
          assert_equal 9992, e.code
        end

        def test_to_ondotori_param
          p = ParamsTest.make_param
          param = Ondotori::WebAPI::Api::DataParams.new(p)

          ondo_param = param.to_ondotori_param

          refute_nil ondo_param
          assert_equal p.api_key, ondo_param["api-key"]
          assert_equal p.login_id, ondo_param["login-id"]
          assert_equal p.login_pass, ondo_param["login-pass"]
          assert_nil ondo_param["from"]
          assert_nil ondo_param["to"]
          assert_nil ondo_param["limit"]
        end

        def test_to_ondotori_param2
          p = ParamsTest.make_param
          from = Time.now - (3600 * 24)
          to   = Time.now
          limit = 173
          param = Ondotori::WebAPI::Api::DataParams.new(p, from: from, to: to, limit: limit)

          ondo_param = param.to_ondotori_param

          refute_nil ondo_param
          assert_equal p.api_key, ondo_param["api-key"]
          assert_equal p.login_id, ondo_param["login-id"]
          assert_equal p.login_pass, ondo_param["login-pass"]
          assert_equal from.to_i, ondo_param["unixtime-from"]
          assert_equal to.to_i, ondo_param["unixtime-to"]
          assert_equal limit, ondo_param["number"]
        end
      end
    end
  end
end
