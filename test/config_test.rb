require "test_helper"

class PortableText::ConfigTest < Minitest::Test
  class NewBlock < PortableText::BlockTypes::Base
  end

  def test_i_can_add_a_new_block_type
    PortableText::Config.config.block.types[:new_block] = NewBlock
    blocks = [{ _key: "36be0ac1493e", _type: "new_block" }]

    serializer = PortableText::Serializer.new(content: blocks)
    serializer.convert!

    new_block = serializer.blocks.first
    assert_instance_of NewBlock, new_block
  end

  class NewSerializer
    def initialize(_) = nil
  end

  def test_i_can_add_new_serializers
    PortableText::Config.config.serializers[:new_serializer] = NewSerializer
    assert_instance_of NewSerializer, PortableText::Serializer.new(content: [], to: :new_serializer).render
  end

  class NewMarkDef < PortableText::MarkDefs::Base
  end

  def test_i_can_add_new_mark_defs
    PortableText::Config.config.block.mark_defs[:new_mark_def] = NewMarkDef
    blocks = [
      {
        _key: "36be0ac1493e",
        _type: "block",
        markDefs: [{ "_key" => "456", "_type" => "newMarkDef" }],
        style: "h1",
        "children": [
          {
            "_key": "f55398075dd5",
            "_type": "span",
            "marks": ["456"],
            "text": "Titre h1"
          }
        ]
      }
    ]

    serializer = PortableText::Serializer.new(content: blocks)
    serializer.convert!
    assert_instance_of NewMarkDef, serializer.blocks.first.mark_defs.first
  end
end
