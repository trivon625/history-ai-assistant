class MessagesController < ApplicationController
    def create
        @chat = current_user.chats.find(params[:chat_id])
        @message = @chat.messages.build(message_params)
        @message.user = current_user
        @message.role = "user"

        if @message.save
            chat_title = @chat.title
            instructions = "You are a world-class historian specializing in #{chat_title}."
            history = @chat.messages.order(:created_at).map do |m|
                {role: m.role, content: m.content}
            end
            
            ai_response = RubyLLM.chat.with_instructions(instructions).ask(history)
            ai_content = ai_response.content
            @chat.messages.create(role: "assistant", content: ai_content, user: current_user)
            redirect_to chat_path(@chat)
        else
            render "chats/show", status: :unprocessable_entity
        end
    end

    private
    def message_params
        params.require(:message).permit(:content)
    end
end
