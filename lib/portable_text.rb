# frozen_string_literal: true

require "dry/configurable"
require "dry/inflector"
require "dry/initializer"
require "zeitwerk"

module PortableText
end

loader = Zeitwerk::Loader.for_gem
loader.setup
