#!/bin/sh

bundle exec rake db:create db:migrate

if [ "$RAILS_ENV" = "production" ]; then
  bundle exec rake assets:precompile
fi

bundle exec puma -C config/puma.rb -b 0.0.0.0
