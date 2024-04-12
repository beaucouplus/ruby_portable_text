require "test_helper"

class PortableText::BlockTypes::BlockTest < Minitest::Test
  def test_null_is_a_child_of_base
    assert PortableText::BlockTypes::Null < PortableText::BlockTypes::Base
  end
end
