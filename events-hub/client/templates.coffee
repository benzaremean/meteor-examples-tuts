ifViewing = (viewName) -> Session.get('currentView') is viewName
showMap = ()-> Session.get('showMap')
uploadSuccessful = ()-> Session.get('upldsuccess')? and Session.get("myarray")?.length > 0

Template.globalNav.events
	'click a#new': ()-> Backbone.history.navigate 'venues/new', true
	'click a#venues': ()-> Backbone.history.navigate 'venues', true
	'click a#services': ()-> Backbone.history.navigate 'services', true
	'click a#about': ()-> Backbone.history.navigate 'about', true
	'click a#contact-us': ()-> Backbone.history.navigate 'contact-us', true


Template.content.showHome = ->
	ifViewing 'home'

Template.content.showNewForm = ->
	ifViewing 'newVenueForm'

Template.content.showVenues = ->
	ifViewing 'venues'

Template.content.showAbout = ->
	ifViewing 'about'

Template.content.showContactUs = ->
	ifViewing 'contactUs'

Template.content.showServices = ->
	ifViewing 'services'

Template.content.showVenue= ->
	ifViewing 'venue'

Template.newForm.showMap = ->
	showMap()

Template.newForm.uploadSuccessful = ->
	uploadSuccessful()

Template.venue.document = ()->
	Venues.findOne Session.get "currentVenue"

Template.venues.all = ()->
	Session.get('venues')
	

Template.newForm.rendered = ()->
	#if not attached, attach it bishes
	if $('#filepicker_comm_iframe').length is 0
		script = '<script type="text/javascript" src="//api.filepicker.io/v1/filepicker.js"></script>'
		$('body').append(script)
		filepicker.setKey "AU2hmvvEDS5GPPz1wn5ecz"

Template.upldArray.uploadedpic = ()->
	Session.get 'myarray'

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
	marker = L.marker([lat, lng]).addTo(map)

Template.chooseFileButton.events
	'click #choose-files': (evt, tmpl)->
		evt.preventDefault()
		#using filepicker.io to upload files
		filepicker.setKey "AU2hmvvEDS5GPPz1wn5ecz"
		filepicker.pickMultiple
		  mimetypes: ["image/*", "text/plain"]
		  container: "window"
		  services: ["COMPUTER", "FACEBOOK", "GMAIL"]
		, ((FPFile) ->
			Session.set('upldsuccess', true)
			Session.set('myarray', FPFile)
		), (FPError) ->
			console.log FPError.toString()


Template.upld.events
	'click .remove': (evt, tmpl)->
		uploadedPics = Session.get('myarray')
		url = tmpl.find(".xx").value
		console.log url
		forRemoval = _.find uploadedPics, (pic) ->
  			pic["url"] is url
		filepicker.setKey "AU2hmvvEDS5GPPz1wn5ecz"
		
		filepicker.remove forRemoval, ->
  			notForRemoval = _.filter(uploadedPics, (pic) ->
  				pic["url"] isnt url
  			)

  			if notForRemoval.length is 0
  				Session.set('upldsuccess', false)
  			Session.set('myarray', notForRemoval)
 


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
			}

			loc = [Session.get('lng'), Session.get('lat')]

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

			#set publish flag to false
			publish = false

			
			pics = []			
			if Session.get('myarray')?
				pics = Session.get('myarray') 


			#create venue
			Meteor.call "createVenue",
				name
				about
				hiretype
				address
				loc
				rooms
				contact
				publish
				selectedFacilitiesValues
				pics
				(err, id) -> 
					console.log id
					Backbone.history.navigate "/venues/" + id, true


Template.searchform.events
	'click #searchbutton': (e, t) ->
		addressreference = $.trim(t.find("#address-search").value)
		radius = parseInt $.trim(t.find("#radius").value)

		if addressreference is ""
			alert "fill form out bish"
		else
			Meteor.call "geoCode", addressreference, (err, results) ->
				if results.length
					
					query = loc:
					  $geoWithin:
					    $centerSphere: [[results[0].lng, results[0].lat], radius / 3959]
					
					Meteor.call "getVenues", query, (err, results) ->
						if results?
							console.log results
							Session.set 'venues', results
					Backbone.history.navigate 'venues', true
				else
					alert "are you sure you have entered address correctly? please have a look and try again"















