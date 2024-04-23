module PortableText
  module Html
    class Config
      extend Dry::Configurable

      setting :block do
        setting :types, default: {
          block: Html::BlockTypes::Block,
          image: Html::BlockTypes::Image,
          list: Html::BlockTypes::List,
          span: Html::BlockTypes::Span
        }

        setting :styles, default: {
          h1: { node: :h1 },
          h2: { node: :h2 },
          h3: { node: :h3 },
          h4: { node: :h4 },
          h5: { node: :h5 },
          h6: { node: :h6 },
          blockquote: { node: :blockquote },
          normal: { node: :p },
          li: { node: :li }
        }

        setting :mark_defs, default: {
          link: Html::MarkDefs::Link
        }

        setting :list_types, default: {
          bullet: { node: :ul },
          numeric: { node: :ol }
        }
      end

      setting :span do
        setting :marks, default: {
          strong: { node: :strong },
          em: { node: :em }
        }
      end
    end
  end
end
