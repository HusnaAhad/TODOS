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

class ApiHelper
  @@todo_ids = []
  @@base_uri = 'http://lacedeamon.spartaglobal.com/todos/'

  def self.base_uri
    @@base_uri
  end

  def self.post_example
    res = HTTParty.post "#{@@base_uri}?title=thejourneybegins&due=#{Date.today.to_s}"
    @@todo_ids << res['id']
    return res
  end

  def self.post(title, due)
    res = HTTParty.post "#{@@base_uri}?title=#{title}&due=#{due}"
    @@todo_ids << res['id']
    return res
  end

  def self.patch(id, title, due)
    res = HTTParty.patch "#{@@base_uri}#{id}/?title=#{title}&due=#{due}"
    return res
  end

  def self.put(id, title, due)
    res = HTTParty.put "#{@@base_uri}#{id}/?title=#{title}&due=#{due}"
    return res
  end

  def self.get_collection
    res = HTTParty.get "#{@@base_uri}"
    return res
  end

  def self.get_todo id
    res = HTTParty.get "#{@@base_uri}#{id}"
    return res
  end

  def self.delete todo_id
    HTTParty.delete "#{@@base_uri}#{todo_id}"
  end

  def self.teardown
    @@todo_ids.each do |todo_id|
      self.delete todo_id
    end
  end
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


