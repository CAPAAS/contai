module ContaiHelper
    def contai_button(record, text: "Contai!", css_class: "btn btn-secondary contai-btn")
      return unless record.class.respond_to?(:contai_config) && record.class.contai_config.any?
      
      button_to text, contai_generation_path, 
                params: { model: record.class.name, id: record.id },
                method: :post,
                remote: true,
                class: css_class,
                data: { 
                  contai_target: record.class.contai_config[:output_field],
                  contai_record_id: record.id,
                  contai_model: record.class.name
                }
    end
  
    def contai_field_with_button(form, field, options = {})
      record = form.object
      return form.text_area(field, options) unless record.class.respond_to?(:contai_config)
      
      config = record.class.contai_config
      return form.text_area(field, options) unless config[:output_field] == field
      
      content_tag :div, class: "contai-field-wrapper" do
        form.text_area(field, options.merge(
          data: { contai_target: "output" }
        )) +
        content_tag(:button, "Contai!", 
                    type: "button",
                    class: "btn btn-secondary contai-generate-btn",
                    data: {
                      controller: "contai",
                      contai_model_value: record.class.name,
                      contai_record_id_value: record.id,
                      contai_output_target: field
                    })
      end
    end
  end