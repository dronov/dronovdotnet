xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom", "xml:lang" => "en" do
  site_url = absolute_site_url("/")
  xml.title "Dronov.net"
  xml.subtitle "There are no drones here"
  xml.id URI.join(site_url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(site_url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(site_url, current_page.path), "rel" => "self"
  xml.updated(blog.articles.first.date.to_time.iso8601) unless blog.articles.empty?
  xml.author { xml.name "Mike Dronov" }

  blog.articles[0..5].each do |article|
    language = feed_article_language(article)

    xml.entry "xml:lang" => language do
      xml.title feed_article_title(article)
      xml.link "rel" => "alternate", "href" => URI.join(site_url, article.url)
      xml.id URI.join(site_url, article.url)
      xml.published article.date.to_time.iso8601
      xml.updated File.mtime(article.source_file).iso8601
      xml.author { xml.name "Mike Dronov" }
      xml.content feed_article_content(article), "type" => "html", "xml:lang" => language
    end
  end
end
