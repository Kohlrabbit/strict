# frozen_string_literal: true

require_relative "strict/version"
require_relative "strict/validator"
require_relative "strict/types"
require_relative "strict/hash"
require_relative "strict/errors"
require_relative "strict/string"

module Strict
  class Error < StandardError; end
end