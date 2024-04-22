require "test_helper"

class SerializerTest < Minitest::Test
  def setup
    @portable_text_block = { _key: "123", _type: "block" }
  end

  def test_triggers_error_when_to_param_does_not_have_matching_renderer
    serializer = PortableText::Serializer.new(
      content: [@portable_text_block],
      to: :unknown
    )

    assert_raises(PortableText::Errors::UnknownSerializerError) do
      serializer.render
    end
  end

  def test_convert_method_does_not_run_twice
    serializer = PortableText::Serializer.new(content: [@portable_text_block])

    refute serializer.converted

    serializer.convert!
    assert serializer.converted
    assert_equal 1, serializer.blocks.size

    serializer.convert!
    assert_equal 1, serializer.blocks.size
  end

  def test_block_defaults_to_null_when_type_not_recognized
    portable_text_block = { _key: "123", _type: "unknown" }

    serializer = PortableText::Serializer.new(content: [portable_text_block])
    serializer.convert!
    block = serializer.blocks.first
    assert_instance_of PortableText::BlockTypes::Null, block
  end

  def test_convert_adds_block_to_blocks_array
    serializer = PortableText::Serializer.new(content: [@portable_text_block])

    assert_empty serializer.blocks
    serializer.convert!
    assert_equal 1, serializer.blocks.size
    assert_instance_of PortableText::BlockTypes::Block, serializer.blocks.first
  end

  def test_convert_adds_list_item_as_list_to_blocks_array
    serializer = PortableText::Serializer.new(content: [@portable_text_block.merge(listItem: true)])

    serializer.convert!
    assert_equal 1, serializer.blocks.size
    assert_instance_of PortableText::BlockTypes::List, serializer.blocks.first
    assert_equal 1, serializer.blocks.first.items.size
  end

  def test_convert_adds_list_item_to_list_if_last_block_is_list
    serializer = PortableText::Serializer.new(
      content: [
        @portable_text_block.merge(listItem: true),
        @portable_text_block.merge(listItem: true)
      ]
    )

    serializer.convert!
    assert_equal 1, serializer.blocks.size
    assert_instance_of PortableText::BlockTypes::List, serializer.blocks.first
    assert_equal 2, serializer.blocks.first.items.size
  end

  def test_it_creates_children_when_present
    span_params = {
      marks: [],
      _key: "123",
      _type: "span",
      text: "hello"
    }

    serializer = PortableText::Serializer.new(
      content: [
        @portable_text_block.merge(children: [span_params])
      ]
    )

    serializer.convert!

    block = serializer.blocks.first
    refute_empty block.children
    assert_instance_of PortableText::BlockTypes::Span, block.children.first
  end

  def test_it_creates_mark_defs_when_present
    mark_def_params = {
      _key: "123",
      "_type" => "link"
    }

    serializer = PortableText::Serializer.new(
      content: [
        @portable_text_block.merge(markDefs: [mark_def_params])
      ]
    )

    serializer.convert!
    block = serializer.blocks.first
    refute_empty block.mark_defs
    assert_instance_of PortableText::MarkDefs::Link, block.mark_defs.first
  end

  def test_it_delegates_rendering_to_configured_serializer
    serializer = PortableText::Serializer.new(content: [@portable_text_block], to: :html)
    result = serializer.render

    assert_equal PortableText::Config.serializers[:html].new(serializer.blocks).call, result
  end
end
