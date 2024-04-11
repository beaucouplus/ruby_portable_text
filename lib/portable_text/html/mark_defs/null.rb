module PortableText
  module Html
    module MarkDefs
      class Null < Base
        def render
          tag.div("Missing mark def html renderer")
        end
      end
    end
  end
end
