module PortableText
  module Html
    module BlockTypes
      class Null < Html::BaseComponent
        param :block

        def view_template
          div { "This block type is not referenced yet: #{@block.type}" }
        end
      end
    end
  end
end
