module PortableText
    class Renderer
  attr_reader :content, :blocks, :to

  def initialize(content:, to: :html)
    @content = content
    @blocks = []
    @to = to
  end

  def render
    content.each do |block_params|
      params = block_params.transform_keys(&:to_sym)
      params[:children] = create_children(params[:children])
      params[:markDefs] = create_mark_defs(params[:markDefs])

      block = block_klass(params.fetch(:_type)).new(**params)
      add_block(block)
    end

    renderer = Config.serializers.fetch(to)
    renderer.new(blocks).render
  end

  private

  def block_klass(type)
    PortableText::Config.block.types.fetch(type.to_sym)
  end

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
    return if children.blank?

    children.map do |child|
      block_klass(:span).new(**child.transform_keys(&:to_sym))
    end
  end

  def create_mark_defs(mark_defs)
    return if mark_defs.blank?

    inflector = Dry::Inflector.new

    mark_defs.map do |mark_def|
      mark_type = inflector.underscore(mark_def["_type"]).to_sym
      PortableText::Config.block.mark_defs.fetch(mark_type).new(**mark_def.transform_keys(&:to_sym).merge(_type: mark_type))
    end
  end
end
end
