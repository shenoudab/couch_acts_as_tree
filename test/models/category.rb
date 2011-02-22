require "mongoid"
require "mongoid_acts_as_tree"

class Category
  include Mongoid::Document
  include Mongoid::Acts::Tree

  field :name, :type => String

  acts_as_tree
end

