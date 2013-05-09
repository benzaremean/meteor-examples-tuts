Meteor.publish "venues", () -> Venues.find()

Meteor.methods
	createVenue: (name, about, address, rooms, contact) ->
		Venues.insert
			name: name
			about: about
			address: address
			rooms: rooms
			contact: contact
	geoCode: (addressSearchString) ->
		result = Meteor.http.get "http://maps.googleapis.com/maps/api/geocode/json",
			params:
				address: addressSearchString
				sensor: true
		
		if result.statusCode is 200
			result.data.results.map (x) ->
				lat: x.geometry.location.lat
				lng: x.geometry.location.lng





###{
   "results" : [
      {
         "address_components" : [
            {
               "long_name" : "Werrington Street",
               "short_name" : "Werrington St",
               "types" : [ "route" ]
            },
            {
               "long_name" : "London",
               "short_name" : "London",
               "types" : [ "locality", "political" ]
            },
            {
               "long_name" : "London Borough of Camden",
               "short_name" : "London Borough of Camden",
               "types" : [ "administrative_area_level_3", "political" ]
            },
            {
               "long_name" : "Greater London",
               "short_name" : "Gt Lon",
               "types" : [ "administrative_area_level_2", "political" ]
            },
            {
               "long_name" : "England",
               "short_name" : "England",
               "types" : [ "administrative_area_level_1", "political" ]
            },
            {
               "long_name" : "United Kingdom",
               "short_name" : "GB",
               "types" : [ "country", "political" ]
            },
            {
               "long_name" : "NW1",
               "short_name" : "NW1",
               "types" : [ "postal_code_prefix", "postal_code" ]
            },
            {
               "long_name" : "London",
               "short_name" : "London",
               "types" : [ "postal_town" ]
            }
         ],
         "formatted_address" : "Werrington Street, London Borough of Camden, NW1, UK",
         "geometry" : {
            "bounds" : {
               "northeast" : {
                  "lat" : 51.53284630,
                  "lng" : -0.13290620
               },
               "southwest" : {
                  "lat" : 51.53047240,
                  "lng" : -0.13537530
               }
            },
            "location" : {
               "lat" : 51.53177820,
               "lng" : -0.13428780
            },
            "location_type" : "GEOMETRIC_CENTER",
            "viewport" : {
               "northeast" : {
                  "lat" : 51.53300833029150,
                  "lng" : -0.1327917697084980
               },
               "southwest" : {
                  "lat" : 51.53031036970850,
                  "lng" : -0.1354897302915020
               }
            }
         },
         "postcode_localities" : [],
         "types" : [ "route" ]
      }
   ],
   "status" : "OK"
}###