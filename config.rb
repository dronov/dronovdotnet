activate :blog do |blog|
  blog.permalink = '{year}/{month}/{day}/{title}.html'
  blog.taglink = 'tags/{tag}.html'
  blog.summary_separator = /(READMORE)/
  blog.tag_template = 'tag.html'
  blog.calendar_template = 'calendar.html'
end

SUPPORTED_LANGUAGES = {
  'ru' => 'RU',
  'en' => 'EN'
}.freeze

helpers do
  def article_language_options(article = current_article)
    return [] unless article

    SUPPORTED_LANGUAGES.filter_map do |language, label|
      [language, label] if article_localized_title(article, language)
    end
  end

  def article_translated?(article = current_article)
    article_language_options(article).size > 1
  end

  def article_localized_title(article, language)
    title = article.data["title_#{language}"].to_s.strip
    title.empty? ? nil : title
  end

  def article_default_language(article = current_article)
    article_language_options(article).first&.first || 'en'
  end
end

page '/feed.xml', layout: false

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

configure :build do
end
