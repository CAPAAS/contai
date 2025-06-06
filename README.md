# Contai

AI content generation for Rails models. Integrate external AI APIs seamlessly into your Rails applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'contai'
```

And then execute:

    $ bundle install

## Usage

### Basic Setup

Include `Contai::Generatable` in your model and configure it:

```ruby
class Article < ApplicationRecord
  include Contai::Generatable
  
  contai do
    prompt_from :title, :description
    output_to :body
    provider :openai, api_key: ENV["OPENAI_API_KEY"]
    template "Write a blog post about: {{title}} - {{description}}"
  end
end
```

### Generate Content

```ruby
article = Article.new(title: "Ruby on Rails", description: "Web framework")
article.generate_ai_content!
# Content will be generated and saved to article.body

# Async generation
article.generate_ai_content!(async: true)
```
### Supported Providers

#### OpenAI
```ruby
provider :openai, 
  api_key: ENV["OPENAI_API_KEY"],
  model: "gpt-4",
  max_tokens: 1000
```

#### Claude
```ruby
provider :claude,
  api_key: ENV["CLAUDE_API_KEY"],
  model: "claude-3-sonnet-20240229"
```

#### N8N Webhook
```ruby
provider :n8n,
  webhook_url: "https://your-n8n-instance.com/webhook/your-webhook-id",
  headers: { "Authorization" => "Bearer #{ENV['N8N_API_KEY']}" },
  response_path: "output"
```

#### Custom HTTP
```ruby
provider :http,
  url: "https://api.example.com/generate",
  method: :post,
  headers: { "Authorization" => "Bearer #{ENV['API_KEY']}" },
  body_template: { prompt: "{{prompt}}", model_name: "custom-model" },
  response_path: "result.text"
```

### Configuration

Configure global defaults:

```ruby
# config/initializers/contai.rb
Contai.configure do |config|
  config.default_provider = :openai
  config.default_template = "Generate content based on: {{prompt}}"
  config.timeout = 30
  
  # Configure default headers for all HTTP-based providers
  config.default_headers = {
    "Content-Type" => "application/json",
    "Authorization" => "Bearer #{ENV['DEFAULT_API_KEY']}"
  }
end
```

### HTTP Headers Configuration

You can configure HTTP headers in three ways:

1. Global default headers in the initializer (applies to all HTTP-based providers):
```ruby
Contai.configure do |config|
  config.default_headers = {
    "Content-Type" => "application/json",
    "Authorization" => "Bearer #{ENV['DEFAULT_API_KEY']}"
  }
end
```

2. Provider-specific headers in your model:
```ruby
contai do
  provider :http,
    url: "https://api.example.com/generate",
    headers: { "Authorization" => "Bearer #{ENV['SPECIFIC_API_KEY']}" }
end
```

3. Combining both - provider headers will be merged with default headers:
```ruby
# In config/initializers/contai.rb
Contai.configure do |config|
  config.default_headers = {
    "Content-Type" => "application/json",
    "X-API-Version" => "v1"
  }
end

# In your model
contai do
  provider :n8n,
    webhook_url: "https://your-n8n-instance.com/webhook/id",
    headers: { "Authorization" => "Bearer #{ENV['N8N_API_KEY']}" }
    # Final headers will be:
    # {
    #   "Content-Type" => "application/json",
    #   "X-API-Version" => "v1",
    #   "Authorization" => "Bearer ..."
    # }
end
```

### Routes

Add to your routes file:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  post '/contai/generate', to: 'contai/generations#create', as: 'contai_generation'
end
```
## Error Handling

The gem provides comprehensive error handling:

```ruby
article = Article.new(title: "Test")
result = article.generate_ai_content!

unless result
  puts article.errors.full_messages
  # => ["AI generation failed: API error"]
end
```

## Testing

Test your models with Contai:

```ruby
# spec/models/article_spec.rb
RSpec.describe Article do
  describe '#generate_ai_content!' do
    let(:article) { create(:article, title: "Test", description: "Test desc") }
    
    before do
      allow_any_instance_of(Contai::Providers::OpenAI).to receive(:generate)
        .and_return(double(success?: true, content: "Generated content"))
    end
    
    it 'generates content' do
      expect { article.generate_ai_content! }.to change { article.body }
        .from(nil).to("Generated content")
    end
  end
end
```

## Development

After checking out the repo, run:

```bash
bundle install
rake spec
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [CAPAA License](https://capaal.com).