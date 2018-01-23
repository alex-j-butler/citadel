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

  def git_revision
    if File.exists?(Rails.root.join(Rails.root, 'REVISION'))
      File.open(Rails.root.join(Rails.root, 'REVISION'), 'r') { |f| return f.gets.chomp }
    else
      `SHA1=$(git rev-parse HEAD 2> /dev/null); if [ $SHA1 ]; then echo $SHA1; else echo 'unknown'; fi`.chomp
    end
  end

  def git_revision_short
    git_revision.slice(0..6)
  end

  # painful workaround to `true_user` not being available in rspec tests
  def true_user
    @impersonated_user || current_user
  end

  def truncate_words(text, length = 30, end_string = '...')
    words = text.split
    words[0..(length - 1)].join(' ') + (words.length > length ? end_string : '')
  end
end
