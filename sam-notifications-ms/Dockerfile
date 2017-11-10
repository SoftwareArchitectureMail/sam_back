FROM ruby:2.3

RUN mkdir /sam_notifications_ms
WORKDIR /sam_notifications_ms

ADD Gemfile /sam_notifications_ms/Gemfile
ADD Gemfile.lock /sam_notifications_ms/Gemfile.lock

RUN bundle install
ADD . /sam_notifications_ms
