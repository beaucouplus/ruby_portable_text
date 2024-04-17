module PortableText
  module Html
    module MarkDefs
      class Link < Base
        delegate :href, to: :@mark_def

        def view_template
          a(href: href) { @content }
        end
      end
    end
  end
end
