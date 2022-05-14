# frozen_string_literal: true

require_relative "lib/slack_blocks/version"

Gem::Specification.new do |spec|
  spec.name          = "slack_blocks"
  spec.version       = SlackBlocks::VERSION
  spec.authors       = ["Nick Meehan"]
  spec.email         = ["nnmeehan@gmail.com"]

  spec.summary       = "A simple Ruby templating library for working with Slack's Block Kit"
  spec.description   = "This templating library uses simple Ruby objects and methods to build a powerful framework that makes working with Slack's Block Kit interface easy and intuitive"
  spec.homepage      = "https://github.com/nickmeehan/slack-blocks"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/nickmeehan/slack-blocks"
  spec.metadata["changelog_uri"] = "https://github.com/nickmeehan/slack-blocks/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # ActiveSupport dependency covering April 2018 - May 2022 (so far).
  spec.add_dependency "activesupport", "~> 5.2.0"
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_development_dependency "rspec", "~> 3.11"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
