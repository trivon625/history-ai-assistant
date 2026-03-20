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
          { role: m.role, content: m.content }
        end
        ai_response = RubyLLM.chat(model: "claude-haiku-4-5-20251001")
                        .with_instructions(instructions)
                        .ask(history)
        ai_content = ai_response.content
        @chat.messages.create(role: "assistant", content: ai_content, user: current_user)

        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to chat_path(@chat) }
        end
      else
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace("new_message_container", partial: "messages/form", locals: { chat: @chat, message: @message }) }
          format.html { render "chats/show", status: :unprocessable_entity }
        end
      end
    end

    private
    def message_params
        params.require(:message).permit(:content)
    end
end
