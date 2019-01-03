FROM ruby:2.3

RUN apt-get update -qq && apt-get install -qq -y build-essential nodejs

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

WORKDIR /app

# Install JQ so we can easily work with AWS IP list
RUN wget -q https://github.com/stedolan/jq/releases/download/jq-1.5/jq-1.5.tar.gz \
  && tar -xzf jq-1.5.tar.gz \
  && cd jq-1.5  \
  && autoreconf -i \
  && ./configure -q --disable-maintainer-mode \
  && make -s \
  && make -s install

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install -j 8
COPY . /app

CMD ["nanoc",  "-v"]
