require "test_helper"

class PortableText::BlockTypes::BlockTest < Minitest::Test
  def test_is_a_child_of_base
    assert PortableText::BlockTypes::Block < PortableText::BlockTypes::Base
  end
end
