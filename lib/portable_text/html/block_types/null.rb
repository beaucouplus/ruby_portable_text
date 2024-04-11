module PortableText
  module Html
    module BlockTypes
      class Null
        include ActionView::Helpers::TagHelper
        extend Dry::Initializer

        param :block
        delegate :type

        def render
          tag.send(:div, "This block type is not referenced yet: #{type}")
        end
      end
    end
  end
end
