# Use the official Ruby image based on Debian Bullseye
FROM ruby:3.3.4-slim-bullseye

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for Ruby and Bundler
ENV RUBY_MAJOR=3.3
ENV RUBYGEMS_VERSION=3.4.17
ENV BUNDLER_VERSION=2.5.0

# Set up gem environment
ENV BUNDLE_PATH=/usr/local/bundle

# Create the gem directory
RUN mkdir -p "$GEM_HOME" && chmod 777 "$GEM_HOME"

# Update Rubygems to the specified version and install Bundler
RUN gem update --system "$RUBYGEMS_VERSION" \
    && gem install bundler -v "$BUNDLER_VERSION"

# Install Jekyll
RUN gem install jekyll

# Expose port 4000 for Jekyll
EXPOSE 4000

# Set the working directory
WORKDIR /site

# Set the entrypoint for Jekyll and default command
ENTRYPOINT ["jekyll"]
CMD ["--help"]
