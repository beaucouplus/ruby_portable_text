# frozen_string_literal: true

require_relative "lib/portable_text/version"

Gem::Specification.new do |spec|
  spec.name = "portable_text"
  spec.version= PortableText::VERSION
  spec.authors = ["Maxime Souillat"]
  spec.email = ["maxime@beaucouplus.com"]
  spec.summary = "A ruby renderer for Sanity Portable Text"
  spec.homepage = "https://github.com/beaucouplus/ruby_portable_text"
  spec.required_ruby_version = ">= 3.0.0"
  spec.license = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "actionview", "~> 7.1"
  spec.add_dependency "dry-configurable", "~> 1.0"
  spec.add_dependency "dry-inflector", "~> 1.0"
  spec.add_dependency "dry-initializer", "~> 3.1"
  spec.add_dependency "phlex", "~> 1.10"
  spec.add_dependency "zeitwerk", "~> 2.6"

  spec.add_development_dependency "minitest", "~> 5.22", ">= 5.22.3"
  spec.add_development_dependency "minitest-reporters", ">= 1.6"
end
