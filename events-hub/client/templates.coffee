ifViewing = (viewName) -> Session.get('currentView') is viewName

Template.globalNav.events
	'click a#new': () -> Backbone.history.navigate 'venues/new', true
	'click a#venues': () -> Backbone.history.navigate 'venues', true
	'click a#services': () -> Backbone.history.navigate 'services', true
	'click a#about': () -> Backbone.history.navigate 'about', true
	'click a#contact-us': () -> Backbone.history.navigate 'contact-us', true


Template.content.showHome = ->
	ifViewing 'home'

Template.content.showNewForm = ->
	ifViewing 'newVenueForm'

Template.content.showGetVenues = ->
	ifViewing 'venues'

Template.content.showAbout = ->
	ifViewing 'about'

Template.content.showContactUs = ->
	ifViewing 'contactUs'

Template.content.showServices = ->
	ifViewing 'services'

Template.newForm.events
	'submit form': (e, t) ->
		e.preventDefault()
		#Meteor.call "geoCode", "NW11QE", (err, results) ->
		#	console.log err

		if $( 'form' ).parsley( 'validate' )
			name = $.trim(t.find("#name").value)
			about = $.trim(t.find("#about").value)

			address = { 
				line1: $.trim(t.find("#address-line1").value)
				line2: $.trim(t.find("#address-line2").value)
				postcode: $.trim(t.find("#address-postCode").value)
				town: $.trim(t.find("#address-town").value)
			}

			rooms = []
			capacity = {
				standing: $.trim(t.find("#rooms-maxCapacityStanding-0").value)
				theatre: $.trim(t.find("#rooms-maxCapacityTheatre-0").value)
				banquet: $.trim(t.find("#rooms-maxCapacityBanquet-0").value)
				dimensions: $.trim(t.find("#rooms-dimensions-0").value)
			}
			room = {
				roomname: $.trim(t.find("#rooms-name-0").value)
				description: $.trim(t.find("#rooms-description-0").value)
				capacity: capacity
			}
			rooms.push room

			contact = {
				name: $.trim(t.find("#contact-contactName").value)
				email: $.trim(t.find("#contact-email").value)
				telephone: $.trim(t.find("#contact-telephone").value)
				website: $.trim(t.find("#contact-website").value)
			}			
			
			console.log name

			Meteor.call "post",
				name
				about
				address
				rooms
				contact
				(err, id) -> console.log id









