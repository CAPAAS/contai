module Contai
    class GenerationsController < ApplicationController
      def create
        model_class = params[:model].constantize
        record = model_class.find(params[:id])
        
        if record.generate_ai_content!
          render json: { 
            success: true, 
            content: record.send(record.class.contai_config[:output_field])
          }
        else
          render json: { 
            success: false, 
            errors: record.errors.full_messages 
          }, status: 422
        end
      rescue => e
        render json: { 
          success: false, 
          error: e.message 
        }, status: 500
      end
    end
  end