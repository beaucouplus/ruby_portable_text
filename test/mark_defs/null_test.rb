require "test_helper"

class PortableText::MarkDefs::LinkTest < Minitest::Test
  def test_null_is_a_child_of_base
    assert PortableText::MarkDefs::Null < PortableText::MarkDefs::Base
  end
end
