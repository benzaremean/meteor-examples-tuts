ifViewing = (viewName) -> Session.get('currentView') is viewName
showMap = ()-> Session.get('showMap')

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

Template.newForm.showMap = ->
	showMap()

Template.map.rendered = ()->
	apiKey = "66fbb0e43eb647e7aa930936d2dce669"
	attribution = "Map data &copy; <a href=\"http://openstreetmap.org\">OpenStreetMap</a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"http://cloudmade.com\">CloudMade</a>"
	openStreetMap = "http://{s}.tile.osm.org/{z}/{x}/{y}.png"
	cloudMade = "http://{s}.tile.cloudmade.com/{key}/{styleId}/256/{z}/{x}/{y}.png"
	lat = Session.get('lat')
	lng = Session.get('lng')
	map = L.map("map").setView([lat, lng], 14)

	L.Icon.Default.imagePath = 'http://leafletjs.com/dist/images'

	L.tileLayer(cloudMade,
	  attribution: attribution
	  key: apiKey
	  styleId: 1714
	  maxZoom: 18
	).addTo map
	marker = L.marker([lat, lng]).addTo(map);

Template.newForm.events
	'click #validate-address': (e, t) ->
		addressl1 = $.trim(t.find("#address-line1").value)
		addressl2 = $.trim(t.find("#address-line2").value)
		addresspc = $.trim(t.find("#address-postCode").value)
		addresstwn = $.trim(t.find("#address-town").value)
		if addressl1 is "" and addresspc is "" and addresstwn is ""
			alert "fill form out bish"
		else
			concatAddress = "#{addressl1} #{addressl2} #{addresspc} #{addresstwn}".split(' ').join('+')
			Meteor.call "geoCode", concatAddress, (err, results) ->
				if results.length				
					Session.set('lat', results[0].lat)
					Session.set('lng', results[0].lng)
					Session.set('showMap', true)
				else
					alert "are you sure you have entered address correctly? please have a look and try again"
	
	'submit #new-venue-form': (e, t) ->		
		e.preventDefault()

		addressl1 = $.trim(t.find("#address-line1").value)
		addressl2 = $.trim(t.find("#address-line2").value)
		addresspc = $.trim(t.find("#address-postCode").value)
		addresstwn = $.trim(t.find("#address-town").value)
		$('#new-venue-form').validate
			onfocusout: false
			invalidHandler: (form, validator) ->
				errors = validator.numberOfInvalids()
				validator.errorList[0].element.focus()  if errors
		if $('#new-venue-form').valid()
			name = $.trim(t.find("#name").value)
			about = $.trim(t.find("#about").value)
			hiretype = t.find("input[name='optionsRadios']:checked").value

			address = { 
				line1: addressl1
				line2: addressl2
				postcode: addresspc
				town: addresstwn
				long: Session.get('lng')
				lat: Session.get('lat')
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

			# find all selected facilities checkbox values
			selectedFacilitiesElements = t.findAll("label input[type='checkbox']:checked")
			selectedFacilitiesValues = []
			selectedFacilitiesValues.push elems.value for elems in selectedFacilitiesElements	

			publish = false	
			
			console.log name

			Meteor.call "createVenue",
				name
				about
				hiretype
				address
				rooms
				contact
				publish
				selectedFacilitiesValues
				(err, id) -> console.log id









