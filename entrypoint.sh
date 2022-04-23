#!/usr/bin/env sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

rails db:create
rails db:migrate
rails server -b 0.0.0.0