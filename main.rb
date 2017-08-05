require 'dotenv/load'
require 'tracker_api'

client = TrackerApi::Client.new(token: ENV['API_TOKEN'])

project = client.project(ENV['PROJECT_ID'])
#states = %i[accepted delivered finished started rejected planned unstarted unscheduled]
states = %i[planned delivered finished started rejected]

# aperently the come through in the order that they're displayed.
all_stories = project.stories
puts "SIZEN #{all_stories.count}"
test = all_stories.map do |story|
  [story.id, story.name, story.before_id, story.after_id]
end
puts test

stories = states.each_with_object({}) do |state, memo|
  memo[state] = project.stories(with_state: state)
end

purdy = stories.map do |(key, stories)|
  puts ''
  puts "Key #{key} Stories #{stories.count}"
  { key => stories.map do |story|
    puts "Story #{story.name} #{story.id} "
    { story.name => story.labels.map(&:name) }
  end }
end

puts ''
puts 'PURDY'
puts purdy.to_json
