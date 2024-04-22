module PortableText
  module Errors
    class UnknownSerializerError < StandardError
      def initialize(msg = "This serializer is not recognized by PortableText::Config.serializers")
        super
      end
    end
  end
end
