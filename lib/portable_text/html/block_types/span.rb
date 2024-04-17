module PortableText
  module Html
    module BlockTypes
      class Span < Html::BaseComponent
        include ActionView::Helpers::TagHelper
        include Configured

        param :span
        option :mark_defs, default: proc { [] }
        delegate :marks, :text, to: :@span

        def view_template
          generate_nested_tags(marks: marks, inner_html: text)
        end

        private

        def visit(mark, &block)
          if matching_mark_def?(mark)
            annotation = @mark_defs.find { |mark_def| mark_def.key == mark }

            annotation_klass(annotation).new(
              annotation,
              content: block.call
            )

          else
            decorator(mark, inner_html: block.call)
          end
        end

        def generate_nested_tags(marks:, inner_html: nil)
          return plain(inner_html) if marks.empty?

          inner_mark = marks.pop

          if matching_mark_def?(inner_mark)
            annotation = @mark_defs.find { |mark_def| mark_def.key == inner_mark }

            html_annotation = annotation_klass(annotation).new(
              annotation,
              content: inner_html
            )
            inner_tag = html_annotation
          else
            inner_tag = decorator(inner_mark, inner_html: inner_html)
          end

          puts "inner tag"
          puts inner_tag
          puts inner_html

          return inner_tag if marks.empty?

          generate_nested_tags(marks: marks, inner_html: inner_tag)
        end

        def annotation_klass(annotation)
          config.block.mark_defs.fetch(annotation.type.to_sym, Html::MarkDefs::Null)
        end

        def matching_mark_def?(mark)
          return false unless @mark_defs.present?

          @mark_defs.map(&:key).include?(mark)
        end

        def decorator(mark, inner_html: nil)
          decorator = config.span.marks.fetch(mark.to_sym, { node: :span })

          node = decorator.fetch(:node)
          node_arguments = decorator.except(:node)
          send(node, **node_arguments) { inner_html }
        end
      end
    end
  end
end
