require "httparty"

module Contai
  module Providers
    class OpenAI < Base
      include HTTParty
      
      base_uri "https://api.openai.com/v1"

      def generate(prompt)
        response = self.class.post("/chat/completions",
          headers: {
            "Authorization" => "Bearer #{@options[:api_key]}",
            "Content-Type" => "application/json"
          },
          body: {
            model: @options[:model] || "gpt-3.5-turbo",
            messages: [
              { role: "user", content: prompt }
            ],
            max_tokens: @options[:max_tokens] || 1000
          }.to_json,
          timeout: @options[:timeout] || Contai.configuration.timeout
        )

        if response.success?
          content = response.parsed_response.dig("choices", 0, "message", "content")
          success_result(content)
        else
          error_result("OpenAI API error: #{response.code} #{response.message}")
        end
      rescue => e
        error_result(e.message)
      end
    end
  end
end