# syntax = docker/dockerfile:1
ARG RUBY_VERSION=3.3.1
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim

# Set up system dependencies needed for both compilation and runtime
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libvips \
    pkg-config \
    libpq-dev \
    curl \
    libsqlite3-0 && \
    rm -rf /var/lib/apt/lists/*

# Set working directory inside the container
WORKDIR /rails

# Configure environment for development execution
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle"

# Install application dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application code
COPY . .

# Expose port and start the Rails server
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]