activate :blog do |blog|
  blog.permalink = '{year}/{month}/{day}/{title}.html'
  blog.taglink = 'tags/{tag}.html'
  blog.summary_separator = /(READMORE)/
  blog.tag_template = 'tag.html'
  blog.calendar_template = 'calendar.html'
end

page '/feed.xml', layout: false

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

configure :build do
end
