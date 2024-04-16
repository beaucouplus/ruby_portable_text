module PortableText
  module Html
    module BlockTypes
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
          list = LIST_TYPES.fetch(list_type.to_sym, :ul)
          return tag.send(list) if items.empty?

          blocks = items.map do |block|
            block_type(block.type).new(block).render
          end

          tag.send(list, safe_join(blocks))
        end
      end
    end
  end
end
