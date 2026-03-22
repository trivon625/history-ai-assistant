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
        # Save the title as the first user message
        @chat.messages.create(content: @chat.title, user: current_user, role: "user")

        # Get AI response
        instructions = <<~PROMPT
          #{@topic.ai_instructions}
          The user's name is #{current_user.name}.
          Always use their name when replying.
          The current topic is: #{@topic.title}.
          You must only answer questions about this topic.
        PROMPT
        chat_ai = RubyLLM.chat(model: "claude-haiku-4-5-20251001")
                    .with_instructions(instructions)
        ai_content = chat_ai.ask(@chat.title).content
        @chat.messages.create(role: "assistant", content: ai_content, user: current_user)

        redirect_to chat_path(@chat), notice: "Chat started successfully!"
      else
        render :new, status: :unprocessable_entity
      end
  end

  def index
    @topic = Topic.find(params[:topic_id])
    @chats = @topic.chats
  end

  def destroy
    @chat = Chat.find(params[:id])
    @topic = @chat.topic
    @chat.destroy
    redirect_to topic_path(@topic), notice: "Chat deleted successfully!"
  end

  private

  def chat_params
      params.require( :chat).permit( :title)
  end

  def set_chat
    @chat = Chat.find(params[:id])
  end
end
