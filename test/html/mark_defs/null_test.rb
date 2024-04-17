require "test_helper"

class PortableText::Html::MarkDefs::NullTest < Minitest::Test
  def test_render_creates_div_tag_with_alert_message
    null_mark_def = PortableText::MarkDefs::Null.new(
      _key: "123",
      _type: "not_found"
    )

    html_mark_def = PortableText::Html::MarkDefs::Null.new(null_mark_def)
    assert_equal(
      "<div>Missing mark def html renderer for type: not_found - key: 123</div>",
      html_mark_def.render
    )
  end
end
