require "test_helper"

class PortableText::Plain::SerializerTest < Minitest::Test
  def test_it_serialiszes_to_plain_text
    json = File.read("#{Dir.pwd}/test/fixtures/body.json")
    body = JSON.parse(json)

    content = PortableText::Serializer.new(content: body["body"], to: :plain).render
    assert_equal(
      content,
      <<~CONTENT.strip
        Titre h1
        Titre h2
        Titre h3
        Titre h4
        Citation
        Texte avec le mot gras en gras
        Texte avec le mot italique en italique
        Texte avec les mots gras italique en gras et italique
        liste level 1
        liste level 1
        liste level 1
        sous liste level 2
        sous liste level 2
        sous liste level 3
        sous liste level 2
        liste level 1
        sous liste level 2
        sous liste level 3
        sous liste level 2
        Lien externe
      CONTENT
    )
  end
end
