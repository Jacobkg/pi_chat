App.chatChannel = App.cable.subscriptions.create { channel: "ChatChannel", room: "home" },
  received: (data) ->
    chatMessage = "(" + data.time + ") " + data.sent_by + ": " + data.body
    $('#chat-room').append("<p style=\"font-family: " + data.font + "\">" + chatMessage + "</p>")
    window.scrollTo(0,document.body.scrollHeight)

  appendLine: (data) ->
    console.log("appendLine: " + data)

  createLine: (data) ->
    console.log("Created: " + data)

