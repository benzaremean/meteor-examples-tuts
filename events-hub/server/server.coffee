#Meteor.publish "venues", () -> Venues.find()

Meteor.methods
	createVenue: (name, about, hiretype, address, loc, rooms, contact, publish, facilities, pics) ->
		Venues.insert
			name: name
			about: about
			hiretype: hiretype
			address: address
			loc: loc
			rooms: rooms
			contact: contact
			publish: false
			facilities: facilities
			createdOn: new Date
			images: pics

	geoCode: (addressSearchString) ->
		result = Meteor.http.get "http://maps.googleapis.com/maps/api/geocode/json",
			params:
				address: addressSearchString
				sensor: true
		
		if result.statusCode is 200
			result.data.results.map (x) ->
				lat: x.geometry.location.lat
				lng: x.geometry.location.lng

	getVenues: (query) ->
		Venues.find(query, { limit: 10 }).fetch()
	getVenue: (id) ->
		Venues.findOne id

Meteor.startup () ->
	Venues._ensureIndex loc: "2d"

