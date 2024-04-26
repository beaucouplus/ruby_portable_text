require "test_helper"

class PortableText::Html::RenderingTest < Minitest::Test
  include PortableText::Html::Rendering

  def setup
    @blocks = [
      PortableText::BlockTypes::Block.new(
        _key: "36be0ac1493e",
        _type: "block",
        markDefs: [],
        style: "h1"
      )
    ]
  end

  def test_render_delegates_to_call
    serializer = PortableText::Html::Serializer.new(@blocks)
    assert_equal "<h1></h1>", render(serializer)
  end
end
