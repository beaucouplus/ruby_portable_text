module PortableText
  module BlockTypes
    class Span
      extend Dry::Initializer

      option :marks, default: proc { [] }
      option :_key, as: :key
      option :_type, as: :type
      option :text, default: proc { nil }
    end
  end
end
