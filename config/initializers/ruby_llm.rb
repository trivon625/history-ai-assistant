RubyLLM.configure do |config|
  config.anthropic_api_key = ENV["ANTHROPIC_API_KEY"]
  config.default_model = "claude-haiku-4-5-20251001"
end
