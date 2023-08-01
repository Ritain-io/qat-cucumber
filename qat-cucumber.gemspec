#encoding: utf-8

Gem::Specification.new do |gem|
  gem.name        = 'qat-cucumber'
  gem.version     = '9.0.1'
  gem.summary     = %q{QAT is a Cucumber-based toolkit for automating tests.}
  gem.description = <<-DESC
  QAT is a Cucumber-based toolkit for automating tests, including a list fo modules for:
    - Time manipulation
    - Test reporting
    - Configuration management
    - Jenkins Integration
  DESC
  gem.email    = 'qatoolkit@readinessit.com'
  gem.homepage = 'https://www.ritain.io'

  gem.metadata    = {
      'source_code_uri'   => 'https://github.com/Ritain-io/qat-cucumber'
  }
  gem.authors = ['QAT']
  gem.license = 'GPL-3.0'

  extra_files = %w[LICENSE]
  gem.files   = Dir.glob('{lib}/**/*') + extra_files

  gem.executables.push('qat')

  gem.required_ruby_version = '~> 3.2'

  gem.add_dependency 'cucumber', '~> 8.0'
  gem.add_dependency 'psych', '< 4.0'
  gem.add_dependency 'rake', '~> 13.0'
  gem.add_dependency 'activesupport', '~> 7.0'
  gem.add_development_dependency 'nokogiri', '~> 1.15'

  gem.add_dependency 'qat-core', '~> 9.0'

  gem.add_development_dependency 'qat-devel', '~> 9.0'
  gem.add_development_dependency 'httparty', '~> 0.21'
end