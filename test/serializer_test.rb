require "test_helper"

class SerializerTest < Minitest::Test
  include Phlex::Testing::ViewHelper

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

  class NewSerializer
    def initialize(_) = nil
    def content = "new serializer"
  end

  def test_serializer_must_respond_to_content
    PortableText.config.serializers[:new_serializer] = NewSerializer
    serializer = PortableText::Serializer.new(content: [@portable_text_block], to: :new_serializer)
    assert serializer.render
    PortableText.config.serializers.delete(:new_serializer)
  end

  # rubocop:disable Layout/LineLength
  def test_it_can_render_a_whole_body
    json = File.read("#{Dir.pwd}/test/fixtures/body.json")
    body = JSON.parse(json)

    content = render PortableText::Serializer.new(content: body["body"]).render
    assert_equal(
      content,
      "<h1>Titre h1</h1><h2>Titre h2</h2><h3>Titre h3</h3><h4>Titre h4</h4><blockquote>Citation</blockquote><p>Texte avec le mot <strong>gras</strong> en gras</p><p>Texte avec le mot <em>italique</em> en italique</p><p>Texte avec les mots <strong><em>gras italique</em></strong> en gras et italique</p><ul><li>liste level 1</li><li>liste level 1</li><li>liste level 1</li><ul><li>sous liste level 2</li></ul><ul><li>sous liste <strong>level 2</strong></li><ul><li>sous liste <em>level 3</em></li></ul></ul><ul><li>sous liste level 2</li></ul><li>liste level 1</li><ul><li>sous liste level 2</li><ul><li>sous liste level 3</li></ul></ul><ul><li>sous liste level 2</li></ul></ul><p><a href=\"http://www.sanity.io\">Lien externe</a>  </p>"
    )
  end
  # rubocop:enable Layout/LineLength
end
