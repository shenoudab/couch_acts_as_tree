require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'couchrest_model'

TEST_SERVER = CouchRest.new("http://admin:admin@127.0.0.1:5984")
TEST_SERVER.default_database = 'acts_as_tree'

Dir["#{File.dirname(__FILE__)}/models/*.rb"].each {|file| require file}

class Test::Unit::TestCase
  def eql_arrays?(first, second)
    first.map{|i| i._id}.to_set == second.map{|i| i._id}.to_set
  end
end

