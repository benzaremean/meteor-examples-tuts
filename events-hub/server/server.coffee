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
