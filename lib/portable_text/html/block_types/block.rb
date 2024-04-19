module PortableText
  module Html
    module BlockTypes
      class Block < Html::BaseComponent
        include Configured

        param :block
        delegate :style, :children, :mark_defs, :list_item, to: :@block

        def view_template
          node_style = node.fetch(:node)
          node_arguments = node.except(:node)

          send(node_style, **node_arguments) do
            children.each do |child|
              render block_type(:span).new(child, mark_defs: mark_defs)
            end
          end
        end

        private

        def node
          return @node if defined?(@node)
          return @node = config.block.nodes.fetch(:li) if list_item.present?

          @node = config.block.nodes.fetch(style&.to_sym, { node: :p })
        end
      end
    end
  end
end
