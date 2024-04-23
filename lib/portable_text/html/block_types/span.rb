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

        # Visit a node and render it
        # If the node is a mark definition, render the appropriate mark definition
        # Otherwise, render the node with the appropriate mark decorator
        # If the node has a child, visit the child
        # Else render the node as plain text
        # -------------
        # Mark definitions and mark decorators are defined in the configuration
        # If a mark definition is not found, a Null mark definition is rendered along with an error message
        # if a mark is not found, a span tag is rendered
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

        # Create a linked list of nodes to make it easier to traverse the tree of marks
        # Marks are traversed in the marks order and the text is the last node
        def create_nodes
          nodes = marks + [text]

          root = Node.new(value: nodes.first)
          return root if nodes.size == 1

          current_node = root

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
