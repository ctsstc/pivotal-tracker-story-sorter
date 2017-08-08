require 'dotenv/load'
require 'tracker_api'
# require 'pry'

client = TrackerApi::Client.new(token: ENV['API_TOKEN'])

project = client.project(ENV['PROJECT_ID'])
# states = %i[accepted delivered finished started rejected planned unstarted unscheduled]
states = %i[planned delivered finished started rejected]

types = states.each_with_object({}) do |state, memo|
  memo[state] = project.stories(with_state: state)
end

# Sort Collection By Labels
types.each do |(_type_key, stories)|
  stories.sort do |a, b|
    al = a.labels
    bl = b.labels
    if al.count > 0 && bl.count > 0
      if al[0].name < bl[0].name
        -1
      elsif al[0].name > bl[0].name
        1
      else
        # a <=> b
        0
      end
    # if b has labels and a doesn't prioritize b
    elsif bl.count > 0
      -1
    else
      0
    end
  end
end

# Update Order
last_story = false
types.each do |(_type_key, stories)|
  stories.each do |story|
    if last_story
      story.after_id = last_story.id
      story.save
      sleep 0.2
    end
    last_story = story
  end
end
