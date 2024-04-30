# Ruby Portable Text

A ruby library to render [Portable text](https://www.sanity.io/docs/presenting-block-text)


This gem is meant to be easy to use but is also highly configurable and extensible to match many use cases. By default, it can serialize Portable Text to HTML.

You can:

- easily render default PortableText blocks in html without any configuration
- create custom block types, mark_defs. Add them or replace existing ones.
- create custom HTML serializers for each block type or mark def. Add them or replace existing ones.
- customize each HTML node with custom attributes
- create a new serializer

This is a very early release so please open issues if something doesn't work as intended.


## Installation

```other
gem install portable_text
```



## Usage

See [Rails usage](#rails-usage) for usage in rails

`PortableText::Serializer` takes 2 parameters:

- `content:`  , the portable text Array
- `to:` , the rendering format. It defaults to: `:html`

> You can also use the `:plain` rendering format to show the text without any formatting. The plain serializer is very basic and does not support any configuration, but it can be used as a starting point to create a new serializer.

PortableText accepts 2 methods, `render` and `convert!`.
  - `render` renders the content to the specified format defined in the `to` parameter. See [How to render html ?](#how-to-render-html) for more information.
  - `convert!` converts the content to be used by the library. 
    - It is useful for debugging purposes.
    - It transforms the keys to ruby format.
    - It creates the block types and mark definitions as objects, along with their children and marks, and creates a new data structure for list items.

### How to render html?

Under the hood, the html renderer uses [Phlex](https://www.phlex.fun), a templating language which allows to create html in plain ruby.

```ruby
content = [
  {
      "_key": "12345ffxx",
      "_type": "block",
      "children": [{ 
        "_key": "78910xxyy", 
        "_type": "span", 
        "marks": [],
        "text": "Hello world!" 
      }],
      "markDefs": [],
      "style": "h1"
    }
]

portable_text = PortableText::Serializer.new(content: content, to: :html)

# Since the HTML renderer uses Phlex, you can either include the rendering module 
# and use the render method...
include PortableText::Html::Rendering
render portable_text.render
# => <h1>Hello world!</h1>

# ... Or you can directly call the Phlex template
portable_text.render.call
# => <h1>Hello world!</h1>
```


### Rails usage

To use the `PortableText` HTML serializer in rails, you need to add `phlex-rails` to the Gemfile.

You don’t need to do the whole phlex installation (as described in the Phlex documentation) if you don’t intend to use Phlex to replace your usual templating language.

```ruby
gem 'portable_text'
gem 'phlex-rails'
```

Then run `bundle install`

Then, in a controller or a view, just use `render` as usual.

```ruby
portable_text = PortableText::Serializer.new(content: content, to: :html)
render portable_text.render
```



## Configuration

This library is highly  customizable through configuration. This is very straightforward as configuration is just a bunch of hashes that either define classes or key-value pairs.

Since this library is meant to be used for multiple use cases, and possibly several serializers at once, the type definitions are independent from the rendering.

So, in order to use a block type or a mark definition, one has to:

- register it in the PortableText configuration, so it can be passed as an object to the serializer
- create the template in the serializer (see HTML configuration)



### Registering block types

```ruby
content = [
  { 
    "_key": "12345ffxx", 
    "_type": "myType", 
    ...,
    "url": "https://www.github.com",
    "image_url": "https://www.myimage.com/my_image.jpg",
    "children": [{ 
        "_key": "78910xxyy", 
        "_type": "span", 
        "marks": [],
        "text": "Github" 
      }]
  }
]

# Under the hood, this library uses dry-initializer.
# You can use the option method to configure it easily
class MyBlock < PortableText::BlockTypes::Base
  option :url, default: proc { "" }
  option :image_url, default: proc { "" }
  # children is an inherited option so it does not need to be added here
end

# Or use plain old ruby. It needs to have attr_readers!
class MyBlock < PortableText::BlockTypes::Base
  attr_reader :url, :image_url
  
  def initialize(url: "", image_url:, **)
    super
    @url = url
    @image_url = image_url
  end
end

# PortableText transforms keys to ruby format so use conventional ruby!
# myType becomes my_type.
PortableText.config.block.types.merge! { my_block: MyBlock }
```


#### Default block types

It’s probably a good idea to leave the `list` block type untouched. Change at your own risk.

```ruby
{ 
  block: BlockTypes::Block,
  image: BlockTypes::Image,
  list: BlockTypes::List,
  span: BlockTypes::Span
}
```


### Registering mark definitions

It’s very similar to registering blocks. In case of doubt, refer to the block documentation.

```ruby
content = [
  { 
    "_key": "12345ffxx", 
    "_type": "block", 
    ...,
    "markDefs": [{ "_key" => "456", "_type" => "newMarkDef" }],
  }
]

class NewMarkDef < PortableText::MarkDefs::Base
  option :label, default: proc { "" }
end

PortableText.config.block.mark_defs.merge! { new_mark_def: NewMarkDef }
```



## Html Serializer configuration

After registering your block type or mark definition, you need to create its template.

Each template takes one argument, a block.


### Block Type Template

```ruby
# Let's use the block defined earlier in Registering block types

class Html::MyBlock < PortableText::Html::BaseComponent
  # You can include PortableText::Html::Configured 
  # to get access to the html serializer configuration helpers
  # The #config method allows you to access config values  
  # The #block_type(:key) method is a shortcut to the relevant block_type
  include PortableText::Html::Configured
  
  # This library uses dry-initializer 
  # so you can use `param` to create a simple parameter
  
  # There is no attribute_reader so `param :my_block` generates `@my_block`
  # This is recommended because some common HTML method names could conflict with
  # Phlex methods, like `title`. 
  param :my_block
 
  def view_template
    div do
      img(src: @my_block.image_url)
      link
    end
  end

  private

  def link
    a(href: @my_block.url) do 
      @my_block.children.each do |child|
        render block_type(:span).new(child, mark_defs: nil)
      end
    end
  end
end

# It needs to have the same key as the one registered before.
PortableText::Html.config.block.types.merge! { my_block: Html::MyBlock }
```


### Mark Definition template

Each mark definition takes one argument, a mark definition registered in the configuration.

```ruby
# Let's use the mark definition defined earlier in Registering mark definition

class Html::NewMarkDef < PortableText::Html::BaseComponent
  param :mark_def

  # &block is mandatory because mark definitions always contain other nodes
  def view_template(&block)
    a(href: @mark_def.url) { block.call }
  end
end

# It needs to have the same key as the one registered before.
PortableText::Html.config.block.mark_defs.merge! { new_mark_def: Html::NewMarkDef }
```


### Customizing html nodes

Every HTML node is customizable through config and looks this way:

`h1: { node: :h1 }`

You can add HTML attributes by appending them. For example:

```ruby
h1: { node: :h1, class: "header" }
```


### Configuring marks

You can configure marks by updating the marks setting.

```ruby
PortableText::Html.config.span.marks.merge! { strong: { node: :b,  }}

# Defaults
{ 
  strong: { node: :strong },
  em: { node: :em }
}
```


### Configuring styles

```ruby
PortableText::Html.config.block.styles.merge! { h1: { node: :h3, class: "header" }}


# Defaults
{
  h1: { node: :h1 },
  h2: { node: :h2 },
  h3: { node: :h3 },
  h4: { node: :h4 },
  h5: { node: :h5 },
  h6: { node: :h6 },
  blockquote: { node: :blockquote },
  normal: { node: :p },
  li: { node: :li }
}
```


### Configuring list types

```ruby
PortableText::Html.config.block.list_types.merge! { bullet: { node: :div }}

# Defaults
{
  bullet: { node: :ul },
  numeric: { node: :ol }
}
```


### Adding a new serializer

You can add a new serializer by creating a new class. You then need to add it the the config.

The serializer needs to have a `content` method and takes a list of `blocks` as only parameter.

```ruby
class MySerializer
  def initialize(blocks)
    @blocks = blocks
  end

  def content(**options)
    blocks.map |block|
      block.type + " - " + block.key + " - " + options[:context]
    end.join(" ")
  end
end

PortableText.config.serializers.merge! { my_serializer: MySerializer }

content = [{ "_key": "12345ffxx", "_type": "block", ... }]
serializer = PortableText::Serializer.new(content: content, to: :my_serializer)

# render forwards any keyword argument to the content method in the serializer
serializer.render(context: "readme")
# => block - 12345ffxx - readme
```
## Acknowledgments
Thanks to [Joel Drapper](https://github.com/joeldrapper) and [Will Cosgrove](https://github.com/willcosgrove) for their help in building the HTML serializer!


