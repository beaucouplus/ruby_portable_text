module PortableText
  module Html
    module BlockTypes
      class Image
        include ActionView::Helpers::TagHelper
        extend Dry::Initializer

        param :image
        delegate :asset, to: :image

        def render
          if asset.key?("url")
            tag.img(src: asset["url"])
          else
            tag.div("Please provide a url for this image")
          end
        end
      end
    end
  end
end
