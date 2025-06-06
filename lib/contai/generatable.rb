module Contai
    module Generatable
      extend ActiveSupport::Concern
  
      included do
        class_attribute :contai_config, default: {}
      end
  
      class_methods do
        def contai(&block)
          config = ContaiConfig.new
          config.instance_eval(&block) if block_given?
          self.contai_config = config.to_h
        end
      end
  
      def generate_ai_content!(async: false)
        if async
          ContaiGenerationJob.perform_later(self)
        else
          perform_generation
        end
      end
  
      private
  
      def perform_generation
        config = self.class.contai_config
        return false if config.empty?
  
        prompt = build_prompt(config)
        provider = Providers.build(config[:provider], config[:provider_options])
        
        result = provider.generate(prompt)
        
        if result.success?
          update!(config[:output_field] => result.content)
          true
        else
          errors.add(:base, "AI generation failed: #{result.error}")
          false
        end
      rescue => e
        errors.add(:base, "AI generation error: #{e.message}")
        false
      end
  
      def build_prompt(config)
        template = config[:template] || Contai.configuration.default_template
        data = {}
        
        config[:prompt_fields].each do |field|
          data[field] = send(field)
        end
        
        # Simple template substitution
        template.gsub(/\{\{(\w+)\}\}/) do |match|
          field = $1.to_sym
          data[field] || match
        end
      end
    end
  
    class ContaiConfig
      attr_accessor :prompt_fields, :output_field, :provider_type, :provider_options, :template
  
      def initialize
        @prompt_fields = [:prompt]
        @output_field = :body
        @provider_type = :http
        @provider_options = {}
        @template = nil
      end
  
      def prompt_from(*fields)
        @prompt_fields = fields
      end
  
      def output_to(field)
        @output_field = field
      end
  
      def provider(type, options = {})
        @provider_type = type
        @provider_options = options
      end
  
      def template(tmpl)
        @template = tmpl
      end
  
      def to_h
        {
          prompt_fields: @prompt_fields,
          output_field: @output_field,
          provider: @provider_type,
          provider_options: @provider_options,
          template: @template
        }
      end
    end
  end 