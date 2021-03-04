# frozen_string_literal: true

require "test_helper"

module Ondotori
  module WebAPI
    class ClientTest < Minitest::Test
      def make_client_params
        { Api::Param::API_KEY => "73pfobnche8d1p6laqnemsbnpkght3bjv047oid6p2sg3",
          Api::Param::LOGIN_ID => "tbxx1234",
          Api::Param::LOGIN_PASS => "password" }
      end

      def make_test_client(web_access = Ondotori::WebAPI::StbWebAccess.new(30, ->(_) { make_success_response }))
        params = make_client_params
        client = Ondotori::WebAPI::Client.new(params)
        client.web_access = web_access
        client
      end

      def test_initialize
        params = make_client_params
        client = Ondotori::WebAPI::Client.new(params)
        refute_nil client
      end

      def test_initialize_with_uri
        params = make_client_params
        client = Ondotori::WebAPI::Client.new(params, uri: "https://xxx.xxx.xxx")
        refute_nil client
        assert_equal "https://xxx.xxx.xxx", client.base_uri
      end

      def test_initialze_param_not_found_loginpass
        params = make_client_params
        params.delete(Api::Param::LOGIN_PASS)

        e = assert_raises Ondotori::WebAPI::Api::Errors::InitializeParameterNotFound do
          Ondotori::WebAPI::Client.new(params)
        end

        assert_equal "login-pass", e.message
        assert_equal 9997, e.code
      end

      def test_current_params_error
        client = make_test_client
        client.current(remote_serial_list: ["SE12345"])
        client.current(base_serial_list: ["BA12345"])

        e = assert_raises Ondotori::WebAPI::Api::Errors::InvaildParameter do
          client.current(remote_serial_list: ["RE12324"], base_serial_list: ["BA12345"])
        end
        assert_equal 9998, e.code
      end

      def test_current_params
        client_params = make_client_params
        stb_access = Ondotori::WebAPI::StbWebAccess.new(30, lambda { |access|
          assert_equal client_params["api-key"], access.params["api-key"]
          assert_equal client_params["login-id"], access.params["login-id"]
          assert_equal client_params["login-pass"], access.params["login-pass"]
          assert_nil access.params["remote-serial"]
          assert_nil access.params["base-serial"]
          make_success_response
        })
        client = make_test_client(stb_access)
        client.current
      end

      def test_current_params_remote_serial
        client_params = make_client_params
        stb_access = Ondotori::WebAPI::StbWebAccess.new(30, lambda { |access|
          assert_equal client_params["api-key"], access.params["api-key"]
          assert_equal client_params["login-id"], access.params["login-id"]
          assert_equal client_params["login-pass"], access.params["login-pass"]
          assert_equal ["SE12345"], access.params["remote-serial"]
          assert_nil access.params["base-serial"]
          make_success_response
        })
        client = make_test_client(stb_access)
        client.current(remote_serial_list: ["SE12345"])
      end

      def test_current_params_base_serial
        client_params = make_client_params
        stb_access = Ondotori::WebAPI::StbWebAccess.new(30, lambda { |access|
          assert_equal "https://api.webstorage.jp/v1/devices/current", access.uri
          assert_equal client_params["api-key"], access.params["api-key"]
          assert_equal client_params["login-id"], access.params["login-id"]
          assert_equal client_params["login-pass"], access.params["login-pass"]
          assert_nil access.params["remote-serial"]
          assert_equal ["BA12345"], access.params["base-serial"]
          make_success_response
        })
        client = make_test_client(stb_access)
        client.current(base_serial_list: ["BA12345"])
      end

      def test_latest_data
        client_params = make_client_params
        stb_access = Ondotori::WebAPI::StbWebAccess.new(30, lambda { |access|
          assert_equal "https://api.webstorage.jp/v1/devices/latest-data", access.uri
          assert_equal client_params["api-key"], access.params["api-key"]
          assert_equal client_params["login-id"], access.params["login-id"]
          assert_equal client_params["login-pass"], access.params["login-pass"]
          assert_equal "SE1234", access.params["remote-serial"]
          make_success_response
        })
        client = make_test_client(stb_access)
        client.latest_data("SE1234")
      end

      def test_latest_data_rtr500
        client_params = make_client_params
        stb_access = Ondotori::WebAPI::StbWebAccess.new(30, lambda { |access|
          assert_equal "https://api.webstorage.jp/v1/devices/latest-data-rtr500", access.uri
          assert_equal client_params["api-key"], access.params["api-key"]
          assert_equal client_params["login-id"], access.params["login-id"]
          assert_equal client_params["login-pass"], access.params["login-pass"]
          assert_equal "BA1234", access.params["base-serial"]
          assert_equal "SE1234", access.params["remote-serial"]
          make_success_response
        })
        client = make_test_client(stb_access)
        client.latest_data_rtr500(base: "BA1234", remote: "SE1234")
      end

      def test_data
        from = Time.now - (3600 * 24)
        to   = Time.now
        limit = 173
        data_range = Ondotori::WebAPI::Api::DataRange.new(from: from, to: to, limit: limit)
        client_params = make_client_params
        stb_access = Ondotori::WebAPI::StbWebAccess.new(30, lambda { |access|
          assert_equal "https://api.webstorage.jp/v1/devices/data", access.uri
          assert_equal client_params["api-key"], access.params["api-key"]
          assert_equal client_params["login-id"], access.params["login-id"]
          assert_equal client_params["login-pass"], access.params["login-pass"]
          assert_equal "SE1234", access.params["remote-serial"]
          assert_equal from.to_i, access.params["unixtime-from"]
          assert_equal to.to_i, access.params["unixtime-to"]
          assert_equal limit, access.params["number"]
          make_success_response
        })
        client = make_test_client(stb_access)
        client.data("SE1234", data_range: data_range)
      end

      def test_data_rtr500
        from = Time.now - (3600 * 24)
        to   = Time.now
        limit = 173
        data_range = Ondotori::WebAPI::Api::DataRange.new(from: from, to: to, limit: limit)
        client_params = make_client_params
        stb_access = Ondotori::WebAPI::StbWebAccess.new(30, lambda { |access|
          assert_equal "https://api.webstorage.jp/v1/devices/data-rtr500", access.uri
          assert_equal client_params["api-key"], access.params["api-key"]
          assert_equal client_params["login-id"], access.params["login-id"]
          assert_equal client_params["login-pass"], access.params["login-pass"]
          assert_equal "BS1234", access.params["base-serial"]
          assert_equal "SE1234", access.params["remote-serial"]
          assert_equal from.to_i, access.params["unixtime-from"]
          assert_equal to.to_i, access.params["unixtime-to"]
          assert_equal limit, access.params["number"]
          make_success_response
        })
        client = make_test_client(stb_access)
        client.data_rtr500(base: "BS1234", remote: "SE1234", data_range: data_range)
      end

      def make_success_response
        body = %({"devices" : []})
        mock = Minitest::Mock.new
        mock.expect(:code, "200", [])
        mock.expect(:body, body, [])
        mock
      end
    end
  end
end
