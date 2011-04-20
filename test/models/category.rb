require 'couchrest_model'
require 'couch_acts_as_tree'

class Category < CouchRest::Model::Base
  include Couch::Acts::Tree

  use_database TEST_SERVER.default_database

  property :name

  view_by :name
  
  acts_as_tree
end