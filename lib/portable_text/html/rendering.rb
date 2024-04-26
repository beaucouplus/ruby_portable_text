module PortableText
  module Html
    module Rendering
      def render(view, **parameters) = view.call(**parameters)
    end
  end
end
