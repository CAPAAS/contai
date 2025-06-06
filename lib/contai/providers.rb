require "contai/providers/base"
require "contai/providers/openai"
require "contai/providers/claude"
require "contai/providers/http"
require "contai/providers/n8n"

module Contai
  module Providers
    def self.build(type, options = {})
      case type.to_sym
      when :openai
        OpenAI.new(options)
      when :claude
        Claude.new(options)
      when :n8n
        N8N.new(options)
      when :http
        HTTP.new(options)
      else
        raise ArgumentError, "Unknown provider: #{type}"
      end
    end
  end
end