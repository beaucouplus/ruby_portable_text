# Base component for PortableText HTML components
# It overrides Dry::Initializer option and params to allow using them without triggering weird errors
# See https://github.com/orgs/phlex-ruby/discussions/553

module PortableText
  module Html
    class BaseComponent < Phlex::HTML
      extend Dry::Initializer

      def self.option(*args, **kwargs, &block)
        super(*args, reader: false, **kwargs, &block)
      end

      def self.param(*args, **kwargs, &block)
        super(*args, reader: false, **kwargs, &block)
      end
    end
  end
end
