module PortableText
  module Html
    module MarkDefs
      class Base < Html::BaseComponent
        param :mark_def
        delegate :type, :key, to: :@mark_def

        def view_template
          raise PortableText::Errors::UnimplementedError
        end
      end
    end
  end
end
