require 'dotenv/load'
require 'tracker_api'
# require 'pry'

client = TrackerApi::Client.new(token: ENV['API_TOKEN'])

project = client.project(ENV['PROJECT_ID'])
#states = %i[accepted delivered finished started rejected planned unstarted unscheduled]
states = %i[planned delivered finished started rejected]

# apparently they come through in the order that they're displayed.
all_stories = project.stories
puts "SIZEN #{all_stories.count}"
test = all_stories.map do |story|
  [story.id, story.name, story.before_id, story.after_id]
end
puts test

stories = states.each_with_object({}) do |state, memo|
  memo[state] = project.stories(with_state: state)
end

# Sort Collection By Labels
#ar.sort do |a, b|
#  case
#  when a.x < b.x
#    -1
#  when a.x > b.x
#    1
#  else
#    a.y <=> b.y
#  end
#end 

# Update Order
last_story = false
stories.each do |(type_key, type)|
  type.each do |story|
    if last_story
      story.after_id = last_story.id
      story.save
      sleep 0.2
    end
    last_story = story
  end
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
