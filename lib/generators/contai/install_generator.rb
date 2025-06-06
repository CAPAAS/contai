module Contai
    module Generators
      class InstallGenerator < Rails::Generators::Base
        source_root File.expand_path('templates', __dir__)
  
        desc "Install Contai into your Rails application"
  
        def create_initializer
          template 'initializer.rb', 'config/initializers/contai.rb'
        end
  
        def add_routes
          route 'post "/contai/generate", to: "contai/generations#create", as: "contai_generation"'
        end
  
        def create_stimulus_controller
          if stimulus_detected?
            template 'contai_controller.js', 'app/javascript/controllers/contai_controller.js'
            
            say "Stimulus controller created. Make sure to register it in your application:", :green
            say "// app/javascript/controllers/application.js"
            say 'import ContaiController from "./contai_controller"'
            say 'application.register("contai", ContaiController)'
          end
        end
  
        def copy_assets
          template 'contai.js', 'app/assets/javascripts/contai.js'
          template 'contai.css', 'app/assets/stylesheets/contai.css'
        end
  
        def create_job
          template 'contai_generation_job.rb', 'app/jobs/contai_generation_job.rb'
        end
  
        def show_instructions
          say "\n" + "="*60
          say "Contai has been installed successfully!", :green
          say "="*60
          say "\nNext steps:"
          say "1. Configure your AI providers in config/initializers/contai.rb"
          say "2. Add 'include Contai::Generatable' to your models"
          say "3. Configure your models with the contai DSL"
          say "4. Use contai_button or contai_field_with_button helpers in your views"
          say "\nExample model configuration:"
          say <<~EXAMPLE
            class Article < ApplicationRecord
              include Contai::Generatable
              
              contai do
                prompt_from :title, :description
                output_to :body
                provider :openai, api_key: ENV['OPENAI_API_KEY']
                template "Write about: {{title}} - {{description}}"
              end
            end
          EXAMPLE
        end
  
        private
  
        def stimulus_detected?
          File.exist?(Rails.root.join('app/javascript/controllers/application.js'))
        end
      end
    end
  end
  