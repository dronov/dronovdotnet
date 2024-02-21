FROM ruby:3.3.0

RUN mkdir -p /blog/dronovdotnet
ADD . /blog/dronovdotnet

WORKDIR /blog/dronovdotnet

RUN gem install bundler:2.5.4
RUN apt update -y
RUN apt install -y nodejs

EXPOSE 8080

CMD bundle exec middleman server --port 8080
