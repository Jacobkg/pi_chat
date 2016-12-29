$( document ).ready(function() {
  console.log("Enabling Button");

  $('#message-form').submit(function() {
    var username = $('#username').val();
    var body = $('#message').val();
    var font = $('#font').val();
    var date = new Date().toTimeString().substr(0,5)
    var timestamp 
    App.chatChannel.send({ time: date, sent_by: username, font: font, body: body }); 
    $('#message').val('');
    return false;
  });
});
