People = new Meteor.Collection("people");

if (Meteor.isClient) {
  Template.personList.people = function () {
    return People.find();
  };

  Template.personForm.events({
    'click button': function (e, t) {
      var el = t.find("#name");
      People.insert({ name: el.value });
      el.value = "";
    } 
  });

  Template.person.editing = function () {
    return Session.get("edit-" + this._id);
  };

  Template.person.rendered = function () {
    var input = this.find("input");
    if (input) {
      input.focus();
    }
  };

  Template.person.events({
      'click .name': function (e, t) {
        Session.set("edit-" + t.data._id, true);
      },
      'keypress input': function (e, t) {
        if (e.keyCode === 13) {
          People.update(t.data._id, { $set: { name : e.currentTarget.value }});
          Session.set("edit-" + t.data._id, false);
        }
      },
      'click .del': function (e, t) {
        People.remove(t.data._id);  
      }
  });
}
