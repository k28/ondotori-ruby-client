# frozen_string_literal: true

require "test_helper"

module Ondotori
  class OndotoriTest < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil Ondotori::VERSION
    end
  end
end
