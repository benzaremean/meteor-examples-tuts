#Meteor.subscribe "venues"

EventsRouter = Backbone.Router.extend
	routes: {
		"" : "main",
		"venues": "getVenues",
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
				Meteor.call "getVenues", {}, (err, results) ->
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

Meteor.startup ->
	new EventsRouter()
	Backbone.history.start pushState: true







	