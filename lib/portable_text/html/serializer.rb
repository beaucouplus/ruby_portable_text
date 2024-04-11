module PortableText
  module Html
    class Serializer
      extend Dry::Initializer
      extend Dry::Configurable
      include ActionView::Helpers::TagHelper

      setting :block do
        setting :types, default: {
          block: Html::BlockTypes::Block,
          image: Html::BlockTypes::Image,
          list: Html::BlockTypes::List,
          span: Html::BlockTypes::Span
        }

        setting :nodes, default: {
          h1: { node: :h1 },
          h2: { node: :h2 },
          h3: { node: :h3 },
          h4: { node: :h4 },
          h5: { node: :h5 },
          h6: { node: :h6 },
          blockquote: { node: :blockquote },
          normal: { node: :p },
          li: { node: :li }
        }

        setting :mark_defs, default: {
          link: Html::MarkDefs::Link
        }
      end

      setting :span do
        setting :marks, default: {
          strong: { node: :strong },
          em: { node: :em }
        }
      end

      param :blocks

      def render
        nodes = blocks.map do |block|
          block_klass(block.type).new(block).render
        end

        safe_join(nodes)
      end

      def block_klass(type)
        self.class.config.block.types.fetch(type.to_sym, BlockTypes::Null)
      end
    end
  end
end
