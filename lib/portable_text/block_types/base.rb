module PortableText
  module BlockTypes
    class Base
      extend Dry::Initializer

      option :style, optional: true
      option :children, optional: true
      option :markDefs, as: :mark_defs
      option :_key, as: :key
      option :_type, as: :type
      option :listItem, as: :list_item, optional: true
      option :level, optional: true
      option :asset, optional: true

      def list? = false
      def list_item? = list_item.present?
    end
  end
end
