require 'helper'
require 'set'

class TestCouchActsAsTree < Test::Unit::TestCase
  context "Ordered tree" do
    setup do
      @root_1     = OrderedCategory.new(:name => "Root 1", :value => 2)
      @child_1    = OrderedCategory.new(:name => "Child 1", :value => 1)
      @child_2    = OrderedCategory.new(:name => "Child 2", :value => 9)
      @child_2_1  = OrderedCategory.new(:name => "Child 2.1", :value => 2)

      @child_3    = OrderedCategory.new(:name => "Child 3", :value => 5)
      @root_2     = OrderedCategory.new(:name => "Root 2", :value => 1)

      @root_1.children << @child_1
      @root_1.children << @child_2
      @root_1.children << @child_3

      @child_2.children << @child_2_1
    end

    should "be in order" do
      assert_equal OrderedCategory.roots.to_a, [@root_2, @root_1]
      assert_equal @root_1.children, [@child_1, @child_3, @child_2]

      assert_equal @root_1.descendants, [@child_1, @child_2_1, @child_3, @child_2]
      assert_equal @root_1.self_and_descendants, [@root_1, @child_1, @child_2_1, @child_3, @child_2]

      assert_equal @child_2.siblings, [@child_1, @child_3]
      assert_equal @child_2.self_and_siblings, [@child_1, @child_3, @child_2]
      assert_equal @root_1.self_and_siblings, [@root_2, @root_1]
    end
  end
end