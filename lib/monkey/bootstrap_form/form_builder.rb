require 'bootstrap_form'

module BootstrapForm
  class FormBuilder
    def markdown_editor(method, options = {}, html_options = {})
      id = options[:id] || method

      form_group_builder(method, options, html_options) do
        prepend_and_append_input(options) do
          out = content_tag(:div, class: 'mkdown-previewer') do
            content_tag(:ul, class: 'nav nav-tabs') do
              content_tag(:li, role: 'navigation', class: 'active') do
                content_tag(:a, 'Write',
                  class: 'write-tab',
                  role: 'tab',
                  href: "##{method}_write_tab",
                  'aria-controls' => "#{method}_write_tab",
                  'data-toggle' => 'tab',
                  'data-id' => method
                )
              end +
              content_tag(:li, role: 'navigation') do
                content_tag(:a, 'Preview',
                  class: 'preview-tab',
                  role: 'tab',
                  href: "##{method}_preview_tab",
                  'aria-controls' => "#{method}_preview_tab",
                  'data-toggle' => 'tab',
                  'data-id' => method
                )
              end
            end +

            content_tag(:div, class: 'tab-content') do
              content_tag(:div, role: 'tabpanel', class: 'tab-pane active', id: "#{method}_write_tab") do
                content_tag(:div, class: 'panel panel-default') do
                  write_tab = content_tag(:div, '', class: 'mkdown-button-bar', id: "wmd-button-bar-#{id}")
                  html_options = { class: 'wmd-input form-control mkdown-textarea', id: "wmd-input-#{id}", 'data-id' => method }
                  write_tab += text_area_without_bootstrap(method, options.merge(html_options))
                  write_tab
                end
              end +

              content_tag(:div, role: 'tabpanel', class: 'tab-pane', id: "#{method}_preview_tab") do
                content_tag(:div, '', class: 'mkdown-preview', 'data-id' => method)
              end
            end
          end

          out
        end
      end
    end
  end
end
