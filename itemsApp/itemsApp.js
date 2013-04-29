Items = new Meteor.Collection("items");

if (Meteor.isClient) {
  Meteor.autosubscribe(function () {
    Meteor.subscribe("items", Session.get("category"));
  });
  

  Template.items.items = function () {
    return Items.find();
  };

  Template.name.events({
    'keypress input': function (e, t) {
      if(e.keyCode === 13) {
        Session.set("category", e.currentTarget.value);
        e.currentTarget.value = "";
      }
    }
  });
}

if (Meteor.isServer) {
  Meteor.publish("items", function (category) {
    return Items.find( {category: category });
  });  
}
