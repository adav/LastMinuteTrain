LastMinuteTrain
===============

A little nicknack for myself so that I can time, to the minute, my walk to the station for my commute home!

It sneaks a look at the CityMapper API, using the same call by their superduper [Super Router](https://citymapper.com/london/superrouter) to see what trains are due to leave a specified station.

The script then filters out only trains that stop at my home station.
The script also lists how many minutes walk away the station is using the [Google Maps Distance Matrix API](https://developers.google.com/maps/documentation/distancematrix/).

Notes
-----

This is my very first forray into Ruby. I've since learnt that there are many rubyisms that I haven't exploited but the script is so short and self-explanitory, I don't feel it needs a refactor just yet. I quite like how simple [Sinatra](http://www.sinatrarb.com) is to get going - very impressive.
