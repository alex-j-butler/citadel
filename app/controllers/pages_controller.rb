class PagesController < ApplicationController
  def home
    read_news_config
  end

  private

  def read_news_config
    config = Rails.configuration.news

    if config['type'] == 'topic'
      read_news_topic_config config
    elsif config['type'] == 'none'
    else
      throw 'Invalid news type: config/news.yml'
    end
  end

  def read_news_topic_config(config)
    limit = config['display'] || 3

    @topic = Rails.cache.fetch('home_topic', expires_in: 1.minute) { Forums::Topic.find(config['id']) }
    @threads = Rails.cache.fetch('home_threads', expires_in: 10.minute) { @topic.threads.ordered.limit(limit) }
    @news_posts = Rails.cache.fetch('home_news_posts', expires_in: 10.minute) { @threads.map { |thread| [thread, thread.original_post] }.to_h }
    @more_threads = Rails.cache.fetch('home_more_threads', expires_in: 10.minute) { @topic.threads.limit(limit + 1).size > limit }
  end
end
