
!SLIDE subsection
# ¿Cómo testear una Gema?

!SLIDE

    @@@ Shell
    $ bundle gem my_gem
    Creating gem 'my_gem'...
    Do you want to generate tests with your gem?
    Type 'rspec' or 'minitest' to generate those test files now and in
    the future. rspec/minitest/(none):

!SLIDE

## gema con minitest

    @@@ Shell
    my_gem_mini/
    ├── bin
    │   ├── console
    │   └── setup
    ├── CODE_OF_CONDUCT.md
    ├── Gemfile
    ├── lib
    │   ├── my_gem_mini
    │   │   └── version.rb
    │   └── my_gem_mini.rb
    ├── LICENSE.txt
    ├── my_gem_mini.gemspec
    ├── Rakefile
    ├── README.md
    └── test
        ├── my_gem_mini_test.rb
        └── test_helper.rb

!SLIDE

## gema con rspec

    @@@ Shell
    my_gem_rspec/
    ├── bin
    │   ├── console
    │   └── setup
    ├── CODE_OF_CONDUCT.md
    ├── Gemfile
    ├── lib
    │   ├── my_gem_rspec
    │   │   └── version.rb
    │   └── my_gem_rspec.rb
    ├── LICENSE.txt
    ├── my_gem_rspec.gemspec
    ├── Rakefile
    ├── README.md
    └── spec
        ├── my_gem_rspec_spec.rb
        └── spec_helper.rb

!SLIDE small

## gemspec comun

    @@@ Ruby
    Gem::Specification.new do |spec|
      spec.name          = "my_gem_rspec"
      spec.version       = MyGemRspec::VERSION
      spec.authors       = ["Fernando Martínez"]
      spec.email         = ["me@oinak.com"]

      spec.summary       = %q{TODO: Write a short summary, because RubyGems requires one.}
      spec.description   = %q{TODO: Write a longer description or delete this line.}
      spec.homepage      = "TODO: Put your gem's website or public repo URL here."
      spec.license       = "MIT"

      # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
      # to allow pushing to a single host or delete this section to allow pushing to any host.
      if spec.respond_to?(:metadata)
        spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
      else
        raise "RubyGems 2.0 or newer is required to protect against " \
          "public gem pushes."
      end
      #...
    end


!SLIDE small

## gemspec minitest

    @@@ Ruby
    Gem::Specification.new do |spec|
      spec.name          = "my_gem_mini"
      #...
      spec.files         = `git ls-files -z`.split("\x0").reject do |f|
        f.match(%r{^(test|spec|features)/})
      end
      spec.bindir        = "exe"
      spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
      spec.require_paths = ["lib"]

      spec.add_development_dependency "bundler", "~> 1.16"
      spec.add_development_dependency "rake", "~> 10.0"
      spec.add_development_dependency "minitest", "~> 5.0"
    end

!SLIDE small

## gemspec rspec

    @@@ Ruby
    Gem::Specification.new do |spec|
      spec.name          = "my_gem_rspec"
      #...
      spec.files         = `git ls-files -z`.split("\x0").reject do |f|
        f.match(%r{^(test|spec|features)/})
      end
      spec.bindir        = "exe"
      spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
      spec.require_paths = ["lib"]

      spec.add_development_dependency "bundler", "~> 1.16"
      spec.add_development_dependency "rake", "~> 10.0"
      spec.add_development_dependency "rspec", "~> 3.0"
    end


!SLIDE
# Configurar

!SLIDE

## test_helper.rb

~~~FILE:/examples/my_gem_mini/test/test_helper.rb:ruby~~~

!SLIDE

## spec_helper.rb

~~~FILE:/examples/my_gem_rspec/spec/spec_helper.rb:ruby~~~

!SLIDE
# Ejecutar

!SLIDE

## Rakefile (minitest)

~~~FILE:/examples/my_gem_mini/Rakefile:ruby~~~

!SLIDE

## Rakefile (rspec)

~~~FILE:/examples/my_gem_rspec/Rakefile:ruby~~~

