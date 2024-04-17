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
