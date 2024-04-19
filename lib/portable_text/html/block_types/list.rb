module PortableText
  module Html
    module BlockTypes
      class List < Html::BaseComponent
        include Configured

        param :list
        delegate :items, :list_type, to: :@list

        def view_template
          node_style = node.fetch(:node)
          node_arguments = node.except(:node)

          send(node_style, **node_arguments) do
            items.each do |block|
              render block_type(block.type).new(block)
            end
          end
        end

        private

        def node
          @node ||= config.block.list_types.fetch(list_type.to_sym, { node: :ul })
        end
      end
    end
  end
end
