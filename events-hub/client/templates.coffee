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

