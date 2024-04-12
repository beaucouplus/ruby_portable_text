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

  def test_link_is_a_child_of_base
    assert PortableText::MarkDefs::Link < PortableText::MarkDefs::Base
  end

  def new_link(**params)
    PortableText::MarkDefs::Link.new(**params)
  end

  def test_href_is_mandatory
    error = assert_raises(KeyError) do
      new_link(**@mandatory_params.except(:href))
    end

    assert_includes(error.message, "href")
  end

  def test_responds_to_href
    assert_equal("https://example.com", @mark_def.href)
  end
end
