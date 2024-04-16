require "test_helper"

class PortableText::BlockTypes::ListTest < Minitest::Test
  def setup
    @list = new_list
  end

  def new_list(**params)
    PortableText::BlockTypes::List.new(**params)
  end

  def new_block(**params)
    PortableText::BlockTypes::Block.new(
      _key: SecureRandom.uuid,
      _type: "block",
      markDefs: [],
      **params
    )
  end

  def test_list_type_defaults_to_bullet
    assert_equal("bullet", @list.list_type)
  end

  def test_items_defaults_to_empty_array
    assert_equal([], @list.items)
  end

  def test_level_defaults_to_one
    assert_equal(1, @list.level)
  end

  def test_parent_defaults_to_nil
    assert_respond_to(@list, :parent)

    other_list = new_list(parent: @list)
    assert_equal(@list, other_list.parent)
  end

  def test_list_is_always_true
    assert(@list.list?)
  end

  def test_type_is_list
    assert_equal(:list, @list.type)
  end

  def test_adding_block_with_same_level_adds_to_items
    block = new_block(level: 1)
    list = new_list
    list.add(block)
    assert_equal([block], list.items)
  end

  def test_adding_block_with_higher_level_adds_to_child_list
    block = new_block(level: 2)
    list = new_list
    list.add(block)
    assert_equal(1, list.items.size)

    child_list = list.items.first
    assert_equal(list, child_list.parent)
    assert_equal(block, child_list.items.first)
  end

  def test_adding_block_with_lower_level_than_list_adds_to_ancestor
    # Add a block to the list with level 1
    list = new_list
    block = new_block(level: 1)
    list.add(block)
    assert_equal([block], list.items)

    # Add a block with level 2
    child_block = new_block(level: 2)
    list.add(child_block)

    child_list = list.items.last
    assert(child_list.list?)
    assert_equal(list, child_list.parent)

    # Add another block with level 1
    ancestor_block = new_block(level: 1)
    list.add(ancestor_block)

    assert_equal(3, list.items.size)
    assert_equal(1, child_list.items.size)

    assert_equal(ancestor_block, list.items.last)
  end
end
