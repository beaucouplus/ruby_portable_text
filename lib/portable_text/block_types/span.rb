module PortableText
  module Content
    class Span
      extend Dry::Initializer

      option :marks, default: proc { [] }
      option :_key, as: :key
      option :_type, as: :type
      option :text, optional: true
    end
  end
end
