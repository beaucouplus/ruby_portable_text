module PortableText
  module Html
    class Serializer < Html::BaseComponent
      include Configured

      param :blocks

      def content(**_options) = self

      def view_template
        @blocks.each do |block|
          render block_type(block.type).new(block)
        end
      end
    end
  end
end
