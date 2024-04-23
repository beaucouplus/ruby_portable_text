module PortableText
  class Serializer
    attr_reader :content, :blocks, :to, :converted

    def initialize(content:, to: :html)
      @content = content
      @blocks = []
      @to = to
      @converted = false
    end

    # After conversion, the Portable Text content is serialized to the desired format.
    # The serializer is determined by the `to` parameter, which defaults to `:html`.
    # The serializer must be defined in the PortableText configuration and respond to `call`.
    def render
      convert!

      serializer = config.serializers.fetch(to) { raise Errors::UnknownSerializerError }
      serializer.new(blocks).call
    end

    # Converts the Portable Text content into a collection of blocks converted to ruby objects
    # along with their children and markDefs.
    # Object parameters are symbolized and camelCase keys are converted to snake_case.
    # This method is idempotent.
    def convert!
      return if converted

      content.each do |block_params|
        params = block_params.transform_keys(&:to_sym)
        params[:children] = create_children(params[:children])
        params[:markDefs] = create_mark_defs(params[:markDefs])

        block = block_klass(params.fetch(:_type)).new(**params)
        add_block(block)
      end

      @converted = true
    end

    private

    def config = PortableText.config

    def block_klass(type)
      config.block.types.fetch(type.to_sym, BlockTypes::Null)
    end

    # Adds a block to the blocks collection.
    # If the block is a list item, it will be added to the last list block if it exists.
    # Else a new list block will be created.
    def add_block(block)
      return blocks.push(block) unless block.list_item?

      last_block = blocks.last

      if last_block&.list?
        last_block.add(block)
      else
        blocks.push(
          block_klass(:list).new(
            items: [block],
            level: block.level,
            parent: nil
          )
        )
      end
    end

    def create_children(children)
      return [] if children.blank?

      children.map do |child|
        block_klass(:span).new(**child.transform_keys(&:to_sym))
      end
    end

    def create_mark_defs(mark_defs)
      return [] if mark_defs.blank?

      inflector = Dry::Inflector.new

      mark_defs.map do |mark_def|
        mark_def.transform_keys!(&:to_sym)
        mark_type = inflector.underscore(mark_def[:_type]).to_sym

        config.block.mark_defs.fetch(
          mark_type,
          MarkDefs::Null
        ).new(**mark_def.merge(_type: mark_type))
      end
    end
  end
end
