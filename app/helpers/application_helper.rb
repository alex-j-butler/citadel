module ApplicationHelper
  include ApplicationPermissions

  def navbar_class(name)
    if navbar_active?(name)
      'active'
    else
      ''
    end
  end

  def navbar_active?(name)
    case name
    when :admin
      controller.is_a? AdminController
    else
      controller_path.start_with?(name.to_s) || (controller_name == 'pages' && action_name == name.to_s)
    end
  end

  def format_options
    Format.all.collect { |format| [format.name, format.id] }
  end

  def divisions_select
    @league.divisions.all.collect { |div| [div.name, div.id] }
  end

  def bootstrap_paginate(target)
    will_paginate target, renderer: BootstrapPagination::Rails
  end

  def present(object, klass = nil)
    klass ||= BasePresenter.presenter object

    klass.new(object, self)
  end

  def present_collection(collection, klass = nil)
    collection.map { |object| present(object, klass) }
  end

  # painful workaround to `true_user` not being available in rspec tests
  def true_user
    @impersonated_user || current_user
  end

  def truncate_words(text, length = 30, end_string = '...')
    words = text.split
    words[0..(length - 1)].join(' ') + (words.length > length ? end_string : '')
  end

  def asset_exists?(path)
    if Rails.configuration.assets.compile
      Rails.application.precompiled_assets.include? path
    else
      Rails.application.assets_manifest.assets[path].present?
    end
  end
end
