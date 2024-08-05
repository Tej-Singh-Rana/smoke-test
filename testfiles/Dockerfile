# Use the official Ruby image based on Debian Bullseye
FROM ruby:3.3.4-bullseye

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for Ruby and Bundler
ENV RUBY_MAJOR=3.3
ENV RUBY_VERSION=3.3.4
ENV RUBYGEMS_VERSION=3.4.17
ENV BUNDLER_VERSION=2.5.0

# Set up gem environment
ENV GEM_HOME=/usr/local/bundle
ENV BUNDLE_PATH=/usr/local/bundle
ENV BUNDLE_SILENCE_ROOT_WARNING=1
ENV BUNDLE_APP_CONFIG=/usr/local/bundle
ENV PATH=/usr/local/bundle/bin:/usr/local/bundle/gems/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Create the gem directory
RUN mkdir -p "$GEM_HOME"

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
