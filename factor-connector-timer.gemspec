# encoding: UTF-8
$LOAD_PATH.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'factor-connector-timer'
  s.version       = '3.0.01'
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Maciej Skierkowski']
  s.email         = ['maciej@factor.io']
  s.homepage      = 'https://factor.io'
  s.summary       = 'Timer Factor.io Connector'
  s.files         = ['lib/factor-connector-timer.rb']
  
  s.require_paths = ['lib']

  s.add_runtime_dependency 'rufus-scheduler', '~> 3.2.0'

  s.add_development_dependency 'codeclimate-test-reporter', '~> 0.5.0'
  s.add_development_dependency 'rspec', '~> 3.4.0'
  s.add_development_dependency 'rake', '~> 11.1.2'
end