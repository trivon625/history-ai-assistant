class ChatsController < ApplicationController
  before_action :set_chat, only: [:show]

  def show
    @topic = @chat.topic
    @messages = @chat.messages.order(:created_at)
    @message = Message.new
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
            if @chat.title.present?
              @chat.messages.create(content: @chat.title, user: current_user, role: 'user')
              instructions = "You are a world-class historian specializing in #{@chat.title}."
              history = [{ role: "user", content: @chat.title}]
              ai_content = RubyLLM.chat.with_instructions(instructions).ask(history).content
              @chat.messages.create(role: "assistant", content: ai_content, user: current_user)
            end
            
            redirect_to chat_path(@chat), notice: "Chat started successfully!"
          else
            render :new, status: :unprocessable_entity
          end
    end
    def index
      @topic = Topic.find(params[:topic_id])
      @chats = @topic.chats
    end

    private

    def chat_params
        params.require( :chat).permit( :title)
    end

    def set_chat
      @chat = Chat.find(params[:id])
    end
end
