require "test_helper"

class PortableText::Html::BlockTypes::ImageTest < Minitest::Test
  def setup
    @image_params = {
      _key: "36be0ac1493e",
      _type: "image",
      asset: {}
    }
  end

  def new_image(**params)
    PortableText::BlockTypes::Image.new(**@image_params, **params)
  end

  def test_delegate_methods_to_image
    image = new_image
    html_image = PortableText::Html::BlockTypes::Image.new(image)
    assert_equal image.asset, html_image.asset
  end

  def test_when_no_url_render_creates_an_error_div
    image = new_image
    html_image = PortableText::Html::BlockTypes::Image.new(image)
    assert_equal "<div>Please provide a url for this image</div>", html_image.render
  end

  def test_when_asset_has_url_render_creates_an_img_tag
    image = new_image(asset: { "url" => "https://example.com/image.jpg" })
    html_image = PortableText::Html::BlockTypes::Image.new(image)
    assert_equal '<img src="https://example.com/image.jpg">', html_image.render
  end
end
