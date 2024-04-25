require "test_helper"

class PortableText::Html::MarkDefs::BaseTest < Minitest::Test
  include Phlex::Testing::ViewHelper

  def setup
    @mark_def = PortableText::MarkDefs::Base.new(
      _key: "123",
      _type: "link"
    )

    @html_mark_def = new_mark_def
  end

  def new_mark_def(**params)
    PortableText::Html::MarkDefs::Base.new(@mark_def, **params)
  end

  def test_render_raises_unimplemented_error
    assert_raises(PortableText::Errors::UnimplementedError) { render @html_mark_def }
  end
end
