module PortableText
  module Html
    module BlockTypes
      class Block
        include ActionView::Helpers::TagHelper
        include Configured
        extend Dry::Initializer
        extend Dry::Configurable

        param :block
        delegate :style, :children, :mark_defs, :list_item, to: :block

        def render
          node_style = node.fetch(:node)
          node_arguments = node.except(:node)

          return tag.send(node_style, **node_arguments) unless children.present?

          children_nodes = children.map do |child|
            span = block_type(:span).new(child, mark_defs:)
            span.render
          end

          tag.send(node_style, safe_join(children_nodes), **node_arguments)
        end

        private

        def node
          return @node if defined?(@node)
          return @node = config.block.nodes.fetch(:li) if list_item.present?

          @node = config.block.nodes.fetch(style&.to_sym, :p)
        end
      end
    end
  end
end
