module Contai
    module Providers
      class N8N < HTTP
        def initialize(options = {})
          webhook_url = options[:webhook_url] || raise(ArgumentError, "N8N provider requires :webhook_url")
          
          super({
            url: webhook_url,
            method: :post,
            body_template: { prompt: "{{prompt}}" },
            response_path: options[:response_path] || "output"
          }.merge(options))
        end
      end
    end
  end