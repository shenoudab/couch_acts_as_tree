# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{couch_acts_as_tree}
  s.version = "0.0.1"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Shenouda Bertel"]
  s.date = %q{2011-02-25}
  s.description = %q{ActsAsTree For CouchDB using CouchrestModel}
  s.email = ["sbertel@mobithought.com"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".gitignore",
    "CHANGELOG",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/couch_acts_as_tree.rb",
    "couch_acts_as_tree.gemspec",
    "test/helper.rb",
    "test/models/category.rb",
    "test/models/ordered_category.rb",
    "test/test_order.rb",
    "test/test_tree.rb"
  ]
  s.homepage = %q{http://github.com/shenoudab/couch_acts_as_tree}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{ActsAsTree for CouchrestModel}
  s.test_files = [
    "test/helper.rb",
    "test/models/category.rb",
    "test/models/ordered_category.rb",
    "test/test_order.rb",
    "test/test_tree.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<couchrest>)
      s.add_runtime_dependency(%q<couchrest_model>)
      s.add_development_dependency(%q<shoulda>)
    else
      s.add_dependency(%q<couchrest>)
      s.add_dependency(%q<couchrest_model>)
      s.add_dependency(%q<shoulda>)
    end
  else
    s.add_dependency(%q<couchrest>)
    s.add_dependency(%q<couchrest_model>)
    s.add_dependency(%q<shoulda>)
  end
end

