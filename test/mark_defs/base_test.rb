require "test_helper"

class PortableText::MarkDefs::BaseTest < Minitest::Test
  def setup
    @mandatory_params = {
      _key: "123",
      _type: "link"
    }

    @mark_def = new_mark_def(**@mandatory_params)
  end

  def new_mark_def(**params)
    PortableText::MarkDefs::Base.new(**params)
  end

  def test_key_is_mandatory
    error = assert_raises(KeyError) do
      new_mark_def(**@mandatory_params.except(:_key))
    end

    assert_includes(error.message, "_key")
  end

  def test_type_is_mandatory
    error = assert_raises(KeyError) do
      new_mark_def(**@mandatory_params.except(:_type))
    end

    assert_includes(error.message, "_type")
  end

  def test_key_is_converted
    assert_respond_to(@mark_def, :key)
  end

  def test_type_is_converted
    assert_respond_to(@mark_def, :type)
  end
end
