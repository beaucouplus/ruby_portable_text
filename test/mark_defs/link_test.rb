require "test_helper"

class PortableText::MarkDefs::LinkTest < Minitest::Test
  def setup
    @mandatory_params = {
      _key: "123",
      _type: "link",
      href: "https://example.com"
    }

    @mark_def = new_link(**@mandatory_params)
  end

  def new_link(**params)
    PortableText::MarkDefs::Link.new(**params)
  end

  def test_link_is_a_child_of_base
    assert PortableText::MarkDefs::Link < PortableText::MarkDefs::Base
  end

  def test_href_defaults_to_empty_string
    link = new_link(**@mandatory_params.except(:href))
    assert_equal("", link.href)
  end

  def test_responds_to_href
    assert_equal("https://example.com", @mark_def.href)
  end
end
