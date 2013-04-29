function add (item) {
  var list = Session.get("list");
  list.push(item);
  Session.set("list", list);
}

function remove (item) {
  var list = Session.get("list");
      i = list.indexOf(item);
  if (i > -1) {
    Session.set("list", list.slice(0, i).concat(list.slice(i+1)));
  }
}

if (Meteor.isClient) {
  Session.set("list", ["one", "two"]);


  Template.list.items = function () {
    return Session.get("list");
  };

  Template.list.events({
    'keypress input': function(e, t) {
      if(e.keyCode === 13) {
        var input = t.find("input");
        add(input.value);
        input.value = "";
      } 
    }
  });

  Template.item.events({
    'click': function(e, t) {
      remove(t.data);
    }
  });

  Template.item.rendered = function () {
    console.log("rendered:", this.data);
  }

  Template.item.created = function () {
    console.log("created:", this.data);
  };

  Template.item.destroyed = function () {
    console.log("destroyed:", this.data);
  };
};