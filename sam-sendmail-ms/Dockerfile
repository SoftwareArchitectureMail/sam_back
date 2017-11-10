FROM ruby:2.3

RUN mkdir /sam_sendmail_ms
WORKDIR /sam_sendmail_ms

ADD Gemfile /sam_sendmail_ms/Gemfile
ADD Gemfile.lock /sam_sendmail_ms/Gemfile.lock

RUN bundle install
ADD . /sam_sendmail_ms