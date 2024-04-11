module PortableText
  module MarkDefs
    class Base
      extend Dry::Initializer

      option :_key, as: :key
      option :_type, as: :type
    end
  end
end
