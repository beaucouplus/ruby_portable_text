module PortableText
  module Html
    module MarkDefs
      class Link < Base
        param :link
        delegate :href, to: :link

        def render
          tag.a(content, href: href)
        end
      end
    end
  end
end
