module PortableText
  module Html
    module BlockTypes
      class Span
        include ActionView::Helpers::TagHelper
        extend Dry::Initializer
        include Configured

        param :span
        option :mark_defs, default: proc { [] }
        delegate :marks, :text, to: :span

        def render
          generate_nested_tags(marks: marks, inner_html: text, mark_defs: mark_defs)
        end

        private

        def generate_nested_tags(marks:, inner_html: nil, mark_defs: nil)
          return inner_html if marks.empty?

          inner_mark = marks.pop

          if matching_mark_def?(inner_mark)
            annotation = mark_defs.find { |mark_def| mark_def.key == inner_mark }

            html_annotation = annotation_klass(annotation).new(
              annotation,
              content: inner_html
            )
            inner_tag = html_annotation.render
          else
            inner_tag = decorator(inner_mark, inner_html: inner_html)
          end

          return inner_tag if marks.empty?

          generate_nested_tags(marks: marks, inner_html: inner_tag, mark_defs: mark_defs)
        end

        def annotation_klass(annotation)
          config.block.mark_defs.fetch(annotation.type.to_sym)
        end

        def matching_mark_def?(mark)
          return false unless mark_defs.present?

          mark_defs.map(&:key).include?(mark)
        end

        def decorator(mark, inner_html:)
          decorator = config.span.marks.fetch(mark.to_sym)

          node = decorator.fetch(:node)
          node_arguments = decorator.except(:node)
          tag.send(node, inner_html, **node_arguments)
        end
      end
    end
  end
end
