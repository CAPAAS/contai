Contai.configure do |config|
    # Default provider for all models (can be overridden per model)
    config.default_provider = :http
    
    # Default template for prompt generation
    config.default_template = "Generate content based on: {{prompt}}"
    
    # Request timeout in seconds
    config.timeout = 30
  end
  
  # Configure your AI providers here:
  
  # OpenAI Configuration
  # Contai::Providers::OpenAI.configure do |config|
  #   config.api_key = ENV['OPENAI_API_KEY']
  #   config.default_model = 'gpt-3.5-turbo'
  #   config.default_max_tokens = 1000
  # end
  
  # Claude Configuration  
  # Contai::Providers::Claude.configure do |config|
  #   config.api_key = ENV['CLAUDE_API_KEY']
  #   config.default_model = 'claude-3-sonnet-20240229'
  # end
  
  # Custom HTTP API Configuration
  # Contai::Providers::HTTP.configure do |config|
  #   config.default_url = ENV['AI_API_URL']
  #   config.default_headers = {
  #     'Authorization' => "Bearer #{ENV['AI_API_KEY']}",
  #     'Content-Type' => 'application/json'
  #   }
  # end