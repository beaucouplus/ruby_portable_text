module PortableText
  class Config
    extend Dry::Configurable

    # Default settings
    # These can be overridden
    # Example: PortableText.config.block.types.merge!({ block: MyCustomBlock })

    setting :block do
      setting :types, default: {
        block: BlockTypes::Block,
        image: BlockTypes::Image,
        list: BlockTypes::List,
        span: BlockTypes::Span
      }

      setting :mark_defs, default: {
        link: MarkDefs::Link
      }
    end

    setting :serializers, default: {
      html: Html::Serializer,
      plain: Plain::Serializer
    }
  end
end
