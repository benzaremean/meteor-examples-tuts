Meteor.publish "venues", () -> Venues.find()

Meteor.methods
	post: (name, about, address, rooms, contact, images) ->
		roomsArray = []
		roomsArray.push rooms
		imagesArray = []
		imagesArray.push images
		Venues.insert
			name: name
			about: about
			address: address
			rooms: roomsArray
			contact: contact
			images: imagesArray
			createdOn: new Date