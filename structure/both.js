if(Meteor.isClient) {
	console.log('both.js (client)');
}

if (Meteor.isServer) {
	console.log('both.js (server)');
}

Meteor.startup(function () {
if(Meteor.isClient) {
	console.log('both.js (client) bla bla bla')
}
if(Meteor.isServer) {
	console.log('both.js (server) bla bla bla')
}
});
