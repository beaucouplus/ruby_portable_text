require "test_helper"

class PortableTextTest < Minitest::Test
  def test_i_can_access_the_configuration
    assert_instance_of Dry::Configurable::Config, PortableText.config
  end

  def test_i_can_access_the_html_configuration
    assert_instance_of Dry::Configurable::Config, PortableText::Html.config
  end
end
