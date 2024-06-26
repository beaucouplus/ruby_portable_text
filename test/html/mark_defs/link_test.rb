require "test_helper"

class PortableText::Html::MarkDefs::LinkTest < Minitest::Test
  include Phlex::Testing::ViewHelper

  def setup
    @link = PortableText::MarkDefs::Link.new(
      _key: "123",
      _type: "link",
      href: "http://example.com"
    )
  end

  def test_delegate_href_to_link
    mark_def = PortableText::Html::MarkDefs::Link.new(@link)
    assert_equal @link.href, mark_def.href
  end

  def test_render_creates_a_tag_with_content_and_href
    mark_def = PortableText::Html::MarkDefs::Link.new(@link) { "Example" }
    assert_equal '<a href="http://example.com">Example</a>', render(mark_def)
  end
end
