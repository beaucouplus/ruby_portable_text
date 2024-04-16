require "test_helper"

class PortableText::Html::BlockTypes::BlockTest < Minitest::Test
  def setup
    @block_params = {
      _key: "36be0ac1493e",
      _type: "block",
      markDefs: [],
      style: "h1"
    }
  end

  def test_delegate_methods_to_block
    block = PortableText::BlockTypes::Block.new(**@block_params)
    html_block = PortableText::Html::BlockTypes::Block.new(block)
    assert_equal block.style, html_block.style
    assert_equal block.children, html_block.children
    assert_equal block.mark_defs, html_block.mark_defs
    assert_equal block.list_item, html_block.list_item
  end

  def test_render_creates_a_tag_matching_the_style
    block = PortableText::BlockTypes::Block.new(**@block_params)
    html_block = PortableText::Html::BlockTypes::Block.new(block)
    assert_equal "<h1></h1>", html_block.render
  end

  def test_when_children_creates_a_tag_with_children_as_inside_nodes
    block = PortableText::BlockTypes::Block.new(**@block_params.merge(
      children: [
        PortableText::BlockTypes::Span.new(
          _key: "f55398075dd5",
          _type: "span",
          marks: [],
          text: "Title h1"
        )
      ]
    ))
    html_block = PortableText::Html::BlockTypes::Block.new(block)
    assert_equal "<h1>Title h1</h1>", html_block.render
  end

  def test_when_node_style_unknwon_defaults_to_p
    block = PortableText::BlockTypes::Block.new(**@block_params.merge(style: "something"))
    html_block = PortableText::Html::BlockTypes::Block.new(block)
    assert_equal "<p></p>", html_block.render
  end
end
