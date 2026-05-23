activate :blog do |blog|
  blog.permalink = '{year}/{month}/{day}/{title}.html'
  blog.taglink = 'tags/{tag}.html'
  blog.summary_separator = /(READMORE)/
  blog.tag_template = 'tag.html'
  blog.calendar_template = 'calendar.html'
  blog.paginate = true
end

SUPPORTED_LANGUAGES = {
  'ru' => 'RU',
  'en' => 'EN'
}.freeze

helpers do
  def language_options
    SUPPORTED_LANGUAGES.to_a
  end

  def article_language_options(article = current_article)
    return [] unless article

    SUPPORTED_LANGUAGES.filter_map do |language, label|
      [language, label] if article_localized_title(article, language)
    end
  end

  def article_translated?(article = current_article)
    article_content_language_options(article).size > 1
  end

  def article_localized_title(article, language)
    title = article.data["title_#{language}"].to_s.strip
    title.empty? ? article.title : title
  end

  def article_default_language(article = current_article)
    article_language_options(article).first&.first || 'en'
  end

  def article_content_language_options(article = current_article)
    return [] unless article

    body = article.body.to_s
    SUPPORTED_LANGUAGES.filter_map do |language, label|
      [language, label] if body.include?("data-translation-content=\"#{language}\"") || body.include?("data-translation-content='#{language}'")
    end
  end

  def page_language_options
    if current_article && article_translated?
      article_content_language_options
    else
      language_options
    end
  end

  def page_default_language
    current_article ? article_default_language : 'en'
  end

  def article_index_page?
    current_page.path == 'index.html' || current_page.path.match?(%r{\Apage/\d+/index\.html\z})
  end

  def language_switcher_visible?
    article_index_page? || (current_article && article_translated?)
  end
end

page '/feed.xml', layout: false

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

configure :build do
end
