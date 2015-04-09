require "codeclimate-test-reporter"
require 'rspec'
require 'factor/connector/test'
require 'factor/connector/runtime'
require 'factor-connector-timer'

CodeClimate::TestReporter.start if ENV['CODECLIMATE_REPO_TOKEN']

Dir.glob('./lib/factor-connector-*.rb').each { |f| require f }

RSpec.configure do |c|
  c.include Factor::Connector::Test
end