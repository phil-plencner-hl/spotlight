# frozen_string_literal: true

module Blacklight
  # Renders a field and handles link_to_facet or helper_method if supplied
  class FieldPresenter
    def initialize(controller, document, field_config, options)
      @controller = controller
      @document = document
      @field_config = field_config
      @options = options
    end

    attr_reader :controller, :document, :field_config, :options

    def render
      if options[:value]
        # This prevents helper methods from drawing.
        config = Configuration::NullField.new(field_config.to_h.except(:helper_method))
        values = Array.wrap(options[:value]) 
      else
        config = field_config
        values = retrieve_values
      end
      if (field_config[:helper_method].blank? && has_uri(values))
        field_config[:helper_method] = :create_links
      end
      Rendering::Pipeline.render(values, config, document, controller, options)
    end

    private

    def retrieve_values
      FieldRetriever.new(document, field_config).fetch
    end
    
    def has_uri(value_array)
      
      value_array.each do |value|
        begin
          uri = URI.parse(value)
          if (!uri.scheme.nil? && (%w(http https).include?(uri.scheme)))
            return true
          end
        rescue URI::BadURIError
        rescue URI::InvalidURIError
        end
      end
      false
    end
  end
end
