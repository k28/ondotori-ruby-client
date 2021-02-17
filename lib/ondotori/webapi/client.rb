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

      def current(remote_serial_list: [], base_serial_list: [])
        current_param = Api::CurrentParams.new(@param, remote: remote_serial_list, base: base_serial_list)
        response = @web_access.access("#{base_uri}current", current_param.to_ondotori_param)
        ondotori_response = Ondotori::WebAPI::Api::Response.new(response)
        ondotori_response.result
      end

      def base_uri
        return @uri unless @uri.empty?

        @ondotori_uri.uri
      end

      attr_writer :web_access
    end
  end
end
