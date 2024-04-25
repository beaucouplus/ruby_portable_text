# frozen_string_literal: true

require "active_support"
require "active_support/core_ext"
require "dry/configurable"
require "dry/inflector"
require "dry/initializer"
require "zeitwerk"
require "phlex"

module PortableText
  def self.config = Config.config

  module Html
    def self.config = Html::Config.config
  end
end

loader = Zeitwerk::Loader.for_gem
loader.setup
