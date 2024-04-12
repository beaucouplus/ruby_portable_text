require "test_helper"

class PortableText::BlockTypes::BaseTest < Minitest::Test
  def setup
    @mandatory_params = {
      markDefs: [],
      _key: "123",
      _type: "block"
    }
    @block = new_block(**@mandatory_params)
  end

  def new_block(**params)
    PortableText::BlockTypes::Base.new(**params)
  end

  def test_key_is_mandatory
    error = assert_raises(KeyError) do
      new_block(**@mandatory_params.except(:_key))
    end

    assert_includes(error.message, "_key")
  end

  def test_type_is_mandatory
    error = assert_raises(KeyError) do
      new_block(**@mandatory_params.except(:_type))
    end

    assert_includes(error.message, "_type")
  end

  def test_key_is_converted
    assert_respond_to(@block, :key)
  end

  def test_type_is_converted
    assert_respond_to(@block, :type)
  end

  # rubocop:disable Naming/MethodName

  def test_markDefs_is_converted
    assert_respond_to(@block, :mark_defs)
  end

  def test_listItem_is_converted
    assert_respond_to(@block, :list_item)
  end

  def test_list_is_false
    refute(@block.list?)
  end

  def test_list_item_method_values
    block = new_block(**@mandatory_params.merge(listItem: false))
    refute(block.list_item?)

    block = new_block(**@mandatory_params.merge(listItem: true))
    assert(block.list_item?)
  end

  def test_children_defaults_to_empty_array
    assert_equal([], @block.children)

    block = new_block(**@mandatory_params.merge(children: [1]))
    assert_equal([1], block.children)
  end

  def test_mark_defs_defaults_to_empty_array
    assert_equal([], @block.mark_defs)

    block = new_block(**@mandatory_params.merge(markDefs: [1]))
    assert_equal([1], block.mark_defs)
  end

  def test_style_is_optional
    assert_respond_to(@block, :style)

    block = new_block(**@mandatory_params.merge(style: "h1"))
    assert_equal("h1", block.style)
  end

  def test_level_is_optional
    assert_respond_to(@block, :level)

    block = new_block(**@mandatory_params.merge(level: 1))
    assert_equal(1, block.level)
  end

  def test_asset_is_optional
    assert_respond_to(@block, :asset)

    asset = { "url": "http://example.com" }
    block = new_block(**@mandatory_params.merge(asset: asset))
    assert_equal(asset, block.asset)
  end
  # rubocop:enable Naming/MethodName
end
