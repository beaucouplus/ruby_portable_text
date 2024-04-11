module PortableText
  module Html
    module Content
      class List
        extend Dry::Initializer
        include ActionView::Helpers::TagHelper
        include Configured

        param :list
        delegate :items, :list_type, to: :list

        LIST_TYPES = {
          bullet: :ul,
          numeric: :ol
        }.freeze

        def render
          blocks = items.map do |block|
            block_type(block.type).new(block).render
          end

          list = LIST_TYPES.fetch(list_type.to_sym)
          tag.send(list, safe_join(blocks))
        end
      end
    end
  end
end
