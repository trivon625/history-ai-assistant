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
    def new
      @topic = Topic.find(params[:topic_id])
      @chat = Chat.new
    end

    def create
        @topic = Topic.find(params[:topic_id])
        @chat = @topic.chats.build(chat_params)
        @chat.user = current_user
          if @chat.save
            redirect_to chat_path(@chat), notice: "Chat started successfully!"
          else
            render :new, status: :unprocessable_entity
          end
    end

    def show
      @chat = Chat.find(params[:id])
      @messages = @chat.messages
      @message = Message.new
    end

    def index 
      @topic = Topic.find(params[:topic_id])
      @chats = @topic.chats
    end

    private
    def chat_params
        params.require( :chat).permit( :message)
    end
end


