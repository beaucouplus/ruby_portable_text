module PortableText
  module BlockTypes
    class Base
      extend Dry::Initializer

      option :_key, as: :key
      option :_type, as: :type
      option :markDefs, as: :mark_defs, default: proc { [] }
      option :children, default: proc { [] }
      option :style, optional: true
      option :listItem, as: :list_item, optional: true
      option :level, optional: true
      option :asset, optional: true

      def list? = false
      def list_item? = list_item.present?
    end
  end
end
