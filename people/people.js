if (Meteor.isClient) {
  Template.staff.people = [
    { fullName: "John Smith", job: "CEO"},
    { fullName: "Taiween Evan", job: "CTO"},
    { fullName: "Lake Ricki", job: "developer"},
    { fullName: "Smarty Ass", job: "designer"}
  ];

  Template.person.executive = function () {
    return !!this.job.match(/^C.*O$/);
  };
}