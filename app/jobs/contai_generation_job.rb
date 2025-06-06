class ContaiGenerationJob < ApplicationJob
    queue_as :default
  
    def perform(record)
      record.send(:perform_generation)
    end
  end