#!/bin/bash

if [ "$1" = 'run' ]; then
    echo "[RUN]: server"
    rm -f /app/tmp/pids/server.pid
    cd ${APP_HOME}
    bundle exec rake db:migrate
    bundle exec rails s
elif [ "$1" = 'sidekiq' ]; then
    echo "[RUN]: sidekiq"
    cd ${APP_HOME}
    bundle exec sidekiq
elif [ "$1" = 'rake' ]; then
    echo "[RUN]: rake $2"
    cd ${APP_HOME}
    bundle exec rake $2
else
    echo "[RUN]: $@"
    exec "$@"
fi
