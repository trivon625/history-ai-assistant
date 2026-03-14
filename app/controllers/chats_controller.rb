class ChatsController < ApplicationController
  before_action :set_chat, only: [:show]

  def show
    @topic = @chat.topic
    @messages = @chat.messages.order(:created_at)
    @message = Message.new
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end
end
