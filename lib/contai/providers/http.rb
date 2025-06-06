require "httparty"

module Contai
  module Providers
    class HTTP < Base
      include HTTParty

      def generate(prompt)
        url = @options[:url] || raise(ArgumentError, "HTTP provider requires :url option")
        method = (@options[:method] || :post).to_s.downcase
        
        request_options = {
          headers: @options[:headers] || { "Content-Type" => "application/json" },
          timeout: @options[:timeout] || Contai.configuration.timeout
        }

        body_data = @options[:body_template] || { prompt: prompt }
        if body_data.is_a?(Hash)
          body_data = body_data.transform_values { |v| v.is_a?(String) ? v.gsub("{{prompt}}", prompt) : v }
          request_options[:body] = body_data.to_json
        end

        response = case method
                  when "get"
                    self.class.get(url, request_options)
                  when "post"
                    self.class.post(url, request_options)
                  when "put"
                    self.class.put(url, request_options)
                  else
                    raise ArgumentError, "Unsupported HTTP method: #{method}"
                  end

        if response.success?
          content = extract_content(response, @options[:response_path])
          success_result(content)
        else
          error_result("HTTP API error: #{response.code} #{response.message}")
        end
      rescue => e
        error_result(e.message)
      end

      private

      def extract_content(response, path)
        return response.parsed_response.to_s unless path

        content = response.parsed_response
        path.split(".").each do |key|
          content = content[key] if content.respond_to?(:[])
        end
        content.to_s
      end
    end
  end
end