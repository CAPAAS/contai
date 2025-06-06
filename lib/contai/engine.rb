module Contai
    class Engine < ::Rails::Engine
      isolate_namespace Contai
  
      initializer "contai.assets" do |app|
        app.config.assets.precompile += %w[contai.js contai.css]
      end
    end
  end