module Contai
    class Configuration
      attr_accessor :default_provider, :default_template, :timeout
  
      def initialize
        @default_provider = :http
        @default_template = "Generate content based on: {{prompt}}"
        @timeout = 30
      end
    end
  end