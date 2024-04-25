require "test_helper"
require "json"

class PortableTextTest < Minitest::Test
  def test_i_can_access_the_configuration
    assert_instance_of Dry::Configurable::Config, PortableText.config
  end

  def test_i_can_access_the_html_configuration
    assert_instance_of Dry::Configurable::Config, PortableText::Html.config
  end

  # rubocop:disable Layout/LineLength
  def test_it_can_render_a_whole_body
    json = File.read("#{Dir.pwd}/test/fixtures/body.json")
    body = JSON.parse(json)

    content = PortableText::Serializer.new(content: body["body"]).render.call

    assert_equal(
      content,
      "<h1>Titre h1</h1><h2>Titre h2</h2><h3>Titre h3</h3><h4>Titre h4</h4><blockquote>Citation</blockquote><p>Texte avec le mot <strong>gras</strong> en gras</p><p>Texte avec le mot <em>italique</em> en italique</p><p>Texte avec les mots <strong><em>gras italique</em></strong> en gras et italique</p><ul><li>liste level 1</li><li>liste level 1</li><li>liste level 1</li><ul><li>sous liste level 2</li></ul><ul><li>sous liste <strong>level 2</strong></li><ul><li>sous liste <em>level 3</em></li></ul></ul><ul><li>sous liste level 2</li></ul><li>liste level 1</li><ul><li>sous liste level 2</li><ul><li>sous liste level 3</li></ul></ul><ul><li>sous liste level 2</li></ul></ul><p><a href=\"http://www.sanity.io\">Lien externe</a>  </p>"
    )
  end
  # rubocop:enable Layout/LineLength
end
