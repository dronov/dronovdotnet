activate :blog do |blog|
  blog.permalink = '{year}/{month}/{day}/{title}.html'
  blog.taglink = 'tags/{tag}.html'
  blog.summary_separator = /(READMORE)/
  blog.tag_template = 'tag.html'
  blog.calendar_template = 'calendar.html'
end

activate :google_analytics do |ga|
  ga.tracking_id = 'UA-76956340-1'
  ga.anonymize_ip = false
  ga.domain_name = 'dronov.net'
  ga.allow_linker = false
  ga.enhanced_link_attribution = false
  ga.debug = false
  ga.development = true
  ga.minify = false
end

page '/feed.xml', layout: false

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

configure :build do
end
