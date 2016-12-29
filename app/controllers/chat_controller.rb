class ChatController < ApplicationController
  def index
    @chats = $chats || []
  end
end
