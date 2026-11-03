module PortableText
  module MarkDefs
    class Link < Base
      option :href, default: proc { "" }
      # nil means the editor never set the field; an explicit false means
      # "open in the same tab" and must be honored by the renderer.
      option :blank, default: proc { nil }
    end
  end
end
