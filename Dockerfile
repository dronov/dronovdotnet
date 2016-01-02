FROM ruby:2.2.2

RUN mkdir -p /blog/dronovdotnet
ADD . /blog/dronovdotnet

WORKDIR /blog/dronovdotnet

RUN gem install bundler
RUN bundle install --jobs 3

EXPOSE 8080

CMD bundle exec middleman server --port 8080
