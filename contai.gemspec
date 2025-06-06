# frozen_string_literal: true

require_relative "lib/contai/version"

Gem::Specification.new do |spec|
  spec.name = "contai"
  spec.version = Contai::VERSION
  spec.authors = ["Panasenkov A."]
  spec.email = ["apanasenkov@capaa.ru"]

  spec.summary = "Gem for generating AI content for rails models"
  spec.description = "A Ruby on Rails gem that provides seamless integration with AI services to automatically generate content for your Rails models. It offers a simple interface to enhance your models with AI-generated content, supporting various content types and customization options."
  spec.homepage = "https://github.com/capaas/contai"
  spec.license = "CAPAAL"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/capaas/contai"
  spec.metadata["changelog_uri"] = "https://github.com/capaas/contai/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 7.0", "< 9.0"
  spec.add_dependency "httparty", "~> 0.20"
  
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "sqlite3", "~> 1.4"
end
