module PortableText
  module Errors
    class UnimplementedError < StandardError
      def initialize(msg = "Please implement this method")
        super
      end
    end
  end
end
