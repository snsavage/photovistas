ENV['RACK_ENV'] = "test"

require_relative "../config/environment"
require 'rack/test'
require 'capybara/rspec'
require 'vcr'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate SINATRA_ENV=test` to resolve the issue.'
end

ActiveRecord::Base.logger = nil

RSpec.configure do |config|

  config.include Rack::Test::Methods
  config.include Capybara::DSL
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    FactoryGirl.find_definitions
  end

  DatabaseCleaner.strategy = :truncation

  config.before do
    DatabaseCleaner.clean
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

def app
  Rack::Builder.parse_file('config.ru').first
end

Capybara.app = app

def login
  user = create(:user)
  post '/login', {username: user.username, password: user.password}
  return user
end

def root_path
  "http://example.org/"
end

def unsplash_token_setup
  file = File.read('spec/token.json')
  data = JSON.parse(file)
  Unsplash::Client.connection.create_and_assign_token(data)
  return data
end

