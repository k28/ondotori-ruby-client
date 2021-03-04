# frozen_string_literal: true

module Ondotori
  module WebAPI
    module Api
      class ParamsBase
        def initialize(param)
          @param = param
        end

        def to_ondotori_param
          params = {}
          params[Api::Param::API_KEY] = @param.api_key
          params[Api::Param::LOGIN_ID] = @param.login_id
          params[Api::Param::LOGIN_PASS] = @param.login_pass

          params
        end
      end

      class CurrentParams < ParamsBase
        def initialize(param, remote: [], base: [])
          super(param)

          if remote.length.positive? && base.length.positive?
            raise Ondotori::WebAPI::Api::Errors::InvaildParameter.new(
              "Both remote_serial_list and base_serial_list cannot be set.", 9998
            )
          end
          @remote_serial_list = remote
          @base_serial_list = base
        end

        def to_ondotori_param
          params = super
          params["remote-serial"] = @remote_serial_list if @remote_serial_list.length.positive?
          params["base-serial"] = @base_serial_list if @base_serial_list.length.positive?

          params
        end
      end

      class LatestDataParams < ParamsBase
        def initialize(param, serial: "")
          super(param)
          if serial.empty?
            raise Ondotori::WebAPI::Api::Errors::InvaildParameter.new(
              "latest-data need remote-serial", 9994
            )
          end
          @remote_serial = serial
        end

        def to_ondotori_param
          params = super
          params["remote-serial"] = @remote_serial

          params
        end
      end

      class LatestDataRTR500Params < ParamsBase
        def initialize(param, base: "", remote: "")
          super(param)
          if base.empty? || remote.empty?
            raise Ondotori::WebAPI::Api::Errors::InvaildParameter.new(
              "latest-data-rtr500 need both the  baseunit serial and remote unit serial.", 9993
            )
          end
          @base_serial = base
          @remote_serial = remote
        end

        def to_ondotori_param
          params = super
          params["base-serial"] = @base_serial
          params["remote-serial"] = @remote_serial

          params
        end
      end

      class DataParams < ParamsBase
        def initialize(param, serial, data_range: nil)
          super(param)
          validate(serial)
          @data_range = data_range
          @serial = serial
        end

        def validate(serial)
          unless serial.instance_of?(String)
            raise Ondotori::WebAPI::Api::Errors::InvaildParameter.new(
              "serial must be String.", 9991
            )
          end
        end

        def to_ondotori_param
          params = super
          params["remote-serial"] = @serial
          @data_range&.add_data_range(params)

          params
        end
      end

      class DataRTR500Params < DataParams
        def initialize(param, serial, base, data_range: nil)
          super(param, serial, data_range: data_range)
          validate_base(base)
          @base =  base
        end

        def validate_base(base)
          unless base.instance_of?(String)
            raise Ondotori::WebAPI::Api::Errors::InvaildParameter.new(
              "base unit serial must be String.", 9991
            )
          end
        end

        def to_ondotori_param
          params = super
          params["base-serial"] = @base

          params
        end
      end
    end
  end
end
