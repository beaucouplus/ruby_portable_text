module PortableText
  module Html
    module BlockTypes
      class Span < Html::BaseComponent
        include Configured

        param :span
        option :mark_defs, default: proc { [] }
        delegate :marks, :text, to: :@span

        def view_template
          root = create_nodes
          visit(root)
        end

        private

        def visit(node)
          return plain(node.value) if node.child.nil?

          if matching_mark_def?(node.value)
            annotation = @mark_defs.find { |mark_def| mark_def.key == node.value }

            render annotation_klass(annotation).new(annotation) do
              visit(node.child)
            end
          else
            decorator = config.span.marks.fetch(node.value.to_sym, { node: :span })
            mark_node = decorator.fetch(:node)
            node_arguments = decorator.except(:node)

            send(mark_node, **node_arguments) { visit(node.child) }
          end
        end

        def annotation_klass(annotation)
          config.block.mark_defs.fetch(annotation.type.to_sym, Html::MarkDefs::Null)
        end

        def matching_mark_def?(mark)
          return false unless @mark_defs.present?

          @mark_defs.map(&:key).include?(mark)
        end

        class Node
          attr_accessor :value, :child

          def initialize(value:, child: nil)
            @value = value
            @child = child
          end
        end

        def create_nodes
          nodes = marks + [text]
          root = Node.new(value: nodes.first)
          current_node = root

          return root if nodes.size == 1

          nodes[1..].each do |mark|
            current_node.child = Node.new(value: mark)
            current_node = current_node.child
          end

          root
        end
      end
    end
  end
end
