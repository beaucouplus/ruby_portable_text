module PortableText
  module BlockTypes
    class List
      extend Dry::Initializer

      option :list_type, default: proc { 'bullet' }
      option :items, default: proc { [] }
      option :level, default: proc { 1 }
      option :parent, default: proc { nil }

      def list? = true
      def type = :list

      def add(block)
        if block.level == level
          items << block
        elsif block.level > level
          add_child(block)
        else
          ancestor = find_matching_ancestor(block)
          ancestor.items << block
        end
      end

      protected

      def find_matching_ancestor(block)
        return self if block.level == level

        parent.find_matching_ancestor(block) if block.level != level
      end

      def add_child(block)
        sub_list = find_sub_list(block, level)

        if sub_list.present?
          sub_list.add(block)
        else
          items << List.new(items: [block], level: block.level, parent: self)
        end
      end

      def find_sub_list(block, current_level)
        target = block.level - 1

        sub_list = items.reverse.find do |item|
          item.list? && item.level == current_level + 1
        end

        return unless sub_list
        return sub_list if sub_list.level == target

        sub_list.find_sub_list(block, current_level + 1)
      end
    end
  end
end
