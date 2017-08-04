require 'dotenv/load'
require 'tracker_api'

client = TrackerApi::Client.new(token: ENV['API_TOKEN'])

project = client.project(ENV['PROJECT_ID'])
states = %i[accepted delivered finished started rejected planned unstarted unscheduled]

stories = states.each_with_object({}) do |state, memo|
  memo[state] = project.stories(with_state: state)
end

puts stories.to_json
