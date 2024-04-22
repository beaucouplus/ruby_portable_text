require "test_helper"

class PortableText::BlockTypes::SpanTest < Minitest::Test
  def setup
    @mandatory_params = {
      _key: "123",
      _type: "span"
    }

    @span = new_span(**@mandatory_params)
  end

  def new_span(**params)
    PortableText::BlockTypes::Span.new(**params)
  end

  def test_key_is_mandatory
    error = assert_raises(KeyError) do
      new_span(**@mandatory_params.except(:_key))
    end

    assert_includes(error.message, "_key")
  end

  def test_type_is_mandatory
    error = assert_raises(KeyError) do
      new_span(**@mandatory_params.except(:_type))
    end

    assert_includes(error.message, "_type")
  end

  def test_marks_defaults_to_empty_array
    assert_equal([], @span.marks)
  end

  def test_key_is_converted
    assert_respond_to(@span, :key)
  end

  def test_type_is_converted
    assert_respond_to(@span, :type)
  end

  def test_text_is_optional
    assert_respond_to(@span, :text)

    span = new_span(**@mandatory_params.merge(text: "welcome"))
    assert_equal("welcome", span.text)
  end
end
