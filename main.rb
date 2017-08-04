require 'dotenv/load'
require 'tracker_api'

client = TrackerApi::Client.new(token: ENV['API_TOKEN'])

project = client.project(ENV['PROJECT_ID'])
states = ['accepted', 'delivered', 'finished', 'started', 'rejected', 'planned', 'unstarted', 'unscheduled']

stories = states.reduce({}) do |prev, cur|
  cur = cur.to_sym
  prev[cur] = project.stories(with_state: cur)
  prev
end

puts stories.to_json