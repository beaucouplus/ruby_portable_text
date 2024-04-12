require "test_helper"

class PortableText::Html::MarkDefs::NullTest < Minitest::Test
  def test_render_creates_div_tag_with_alert_message
    mark_def = PortableText::Html::MarkDefs::Null.new(key: "123", type: "not_found")
    assert_equal(
      "<div>Missing mark def html renderer for type: not_found - key: 123</div>",
      mark_def.render
    )
  end
end
