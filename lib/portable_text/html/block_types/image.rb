module PortableText
  module Html
    module Content
      class Image
        include ActionView::Helpers::TagHelper
        extend Dry::Initializer

        param :image
        delegate :asset, to: :image

        def render
          tag.img(src: asset['url'])
        end
      end
    end
  end
end
