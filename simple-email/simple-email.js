if (Meteor.isClient) {
  Template.emailForm.events({
    'click button' : function(e, t) {
      var to = t.find("#to").value,
        subject = t.find("#subject").value,
        text = t.find("#text").value;
      Meteor.apply("sendEmail", [to, subject, text]);
    }
  });
}

if (Meteor.isServer) {
  Meteor.methods({
    sendEmail: function (to, subject, text) {
      Email.send({
        from: "admin@localhost.com",
        to: to,
        subject: subject,
        html: text
      });
    }
  });
}
