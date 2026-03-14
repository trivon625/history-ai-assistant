class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat = Chat.find(params[:chat_id])
    @message = @chat.messages.build(message_params)

    if @message.save
      # Creamos un mensaje simulado de la "AI"
      @chat.messages.create(
        content: "This is a simulated AI response for now.",
        role: "Chat"
      )
      redirect_to chat_path(@chat)
    else
      flash[:alert] = "Failed to send message"
      redirect_to chat_path(@chat)
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :role)
  end
end
