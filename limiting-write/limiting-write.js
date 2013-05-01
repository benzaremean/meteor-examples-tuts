Items = new Meteor.Collection("items");

Items.allow({
  insert: function (userid, doc) {
    return (userid && doc.owner === userid);
  },

  update: function (userId, doc, fields, modifier) {
      return doc.owner === userId;
  },

  remove: function (userId, doc) {
    return doc.owner === userId;
  }
});

Items.deny({
  update: function (userId, docs, fields, modifier) {
    return (fields.indexOf("owner") > -1);
  }
});
