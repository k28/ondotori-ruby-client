# frozen_string_literal: true

module Ondotori
  module WebAPI
    module Api
      class DataRange
        attr_reader :from, :to, :limit

        def initialize(from: nil, to: nil, limit: nil)
          validate(from, to, limit)

          @from = from
          @to = to
          @limit = limit.nil? ? 0 : [0, limit].max
        end

        def validate(from, to, _limit)
          [from, to].each do |param|
            next if param.nil? || param.instance_of?(Time)

            raise Ondotori::WebAPI::Api::Errors::InvaildParameter.new(
              "from and to parameter must be nil or Time.", 9992
            )
          end
        end

        def add_data_range(params)
          params["unixtime-from"] = @from.to_i unless @from.nil?
          params["unixtime-to"] = @to.to_i unless @to.nil?
          params["number"] = @limit if @limit != 0
        end
      end
    end
  end
end
