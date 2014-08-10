# lastminuterail.rb
require 'sinatra'
require 'rubygems'
require 'json'
require 'net/http'

get '/departing/:start_station/visiting/:end_station/userlocation/:user_location' do |start_station, end_station, user_location|
	content_type 'application/json'
	uri = URI('https://citymapper.com/api/1/raildepartures')
	params = { :ids => start_station }
	uri.query = URI.encode_www_form(params)

	citymapper_response = Net::HTTP.get_response(uri)

	if citymapper_response.code == "200"
		next_trains = []
		result = JSON.parse(citymapper_response.body)
		result["stations"][0]["departures"].each do |departure|
			departure["stops"].each do |stop|
				if stop["id"] == end_station
					next_trains << {:train_for => departure["destination"], :scheduled_time => departure["scheduled_time"]}
				end
			end
		end

		station_coords = result["stations"][0]["station"]["coords"]
		station_location_string = "#{station_coords[0]},#{station_coords[1]}"
		minutes_to_walk = minutes_walk_to_station(user_location, station_location_string)
		
		{:next_trains => next_trains, :minutes_walk_to_station => minutes_to_walk}.to_json
	else
		'Error Code: ' + citymapper_response.code
	end
	
end

def minutes_walk_to_station(latlong_user, latlong_station)
	uri = URI('http://maps.googleapis.com/maps/api/distancematrix/json')
	params = { :origins => latlong_user, :destinations => latlong_station, :mode => 'walking' }
	uri.query = URI.encode_www_form(params)

	google_response = Net::HTTP.get_response(uri)

	if google_response.code == "200"
		result = JSON.parse(google_response.body)
		minutes = (result["rows"][0]["elements"][0]["duration"]["value"] / 60) + 2
	else
		'Error calculating walking time.'
	end
end