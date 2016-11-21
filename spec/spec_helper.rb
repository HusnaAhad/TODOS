require 'pry'
require 'httparty'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end


def delete_all
  # Delete all todos title starting with thejourneybegins
  res = HTTParty.get 'http://lacedeamon.spartaglobal.com/todos/'
  res.each do |todo|
    if todo['title'] =~ /^thejourneybegins/i
      del = HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{todo['id']}"
    end
  end
end


