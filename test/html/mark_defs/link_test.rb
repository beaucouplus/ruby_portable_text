require "test_helper"

class PortableText::Html::MarkDefs::LinkTest < Minitest::Test
  def setup
    @link = PortableText::MarkDefs::Link.new(
      _key: "123",
      _type: "link",
      href: "http://example.com"
    )

    @required_params = {
      key: "123",
      type: "link"
    }
  end

  def test_delegate_href_to_link
    mark_def = PortableText::Html::MarkDefs::Link.new(@link, **@required_params)
    assert_equal "http://example.com", mark_def.href
  end

  def test_render_creates_a_tag_with_content_and_href
    mark_def = PortableText::Html::MarkDefs::Link.new(@link, content: "Example", **@required_params)
    assert_equal '<a href="http://example.com">Example</a>', mark_def.render
  end
end
