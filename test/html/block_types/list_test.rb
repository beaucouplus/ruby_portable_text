require "test_helper"

class PortableText::Html::BlockTypes::ListTest < Minitest::Test
  def setup
    @block_params = {
      _key: "36be0ac1493e",
      _type: "block",
      markDefs: [],
      level: 1,
      listItem: true,
      children: [
        PortableText::BlockTypes::Span.new(
          _key: "f55398075dd5",
          _type: "span",
          marks: [],
          text: "List item"
        )
      ]

    }
  end

  def test_delegate_methods_to_list
    list = PortableText::BlockTypes::List.new
    html_list = PortableText::Html::BlockTypes::List.new(list)

    assert_equal list.items, html_list.items
    assert_equal list.list_type, html_list.list_type
  end

  def test_render_creates_a_list_tag_matching_the_list_type
    list = PortableText::BlockTypes::List.new(list_type: :numeric)

    html_list = PortableText::Html::BlockTypes::List.new(list)
    assert_equal "<ol></ol>", html_list.render
  end

  def test_render_renders_list_chidren
    list = PortableText::BlockTypes::List.new
    list.add(PortableText::BlockTypes::Block.new(**@block_params))
    list.add(PortableText::BlockTypes::Block.new(**@block_params))

    html_list = PortableText::Html::BlockTypes::List.new(list)
    assert_equal "<ul><li>List item</li><li>List item</li></ul>", html_list.render
  end
end
