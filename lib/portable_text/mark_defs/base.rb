module PortableText
  module MarkDef
    class Base
      extend Dry::Initializer

      option :_key, as: :key
      option :_type, as: :type
    end
  end
end
