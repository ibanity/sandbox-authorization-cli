FROM ruby:2.5

WORKDIR /usr/src/app

COPY Gemfile* ./
RUN bundle install

COPY . /usr/src/app

ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
