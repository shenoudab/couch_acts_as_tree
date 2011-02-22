require 'helper'
require 'set'

$verbose = false

class TestMongoidActsAsTree < Test::Unit::TestCase
  context "Tree" do
    setup do
      @root_1     = Category.create(:name => "Root 1")
      @child_1    = Category.create(:name => "Child 1")
      @child_2    = Category.create(:name => "Child 2")
      @child_2_1  = Category.create(:name => "Child 2.1")

      @child_3    = Category.create(:name => "Child 3")
      @root_2     = Category.create(:name => "Root 2")

      @root_1.children << @child_1
      @root_1.children << @child_2
      @root_1.children << @child_3

      @child_2.children << @child_2_1
    end

    should "add child via create or build" do
      @root_1.children.build :name => "Child 2.2"
      assert Category.where(:name => "Child 2.2").first.parent == @root_1
    end

   	should "add child via <<" do
   		child = Category.create(:name => "Child 2.2")
   		@root_1.children << child
			assert child.parent == @root_1
		end

		should "delete child" do
			@root_1.children.delete @child_1
			assert_equal(2, @root_1.children.size)
			@root_1.children.delete @child_2.id
			assert_equal(@child_3, @root_1.children.first)
		end

		should "clear children list" do
			@root_1.children.clear
			assert_equal([], @root_1.children)
		end

		should "replace children list" do
			new_children_list = [Category.create(:name => "test 1"), Category.create(:name => "test 2")]

			@root_1.children = new_children_list
			assert_equal(new_children_list, @root_1.children)

			@root_1.children = []
			assert_equal([], @root_1.children)
		end

    should "have roots" do
      assert eql_arrays?(Category.roots, [@root_1, @root_2])
    end

		should "assign parent_id" do
			child  = Category.create :name => 'child'
			parent = Category.create :name => 'parent'

			child.parent_id = parent.id
			child.save

			assert_equal parent.children.first.id, child.id
			assert_equal parent.id, child.parent_id
			assert parent.children.include? child

			assert_equal 1, child.depth
			assert_equal [parent.id], child.path

			more_deep_child = Category.new(
				:name => 'more deep child',
				:parent_id => child.id
			)

			assert more_deep_child.new_record?
			more_deep_child.save
			assert !more_deep_child.new_record?

			assert_equal child.children.first.id, more_deep_child.id
			assert_equal child.id, more_deep_child.parent_id
			assert child.children.include? more_deep_child

			assert_equal 2, more_deep_child.depth
			assert_equal [parent.id, child.id], more_deep_child.path

			assert parent.descendants.include? child
			assert parent.descendants.include? more_deep_child

			assert more_deep_child.ancestors.include? child
			assert more_deep_child.ancestors.include? parent
		end

		should "assign blank parent_id" do
			@child_1.parent_id = ''
			@child_1.save

			assert_nil @child_1.reload.parent_id
			assert_equal 0, @child_1.depth
			assert_equal [], @child_1.path

			@child_1.parent_id = nil
			@child_1.save

			assert_nil @child_1.reload.parent_id
			assert_equal 0, @child_1.depth
			assert_equal [], @child_1.path
		end

    context "node" do
      should "have a root" do
        assert_equal @root_1.root, @root_1
        assert_not_equal @root_1.root, @root_2.root
        assert_equal @root_1, @child_2_1.root
      end

      should "have ancestors" do
        assert_equal @root_1.ancestors, []
        assert_equal @child_2.ancestors, [@root_1]
        assert_equal @child_2_1.ancestors, [@root_1, @child_2]
        assert_equal @root_1.self_and_ancestors, [@root_1]
        assert_equal @child_2.self_and_ancestors, [@root_1, @child_2]
        assert_equal @child_2_1.self_and_ancestors, [@root_1, @child_2, @child_2_1]
      end

      should "have siblings" do
        assert eql_arrays?(@root_1.siblings, [@root_2])
        assert eql_arrays?(@child_2.siblings, [@child_1, @child_3])
        assert eql_arrays?(@child_2_1.siblings, [])
        assert eql_arrays?(@root_1.self_and_siblings, [@root_1, @root_2])
        assert eql_arrays?(@child_2.self_and_siblings, [@child_1, @child_2, @child_3])
        assert eql_arrays?(@child_2_1.self_and_siblings, [@child_2_1])
      end

      should "set depth" do
        assert_equal 0, @root_1.depth
        assert_equal 1, @child_1.depth
        assert_equal 2, @child_2_1.depth
      end

      should "have children" do
        assert @child_2_1.children.empty?
        assert eql_arrays?(@root_1.children, [@child_1, @child_2, @child_3])
      end

      should "have descendants" do
        assert eql_arrays?(@root_1.descendants, [@child_1, @child_2, @child_3, @child_2_1])
        assert eql_arrays?(@child_2.descendants, [@child_2_1])
        assert @child_2_1.descendants.empty?
        assert eql_arrays?(@root_1.self_and_descendants, [@root_1, @child_1, @child_2, @child_3, @child_2_1])
        assert eql_arrays?(@child_2.self_and_descendants, [@child_2, @child_2_1])
        assert eql_arrays?(@child_2_1.self_and_descendants, [@child_2_1])
      end

      should "be able to tell if ancestor" do
        assert @root_1.is_ancestor_of?(@child_1)
        assert !@root_2.is_ancestor_of?(@child_2_1)
        assert !@child_2.is_ancestor_of?(@child_2)

        assert @root_1.is_or_is_ancestor_of?(@child_1)
        assert !@root_2.is_or_is_ancestor_of?(@child_2_1)
        assert @child_2.is_or_is_ancestor_of?(@child_2)
      end

      should "be able to tell if descendant" do
        assert !@root_1.is_descendant_of?(@child_1)
        assert @child_1.is_descendant_of?(@root_1)
        assert !@child_2.is_descendant_of?(@child_2)

        assert !@root_1.is_or_is_descendant_of?(@child_1)
        assert @child_1.is_or_is_descendant_of?(@root_1)
        assert @child_2.is_or_is_descendant_of?(@child_2)
      end

      should "be able to tell if sibling" do
        assert !@root_1.is_sibling_of?(@child_1)
        assert !@child_1.is_sibling_of?(@child_1)
        assert !@child_2.is_sibling_of?(@child_2)

        assert !@root_1.is_or_is_sibling_of?(@child_1)
        assert @child_1.is_or_is_sibling_of?(@child_2)
        assert @child_2.is_or_is_sibling_of?(@child_2)
      end

      context "when moving" do
        should "recalculate path and depth" do
					@child_2.children << @child_3
          @child_3.save

          assert @child_2.is_or_is_ancestor_of?(@child_3)
          assert @child_3.is_or_is_descendant_of?(@child_2)
          assert @child_2.children.include?(@child_3)
          assert @child_2.descendants.include?(@child_3)
          assert @child_2_1.is_or_is_sibling_of?(@child_3)
          assert_equal 2, @child_3.depth
        end

        should "move children on save" do
					@root_2.children << @child_2

					@child_2_1.reload

          assert @root_2.is_or_is_ancestor_of?(@child_2_1)
          assert @child_2_1.is_or_is_descendant_of?(@root_2)
          assert @root_2.descendants.include?(@child_2_1)
        end

        should "check against cyclic graph" do
          @child_2_1.children << @root_1
          assert !@root_1.save
        end
      end

      should "destroy descendants when destroyed" do
        @child_2.destroy
        assert_nil Category.where(:id => @child_2_1._id).first
      end
    end

    context "root node" do
      should "not have a parent" do
        assert_nil @root_1.parent
      end
    end

    context "child_node" do
      should "have a parent" do
        assert_equal @child_2, @child_2_1.parent
      end
    end
  end
end

