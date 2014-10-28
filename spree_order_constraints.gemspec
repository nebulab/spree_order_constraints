# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_order_constraints'
  s.version     = '2.3.2'
  s.summary     = 'Add constraints to your customers as they proceed to checkout'
  s.description = """
    This extension is a simple way to change the behaviour of `checkout_allowed?`
    to add some constraints to your customers as they proceed to checkout.
  """
  s.required_ruby_version = '>= 1.9.3'

  s.author    = 'NebuLab'
  s.email     = 'info@nebulab.it'
  s.homepage  = 'https://github.com/nebulab/spree_order_constraints'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.3'

  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.4'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.13'
  s.add_development_dependency 'sass-rails', '~> 4.0.2'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'timecop', '~> 0.7'
  s.add_development_dependency 'coveralls', '~> 0.7'
end
