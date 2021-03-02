# frozen_string_literal: true

module Ondotori
  module WebAPI
    class Client
      def initialize(params = {}, uri: "")
        @param = Ondotori::WebAPI::Api::Param.new(params)
        @web_access = Ondotori::WebAPI::HttpWebAccess.new(30)
        @ondotori_uri = Ondotori::WebAPI::Api::URI.new(@param.login_id)
        @uri = uri
      end

      def access_server(param, uri)
        response = @web_access.access(uri, param.to_ondotori_param)
        ondotori_response = Ondotori::WebAPI::Api::Response.new(response)
        ondotori_response.result
      end

      def current(remote_serial_list: [], base_serial_list: [])
        param = Api::CurrentParams.new(@param, remote: remote_serial_list, base: base_serial_list)
        access_server(param, "#{base_uri}current")
      end

      def latest_data(serial)
        param = Api::LatestDataParams.new(@param, serial: serial)
        access_server(param, "#{base_uri}latest-data")
      end

      def latest_data_rtr500(base: "", remote: "")
        param = Api::LatestDataRTR500Params.new(@param, base: base, remote: remote)
        access_server(param, "#{base_uri}latest-data-rtr500")
      end

      def data(serial, from: nil, to: nil, limit: nil)
        param = Api::DataParams.new(@param, serial, from: from, to: to, limit: limit)
        access_server(param, "#{base_uri}data")
      end

      def base_uri
        return @uri unless @uri.empty?

        @ondotori_uri.uri
      end

      attr_writer :web_access
    end
  end
end
