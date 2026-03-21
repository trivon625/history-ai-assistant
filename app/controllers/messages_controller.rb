class MessagesController < ApplicationController
    def create
        @chat = current_user.chats.find(params[:chat_id])
        @message = @chat.messages.build(message_params)
        @message.user = current_user
        @message.role = "user"

      if @message.save
        chat_topic = @chat.topic
        instructions = <<~PROMPT 
          #{chat_topic.ai_instructions} 
          The user's name is #{current_user.name}.
          Always use their name when replying.
          The current topic is : #{chat_topic.title}.
          You must only answerquestions about this topic.
        PROMPT
        chat_ai = RubyLLM.chat(model: "claude-haiku-4-5-20251001")
                        .with_instructions(instructions)
        @chat.messages.order(:created_at).each do |m|
         chat_ai.add_message(role: m.role, content: m.content)
        end
        ai_response = chat_ai.ask(@message.content)
        ai_content = ai_response.content
        @chat.messages.create(role: "assistant", content: ai_content, user: current_user)

        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to chat_path(@chat) }
        end
      else
        respond_to do |format|
          format.turbo_stream do render turbo_stream: turbo_stream.replace("new_message_container", partial: "messages/form", locals: { chat: @chat, message: @message })
        end 
          format.html { render "chats/show", status: :unprocessable_entity }
        end
      end
    end

    private
    def message_params
        params.require(:message).permit(:content)
    end
end



