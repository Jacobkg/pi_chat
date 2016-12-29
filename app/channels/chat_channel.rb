class ChatChannel < ApplicationCable::Channel
  # Called when the consumer has successfully become a subscriber
  def subscribed
    stream_from "chat_#{params[:room]}"
  end

  def receive(data)
    $chats ||= []
    $chats << data
    ActionCable.server.broadcast("chat_home", data)
  end
end
