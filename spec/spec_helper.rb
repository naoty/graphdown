require File.expand_path("../lib/graphdown", File.dirname(__FILE__))
require "pathname"
require "redcarpet"

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.order = "random"
end
