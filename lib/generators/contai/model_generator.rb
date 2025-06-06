module Contai
    module Generators
      class ModelGenerator < Rails::Generators::NamedBase
        source_root File.expand_path('templates', __dir__)
  
        desc "Add Contai configuration to an existing model"
  
        class_option :prompt_fields, type: :array, default: ['title'], 
                     desc: "Fields to use for prompt generation"
        class_option :output_field, type: :string, default: 'body',
                     desc: "Field to store generated content"
        class_option :provider, type: :string, default: 'openai',
                     desc: "AI provider to use"
        class_option :template, type: :string,
                     desc: "Custom template for prompt generation"
  
        def add_contai_to_model
          model_file = "app/models/#{file_name}.rb"
          
          unless File.exist?(model_file)
            say "Model #{class_name} not found at #{model_file}", :red
            return
          end
  
          inject_into_class model_file, class_name do
            contai_configuration
          end
  
          say "Added Contai configuration to #{class_name}", :green
        end
  
        private
  
        def contai_configuration
          prompt_fields = options[:prompt_fields].map(&:to_sym)
          output_field = options[:output_field].to_sym
          provider = options[:provider].to_sym
          template = options[:template]
  
          config = []
          config << "  include Contai::Generatable"
          config << ""
          config << "  contai do"
          config << "    prompt_from #{prompt_fields.map(&:inspect).join(', ')}"
          config << "    output_to :#{output_field}"
          config << "    provider :#{provider}"
          config << "    template \"#{template}\"" if template
          config << "  end"
          config << ""
  
          config.join("\n")
        end
      end
    end
  end