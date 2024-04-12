require "test_helper"

class PortableText::Html::MarkDefs::BaseTest < Minitest::Test
  def setup
    @mandatory_params = {
      key: "123",
      type: "link"
    }

    @mark_def = new_mark_def(**@mandatory_params)
  end

  def test_includes_action_view_helpers_tag_helper
    assert_includes PortableText::Html::MarkDefs::Base.included_modules, ActionView::Helpers::TagHelper
  end

  def new_mark_def(**params)
    PortableText::Html::MarkDefs::Base.new(**params)
  end

  def test_key_is_mandatory
    error = assert_raises(KeyError) do
      new_mark_def(**@mandatory_params.except(:key))
    end

    assert_includes(error.message, "key")
  end

  def test_type_is_mandatory
    error = assert_raises(KeyError) do
      new_mark_def(**@mandatory_params.except(:type))
    end

    assert_includes(error.message, "type")
  end

  def test_content_defaults_to_nil
    mark_def = new_mark_def(**@mandatory_params)
    assert_nil mark_def.content
  end

  def test_render_raises_unimplemented_error
    base = new_mark_def(**@mandatory_params)
    assert_raises(PortableText::Errors::UnimplementedError) { base.render }
  end
end
