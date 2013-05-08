Meteor.subscribe "venues"

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
		console.log "at home bitches"
		Session.set 'currentView', 'home'
	getVenues: () -> 
		console.log "hey we want some pussy"
		Session.set 'currentView', 'venues'
	newVenue: () -> 
		Session.set 'currentView', 'newVenueForm'
	showVenue: () -> 
		console.log "hey we really really want some pussy"
		Session.set 'currentView', 'venue'
	showServices: () -> 
		console.log "hey we really really want some pussy..... service us"
		Session.set 'currentView', 'services'
	showAbout: () -> 
		console.log "hey we really really want some pussy about"
		Session.set 'currentView', 'about'
	showContactUs: () -> 
		console.log "hey we really really want some pussy  so contact us"
		Session.set 'currentView', 'contactUs'


Meteor.startup () ->
	new EventsRouter
	Backbone.history.start pushState: true