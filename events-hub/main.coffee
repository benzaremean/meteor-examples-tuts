@Venues = new Meteor.Collection "venues"
###
Template.searchform.events
	'click #searchbutton': (e, t) ->
		addressreference = $.trim(t.find("#address-search").value)
		radius = parseInt $.trim(t.find("#radius").value)
		if addressreference is ""
			alert "fill form out bish"
		else
			url = "venues?radius=#{radius}&reference=#{addressreference}"
			Backbone.history.navigate url, true

			#Meteor.subscribe "venues"

			EventsRouter = Backbone.Router.extend
				routes: {
					"" : "main",
					"venues": "getVenues",
					"venues?:params": "getVenuesWithParams",
					"venues/new": "newVenue",
					"venues/:id": "showVenue",
					"services": "showServices",
					"about": "showAbout",
					"contact-us": "showContactUs"
				},
				main: () ->
					Session.set 'currentView', 'home'
					#if null
					unless Session.get('displayView')?
						Session.set 'displayView', 'listview'
						sessionStorage.setItem "displayView", 'listview'
					else
						console.log "dkjhjgdhkghdjgjkhdjhgjkhdkjghjkdhjk"
				getVenues: () ->
					#if Session.get('venues') length is not 1 or more (not set)
					unless Session.get('venues')?.length > 0			 
						if sessionStorage.getItem("venues")?.length is 0
							query = {}
							Meteor.call "getVenues", query, (err, results) ->
								if results?
									console.log results
									Session.set 'venues', results
						else
							sessionSavedVenues = sessionStorage.getItem 'venues'
							Session.set 'venues', $.parseJSON sessionSavedVenues		
					
					#if displayview is null
					unless Session.get('displayView')?
						Session.set 'displayView', sessionStorage.getItem "displayView"
					#now set the page to venues
					Session.set 'currentView', 'venues'
				newVenue: () -> 
					Session.set 'currentView', 'newVenueForm'
				showVenue: (id) ->
					console.log id
					Session.set 'currentView', 'venue'
					Session.set 'currentVenue', id
				showServices: () -> 
					Session.set 'currentView', 'services'
				showAbout: () -> 
					Session.set 'currentView', 'about'
				showContactUs: () -> 
					Session.set 'currentView', 'contactUs'
				getVenuesWithParams: (params) ->
					radius = getParameterByName('radius')
					addressreference = getParameterByName('reference')
					#reverse geocode search address
					Meteor.call "geoCode", addressreference, (err, geocoderesults) ->
						if geocoderesults.length
							#build a query string using mongo geospatial within					
							query = loc:
							  $geoWithin:
							    $centerSphere: [[geocoderesults[0].lng, geocoderesults[0].lat], radius / 3959]
							
							Meteor.call "getVenues", query, (err, results) ->
								if results?.length > 0							
									Session.set 'venues', results
									sessionStorage.setItem "venues", JSON.stringify results
									Session.set 'currentView', 'venues'
								else
									#ideally direct to /venues and show no result message
									alert 'no results were found try again'

						#if no results	
						else
							alert "are you sure you have entered address correctly? please have a look and try again"

			getParameterByName = (name) ->
			  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
			  regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
			  results = regex.exec(location.search)
			  (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))


			Meteor.startup ->
				new EventsRouter()
				Backbone.history.start pushState: true###









				




