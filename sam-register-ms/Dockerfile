FROM ruby:2.3

RUN mkdir /sam_register_ms
WORKDIR /sam_register_ms

ADD Gemfile /sam_register_ms/Gemfile
ADD Gemfile.lock /sam_register_ms/Gemfile.lock

RUN bundle install
ADD . /sam_register_ms
