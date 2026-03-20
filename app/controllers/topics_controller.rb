class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :generate_quiz]

  def index
    @topics = Topic.all
  end

  def show
  end

  def generate_quiz
    puts "GENERATING QUIZ FOR TOPIC ID: #{@topic.id} - #{@topic.title}"

    instructions = <<~INSTR
      You are a history teacher creating quiz questions.

      The topic is: "#{@topic.title}".
      Generate ONE multiple-choice question for a student.

      Ensure the question is unique each time.

      Return ONLY valid JSON in this exact format:
      {
        "question": "string",
        "answers": [
          { "text": "string", "correct": true },
          { "text": "string", "correct": false },
          { "text": "string", "correct": false }
        ]
      }
      Do not include any explanation or extra text.
      Include a random number between 1-1000 in the JSON comment field to force variation: #{rand(1..1000)}
    INSTR

    begin
      ai_response = RubyLLM.chat(model: "claude-haiku-4-5-20251001")
                      .with_instructions(instructions)
                      .ask("Generate a quiz question")

      puts "=== CLAUDE RAW RESPONSE ==="
      puts ai_response.content.inspect
      puts "==========================="

      json_text = ai_response.content.match(/\{.*\}/m)&.to_s
      quiz = JSON.parse(json_text || '{}', symbolize_names: true)

    rescue JSON::ParserError, StandardError => e
      puts "ERROR in generate_quiz: #{e.class} - #{e.message}"
      quiz = {
        question: "Could not generate a question. Please try again.",
        answers: [
          { text: "Error", correct: false },
          { text: "Error", correct: false },
          { text: "Error", correct: false }
        ]
      }
    end

    render json: quiz
  end

  private

  def set_topic
    @topic = Topic.find(params[:id])
  end
end
