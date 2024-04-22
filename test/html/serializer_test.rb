require "test_helper"

class PortableText::Html::SerializerTest < Minitest::Test
  def test_it_renders_blocks_concatenated
    blocks = [
      PortableText::BlockTypes::Block.new(
        _key: "36be0ac1493e",
        _type: "block",
        markDefs: [],
        style: "h1"
      ),
      PortableText::BlockTypes::Image.new(
        _key: "36be0ac1493e",
        _type: "image",
        asset: { "url" => "https://example.com/image.jpg" }
      )
    ]

    serializer = PortableText::Html::Serializer.new(blocks)
    assert_equal "<h1></h1><img src=\"https://example.com/image.jpg\">", serializer.call
  end

  class NewBlock < PortableText::Html::BaseComponent
    def view_template
      h1 { "New block" }
    end
  end

  def test_i_can_add_a_new_block_type
    PortableText::Html::Serializer.config.block.types[:new_block] = NewBlock
    blocks = [
      PortableText::BlockTypes::Block.new(
        _key: "36be0ac1493e",
        _type: "new_block"
      )
    ]

    serializer = PortableText::Html::Serializer.new(blocks)
    assert_equal "<h1>New block</h1>", serializer.call
    PortableText::Html::Serializer.config.block.types.delete(:new_block)
  end

  def test_i_can_add_new_styles
    PortableText::Html::Serializer.config.block.styles[:section] = { node: :section }
    blocks = [
      PortableText::BlockTypes::Block.new(
        _key: "36be0ac1493e",
        _type: "block",
        style: "section"
      )
    ]

    serializer = PortableText::Html::Serializer.new(blocks)
    assert_equal "<section></section>", serializer.call
  end

  class Highlight < PortableText::MarkDefs::Base
  end

  class HtmlHighlight < PortableText::Html::BaseComponent
    def view_template(&block)
      span do
        plain(block.call)
        plain(" cause I want to.")
      end
    end
  end

  def test_i_can_add_new_mark_defs
    PortableText::Html::Serializer.config.block.mark_defs[:highlight] = HtmlHighlight
    highlight = Highlight.new(
      _key: "456",
      _type: "highlight"
    )
    blocks = [
      PortableText::BlockTypes::Block.new(
        _key: "36be0ac1493e",
        _type: "block",
        markDefs: [highlight],
        style: "h1",
        children: [
          PortableText::BlockTypes::Span.new(
            _key: "123",
            _type: "span",
            marks: ["456"],
            text: "I use the custom mark def"
          )
        ]
      )
    ]

    serializer = PortableText::Html::Serializer.new(blocks)
    assert_equal "<h1><span>I use the custom mark def cause I want to.</span></h1>",
                 serializer.call
  end

  def test_i_can_add_new_list_types
    PortableText::Html::Serializer.config.block.list_types[:section] = { node: :section }

    list = PortableText::BlockTypes::List.new(list_type: :section)
    html_list = PortableText::Html::BlockTypes::List.new(list)
    assert_equal "<section></section>", html_list.call
  end

  def test_i_can_add_new_span_marks
    PortableText::Html::Serializer.config.span.marks[:lowercase] = { node: :span, class: "lowercase" }
    blocks = [
      PortableText::BlockTypes::Block.new(
        _key: "36be0ac1493e", _type: "block", style: "h1", children: [PortableText::BlockTypes::Span.new(
          _key: "123",
          _type: "span",
          marks: ["lowercase"],
          text: "I use the custom mark"
        )]
      )
    ]
    serializer = PortableText::Html::Serializer.new(blocks)
    assert_equal "<h1><span class=\"lowercase\">I use the custom mark</span></h1>", serializer.call
  end
end
