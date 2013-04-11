# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "columnize"
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["R. Bernstein"]
  s.date = "2009-07-26"
  s.description = "Return a list of strings as a set of arranged in columns.\n\nFor example, for a line width of 4 characters (arranged vertically):\n    ['1', '2,', '3', '4'] => '1  3\n2  4\n'\n\nor arranged horizontally:\n    ['1', '2,', '3', '4'] => '1  2\n3  4\n'\n\nEach column is only as wide as necessary.  By default, columns are\nseparated by two spaces - one was not legible enough. Set \"colsep\"\nto adjust the string separate columns. Set `displaywidth' to set\nthe line width.\n\nNormally, consecutive items go down from the top to bottom from\nthe left-most column to the right-most. If +arrange_vertical+ is\nset false, consecutive items will go across, left to right, top to\nbottom.\n"
  s.email = "rockyb@rubyforge.net"
  s.extra_rdoc_files = ["README", "lib/columnize.rb"]
  s.files = ["README", "lib/columnize.rb"]
  s.homepage = "http://rubyforge.org/projects/rocky-hacks/columnize"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.2")
  s.rubyforge_project = "rocky-hacks"
  s.rubygems_version = "1.8.23"
  s.summary = "Read file with caching"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
