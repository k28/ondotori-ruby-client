# frozen_string_literal: true

module Ondotori
  module WebAPI
    module Api
      class CurrentParams
        def initialize(param, remote: [], base: [])
          @param = param

          if remote.length.positive? && base.length.positive?
            raise Ondotori::WebAPI::Api::Errors::InvaildParameter.new(
              "Both remote_serial_list and base_serial_list cannot be set.", 9998
            )
          end
          @remote_serial_list = remote
          @base_serial_list = base
        end

        def to_ondotori_param
          params = {}
          params[Api::Param::API_KEY] = @param.api_key
          params[Api::Param::LOGIN_ID] = @param.login_id
          params[Api::Param::LOGIN_PASS] = @param.login_pass
          params["remote-serial"] = @remote_serial_list if @remote_serial_list.length.positive?
          params["base-serial"] = @base_serial_list if @base_serial_list.length.positive?

          params
        end
      end

      class LatestDataParams
        def initialize(param, serial: "")
          if serial.empty?
            raise Ondotori::WebAPI::Api::Errors::InvaildParameter.new(
              "latest-data need remote-serial", 9994
            )
          end
          @param = param
          @remote_serial = serial
        end

        def to_ondotori_param
          params = {}
          params[Api::Param::API_KEY] = @param.api_key
          params[Api::Param::LOGIN_ID] = @param.login_id
          params[Api::Param::LOGIN_PASS] = @param.login_pass
          params["remote-serial"] = @remote_serial

          params
        end
      end

      class LatestDataRTR500Params
        def initialize(param, base: "", remote: "")
          if base.empty? || remote.empty?
            raise Ondotori::WebAPI::Api::Errors::InvaildParameter.new(
              "latest-data-rtr500 need both the  baseunit serial and remote unit serial.", 9993
            )
          end
          @param = param
          @base_serial = base
          @remote_serial = remote
        end

        def to_ondotori_param
          params = {}
          params[Api::Param::API_KEY] = @param.api_key
          params[Api::Param::LOGIN_ID] = @param.login_id
          params[Api::Param::LOGIN_PASS] = @param.login_pass
          params["base-serial"] = @base_serial
          params["remote-serial"] = @remote_serial

          params
        end
      end
    end
  end
end
