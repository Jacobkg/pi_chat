App.chatChannel = App.cable.subscriptions.create { channel: "ChatChannel", room: "home" },
  received: (data) ->
    chatSuffix = "(" + data.time + ") " + data.sent_by + ": "
    $('#chat-room').append("<p>" + chatSuffix + "<span style=\"font-family: " + data.font + "\">" + data.body + "</span></p>")
    document.title = "PiChat *" unless document.hasFocus()
    window.scrollTo(0,document.body.scrollHeight)

  appendLine: (data) ->
    console.log("appendLine: " + data)

  createLine: (data) ->
    console.log("Created: " + data)

