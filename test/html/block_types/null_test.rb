require "test_helper"

class PortableText::Html::BlockTypes::NullTest < Minitest::Test
  def test_render_creates_div_tag_with_alert_message
    block = PortableText::BlockTypes::Null.new(_key: "123", _type: "not_found")
    html_block = PortableText::Html::BlockTypes::Null.new(block)

    assert_equal(
      "<div>This block type is not referenced yet: not_found</div>",
      html_block.call
    )
  end
end
