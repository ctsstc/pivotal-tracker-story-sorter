require 'dotenv/load'
require 'tracker_api'

client = TrackerApi::Client.new(token: ENV['API_TOKEN'])