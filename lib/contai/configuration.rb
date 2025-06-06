module Contai
    class Configuration
      attr_accessor :default_provider, :default_template, :timeout, :default_headers
  
      def initialize
        @default_provider = :http
        @default_template = "Generate content based on: {{prompt}}"
        @timeout = 30
        @default_headers = { "Content-Type" => "application/json" }
      end
    end
  end