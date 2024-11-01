FROM ruby:3.2.2-slim

# Set locale
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US:en

RUN apt-get update && apt-get install -qq -y --no-install-recommends \
    build-essential \
    wget \
    libpq-dev \
    git \
    tzdata \
    libxml2-dev \
    libxslt-dev \
    shared-mime-info \
    libvips \
    curl \
    gnupg \
    cron \
    imagemagick \
    librsvg2-bin \
    ssh && rm -rf /var/lib/apt/lists/*

RUN wget https://dl.yarnpkg.com/debian/pubkey.gpg
RUN curl https://deb.nodesource.com/setup_18.x | bash
RUN cat pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y nodejs yarn

ENV APP_NAME /region_posts
RUN mkdir /$APP_NAME
WORKDIR /$APP_NAME

COPY Gemfile* package.json yarn.lock $APP_NAME/

ENV BUNDLE_PATH=/bundle \
    BUNDLE_JOBS=3 \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN gem update --system && gem install bundler:2.4.11
RUN yarn install
RUN bundle install

COPY . /$APP_NAME
