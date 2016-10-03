FROM ruby:2.3

ENV SRC_DIR /usr/src/ebdemo/

RUN \
  apt-get update && apt-get install -y -q \
  sqlite3 \
  nodejs \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p $SRC_DIR

WORKDIR $SRC_DIR

COPY Gemfile Gemfile.lock $SRC_DIR

RUN bundle install

COPY . $SRC_DIR

CMD sh run.sh
