require 'markdown_text'

module MarkdownTextCaching
  extend ActiveSupport::Concern

  class_methods do
    def caches_markdown_text_for(attribute, options = {})
      text_cached_attributes[attribute] = transform_text_cache_options(attribute, options)

      before_validation do
        if send(attribute)
          reset_text_cache(attribute) if changed_attributes[attribute.to_s] || new_record?
        end
      end
    end

    def text_cached_attributes
      @text_cached_attributes ||= {}
    end

    private

    def transform_text_cache_options(attribute, options)
      options[:cache_attribute] ||= "#{attribute}_text_cache"
      options[:escaped] = options[:escaped] != false
      options
    end
  end

  def reset_text_caches(attributes = nil)
    (attributes || self.class.text_cached_attributes.keys).each do |attribute|
      reset_text_cache(attribute)
    end
  end

  def reset_text_cache(attribute)
    options = self.class.text_cached_attributes[attribute]

    source = send(attribute)
    render = MarkdownTextRenderer.render(source, options[:escaped])

    cache_attribute = options[:cache_attribute]
    send("#{cache_attribute}=", render)
  end
end
