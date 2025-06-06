require "httparty"

module Contai
  module Providers
    class Claude < Base
      include HTTParty
      
      base_uri "https://api.anthropic.com/v1"

      def generate(prompt)
        response = self.class.post("/messages",
          headers: {
            "x-api-key" => @options[:api_key],
            "Content-Type" => "application/json",
            "anthropic-version" => "2023-06-01"
          },
          body: {
            model: @options[:model] || "claude-3-sonnet-20240229",
            max_tokens: @options[:max_tokens] || 1000,
            messages: [
              { role: "user", content: prompt }
            ]
          }.to_json,
          timeout: @options[:timeout] || Contai.configuration.timeout
        )

        if response.success?
          content = response.parsed_response.dig("content", 0, "text")
          success_result(content)
        else
          error_result("Claude API error: #{response.code} #{response.message}")
        end
      rescue => e
        error_result(e.message)
      end
    end
  end
end