# Use the official Ruby image based on Debian Bullseye
FROM ruby:3.3.4-slim-bullseye AS jekyll

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for Ruby and Bundler
ENV RUBY_MAJOR=3.3
ENV RUBYGEMS_VERSION=3.4.17
ENV BUNDLER_VERSION=2.5.0

# Set up gem environment
ENV BUNDLE_PATH=/usr/local/bundle

RUN gem update --system && gem install jekyll && gem cleanup

EXPOSE 4000

WORKDIR /site

ENTRYPOINT [ "jekyll" ]

CMD [ "--help" ]

# Build from the image we just built with different metadata
FROM jekyll AS jekyll-serve

COPY docker-entrypoint.sh /usr/local/bin/

# On every container start, check if Gemfile exists and warn if it's missing
ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "bundle", "exec", "jekyll", "serve", "--force_polling", "-H", "0.0.0.0", "-P", "4000" ]