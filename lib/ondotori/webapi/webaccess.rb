# frozen_string_literal: true

module Ondotori
  module WebAPI
    class WebAccess
      def initialize(timeout)
        @timeout = timeout
      end

      def access(_uri, _params)
        raise NotImplementedError, "Implementation required."
      end
    end

    class StbWebAccess < WebAccess
      attr_reader :params, :uri

      def initialize(timeout, on_access)
        super timeout
        @on_access = on_access
      end

      def access(uri, params)
        @uri = uri
        @params = params
        @on_access.call(self)
      end

      attr_writer :on_access
    end
  end
end
