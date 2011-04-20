require 'couchrest_model'
require 'couch_acts_as_tree'

class OrderedCategory < CouchRest::Model::Base
  include Couch::Acts::Tree
  
  use_database TEST_SERVER.default_database

  property :name
  property :value, Integer

  acts_as_tree :order => [['value', 'asc']]
end