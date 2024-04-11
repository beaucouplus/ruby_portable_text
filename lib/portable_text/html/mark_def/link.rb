module PortableText
  module Html
    module MarkDef
      class Link < Base
        param :link
        delegate :href, to: :link

        def render
          tag.a(content, href:)
        end
      end
    end
  end
end
