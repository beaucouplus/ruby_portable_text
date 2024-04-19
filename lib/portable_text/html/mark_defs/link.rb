module PortableText
  module Html
    module MarkDefs
      class Link < Base
        delegate :href, to: :@mark_def

        def view_template(&block)
          a(href: href, &block)
        end
      end
    end
  end
end
