module PortableText
  module Html
    module Configured
      def config
        Serializer.config
      end

      def block_type(type)
        config.block.types.fetch(type.to_sym)
      end
    end
  end
end
