# frozen_string_literal: true

require "dry/configurable"
require "dry/inflector"
require "dry/initializer"
require "zeitwerk"
require "action_view"
require "phlex"

module PortableText
  def self.config = Config.config

  module Html
    # TODO: try implemting this config pattern
    # delegate :config, to: Html::Config
  end
end

loader = Zeitwerk::Loader.for_gem
loader.setup
