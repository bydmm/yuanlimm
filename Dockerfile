FROM ruby:2.4.1

ENV APP_HOME="/app"
ENV RAILS_ENV="production"
ENV HARD="14"
ENV WEB_WISH_LIMIT="100"
ENV WEB_WISH_RAITO="5"

COPY ./sources.list /etc/apt/sources.list

RUN apt-get update

RUN apt-get install -y --force-yes -V --fix-missing\
    git curl htop \
    zlib1g-dev build-essential \
    libssl-dev libcurl4-openssl-dev \
    libyaml-dev libmysqlclient-dev \
    nodejs nodejs-legacy npm nginx\
    redis-tools \
    && npm install -g yarn \
    && npm install n -g \
    && n stable \
    && apt-get clean

RUN mkdir $APP_HOME

COPY ./Gemfile* $APP_HOME/

RUN cd $APP_HOME/ \
    && bundle install

COPY . $APP_HOME

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["run"]
