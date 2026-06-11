require 'nokogiri'
require 'uri'

SITE_URL = 'https://www.dronov.net'.freeze

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

  def article_content_for_language(article, language)
    document = Nokogiri::HTML.fragment(article.body.to_s)
    content = document.at_css(%([data-translation-content="#{language}"]))
    return unless content

    html = content.inner_html.strip
    html unless html.empty?
  end

  def feed_article_language(article)
    return 'en' if article_content_for_language(article, 'en')
    return 'ru' if article_content_for_language(article, 'ru')

    text = Nokogiri::HTML.fragment(article.body.to_s).text
    latin_letters = text.scan(/[A-Za-z]/).size
    cyrillic_letters = text.scan(/\p{Cyrillic}/).size

    cyrillic_letters > latin_letters ? 'ru' : 'en'
  end

  def feed_article_title(article)
    article_localized_title(article, feed_article_language(article))
  end

  def feed_article_content(article)
    language = feed_article_language(article)
    html = article_content_for_language(article, language) || article.body.to_s
    document = Nokogiri::HTML.fragment(html)

    document.css('[href], [src]').each do |element|
      %w[href src].each do |attribute|
        value = element[attribute].to_s.strip
        next if value.empty? || value.start_with?('#', 'mailto:', 'tel:', 'data:')

        element[attribute] = absolute_site_url(value)
      end
    end

    document.to_html
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

  def social_title
    return current_page.data.title || 'Dronov.net' unless current_article

    article_localized_title(current_article, article_default_language)
  end

  def social_description
    description = current_page.data.description.to_s.strip
    return description unless description.empty?
    return 'Programming, Linux and infrastructure engineering.' unless current_article

    document = Nokogiri::HTML.fragment(current_article.body.to_s)
    document.css('pre, code, script, style').remove
    text = document.text.gsub(/\s+/, ' ').strip
    text.length > 200 ? "#{text[0, 197].rstrip}..." : text
  end

  def social_image
    image = current_page.data.image.to_s.strip
    if image.empty? && current_article
      image = Nokogiri::HTML.fragment(current_article.body.to_s).at_css('img')&.[]('src').to_s.strip
    end

    absolute_site_url(image) unless image.empty?
  end

  def canonical_url
    absolute_site_url(current_page.url)
  end

  def absolute_site_url(path)
    encoded_path = path.each_char.map do |character|
      if character.ascii_only?
        character
      else
        character.bytes.map { |byte| format('%%%02X', byte) }.join
      end
    end.join

    url = URI.join("#{SITE_URL}/", encoded_path).to_s
    url.sub(%r{\Ahttp://(?:www\.)?dronov\.net}, SITE_URL)
  end
end

page '/feed.xml', layout: false

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

configure :build do
end
