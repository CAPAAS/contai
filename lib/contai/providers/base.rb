module Contai
    module Providers
      class Base
        def initialize(options = {})
          @options = options
        end
  
        def generate(prompt)
          raise NotImplementedError, "Subclasses must implement #generate"
        end
  
        protected
  
        def success_result(content)
          Result.new(success: true, content: content)
        end
  
        def error_result(error)
          Result.new(success: false, error: error)
        end
  
        class Result
          attr_reader :content, :error
  
          def initialize(success:, content: nil, error: nil)
            @success = success
            @content = content
            @error = error
          end
  
          def success?
            @success
          end
        end
      end
    end
  end