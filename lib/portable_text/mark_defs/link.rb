module PortableText
  module MarkDefs
    class Link < Base
      option :href, default: proc { "" }
    end
  end
end
