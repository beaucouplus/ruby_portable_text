module PortableText
  module Html
    module MarkDefs
      class Base < Html::BaseComponent
        include ActionView::Helpers::TagHelper

        param :mark_def, reader: true
        option :content, default: proc { nil }, reader: true
        delegate :type, :key, to: :mark_def

        def view_template
          raise PortableText::Errors::UnimplementedError
        end
      end
    end
  end
end
