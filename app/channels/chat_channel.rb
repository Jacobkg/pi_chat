class ChatChannel < ApplicationCable::Channel
  # Called when the consumer has successfully become a subscriber
  def subscribed
    stream_from "chat_#{params[:room]}"
  end

  def receive(data)
    data['body'].gsub!(/\[[dD](\d{1,2})\]/) {|x| "<span style=\"color: #4ca9d4\">#{SecureRandom.random_number(x[$1].to_i) + 1}</span>" }
    $chats ||= []
    $chats << data
    ActionCable.server.broadcast("chat_home", data)
  end
end
