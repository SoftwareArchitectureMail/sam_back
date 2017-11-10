FROM ruby:2.3

RUN mkdir /sam_api_gateway
WORKDIR /sam_api_gateway

ADD Gemfile /sam_api_gateway/Gemfile
ADD Gemfile.lock /sam_api_gateway/Gemfile.lock

RUN bundle install
ADD . /sam_api_gateway
