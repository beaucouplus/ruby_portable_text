module PortableText
  module Html
    module MarkDefs
      class Null < Base
        def render
          tag.div(
            "Missing mark def html renderer for type: #{type} - key: #{key}"
          )
        end
      end
    end
  end
end
