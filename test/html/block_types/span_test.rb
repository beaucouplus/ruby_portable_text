require "test_helper"

class PortableText::Html::BlockTypes::SpanTest < Minitest::Test
  def setup
    @span_params = {
      _key: "36be0ac1493e",
      _type: "span",
      text: "Hello, World!"
    }
  end

  def new_span(**params)
    PortableText::BlockTypes::Span.new(
      **@span_params, **params
    )
  end

  def test_it_renders_text_if_no_mark
    span = new_span
    html_span = PortableText::Html::BlockTypes::Span.new(span)

    assert_equal "Hello, World!", html_span.call
  end

  def test_it_renders_marked_content
    span = new_span(marks: ["strong"])
    html_span = PortableText::Html::BlockTypes::Span.new(span)

    assert_equal "<strong>Hello, World!</strong>", html_span.call
  end

  def test_it_renders_marked_content_with_multiple_marks
    span = new_span(marks: ["strong", "em"])
    html_span = PortableText::Html::BlockTypes::Span.new(span)

    assert_equal "<strong><em>Hello, World!</em></strong>", html_span.call
  end

  def test_it_renders_span_if_mark_not_defined
    span = new_span(marks: ["something"])
    html_span = PortableText::Html::BlockTypes::Span.new(span)

    assert_equal "<span>Hello, World!</span>", html_span.call
  end

  def test_it_renders_marked_content_with_mark_defs
    link = PortableText::MarkDefs::Link.new(
      _key: "123",
      _type: "link",
      href: "http://example.com"
    )

    span = new_span(marks: ["123"])
    html_span = PortableText::Html::BlockTypes::Span.new(span, mark_defs: [link])

    assert_equal "<a href=\"http://example.com\">Hello, World!</a>", html_span.call
  end

  def test_it_renders_both_marks_and_mark_defs
    link = PortableText::MarkDefs::Link.new(
      _key: "123",
      _type: "link",
      href: "http://example.com"
    )

    span = new_span(marks: ["em", "123", "strong"])
    html_span = PortableText::Html::BlockTypes::Span.new(span, mark_defs: [link])

    assert_equal(
      "<em><a href=\"http://example.com\"><strong>Hello, World!</strong></a></em>",
      html_span.call
    )
  end

  def test_when_node_configuration_is_overriden_adds_new_node_arguments
    PortableText::Html::Serializer.config.span.marks[:em] = { node: :em, class: "title" }
    span = new_span(marks: ["em"])
    html_span = PortableText::Html::BlockTypes::Span.new(span)

    assert_equal "<em class=\"title\">Hello, World!</em>", html_span.call

    PortableText::Html::Serializer.config.span.marks[:em] = { node: :em }
  end
end
