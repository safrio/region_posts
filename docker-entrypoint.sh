#!/bin/bash
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

cd /region_posts
bundle install
bin/rails db:drop db:create db:migrate 
# db:seed

exec bundle exec "$@"
