# frozen_string_literal: true

require "dry/configurable"
require "dry/inflector"
require "dry/initializer"
require "zeitwerk"
require "action_view"
require "phlex"

module PortableText
end

loader = Zeitwerk::Loader.for_gem
loader.setup
