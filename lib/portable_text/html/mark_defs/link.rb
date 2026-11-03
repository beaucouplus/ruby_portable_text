module PortableText
  module Html
    module MarkDefs
      class Link < Base
        delegate :href, to: :@mark_def

        def view_template(&block)
          if open_in_new_tab?
            a(href: href, class: "hw-link", target: "_blank", rel: "noopener noreferrer", &block)
          else
            a(href: href, class: "hw-link", &block)
          end
        end

        private

        def open_in_new_tab?
          return false if href.is_a?(String) && href.start_with?("#")

          blank = @mark_def.respond_to?(:blank) ? @mark_def.blank : nil
          return blank unless blank.nil?

          PortableText::Html::Url.external?(href)
        end
      end
    end
  end
end
