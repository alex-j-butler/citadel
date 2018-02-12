module ExternalNameCache
  extend ActiveSupport::Concern

  class_methods do
    def caches_external_attribute(id_attribute, retrieval_method, options = {})
      options[:attribute_name] ||= 'name'

      external_attributes[id_attribute] = {method: retrieval_method, options: options}

      before_validation do
        if send(id_attribute)
          retrieve_external_attribute retrieval_method, options if attribute_changed? id_attribute || new_record?
        end
      end
    end

    def external_attributes
      @external_attributes ||= {}
    end
  end

  def retrieve_external_attribute(retrieval_method, options)
    attribute_value = send(retrieval_method)
    send("#{options[:attribute_name]}=", attribute_value)
  end

  def reset_external_attribute(id_attribute)
    puts self.class.external_attributes[id_attribute]
    if self.class.external_attributes[id_attribute]
      attribute = self.class.external_attributes[id_attribute]
      retrieve_external_attribute attribute[:method], attribute[:options]
    end
  end
end
