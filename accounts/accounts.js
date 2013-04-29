if (Meteor.isClient) {
  Template.login.creatingAccount = function () {
    console.log(Session.get("creatingAccount"));
    return Session.get("creatingAccount");
  };

  Template.login.events({
    'click #loginForm': function () {
      Session.set('creatingAccount', false);
    },
    'click #accountForm': function () {
      Session.set('creatingAccount', true);
    },
    'click #createAccount': function (e, t) {
      Session.set('creatingAccount', false);
      Accounts.createUser({
        username: t.find("#username").value,
        password: t.find("#password").value,
        email: t.find("#email").value,
        profile: {
          name: t.find("#name").value  
        }
      });
    },
    'click #logout': function() {
      Meteor.logout();
    },
    'click #login': function(e, t) {
      Meteor.loginWithPassword(t.find("#username").value, t.find("#password").value);
    }
  });
}

if (Meteor.isServer) {
  
}
