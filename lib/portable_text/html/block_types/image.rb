module PortableText
  module Html
    module BlockTypes
      class Image < Html::BaseComponent
        param :image

        def view_template
          if @image.asset.key?("url")
            img(src: @image.asset["url"])
          else
            div { "Please provide a url for this image" }
          end
        end
      end
    end
  end
end
