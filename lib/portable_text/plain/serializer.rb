module PortableText
  module Plain
    class Serializer
      def initialize(blocks)
        @blocks = blocks
      end

      def content(**_params)
        visit(@blocks)
      end

      private

      def visit(nodes)
        nodes.map do |block|
          case block.type
          when "block"
            block.children.map(&:text).join(" ").squish
          when "list"
            visit(block.items)
          when "image"
            if block.asset.present?
              block.asset["url"]
            else
              "image url not found"
            end
          else
            "Block #{block.type} found"
          end
        end.join("\n")
      end
    end
  end
end
