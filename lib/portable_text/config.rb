module PortableText
  module Config
    extend Dry::Configurable

    setting :block, reader: true do
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
      html: Html::Serializer
    }, reader: true
  end
end
