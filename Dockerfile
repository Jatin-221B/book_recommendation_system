# syntax=docker/dockerfile:1
# check=error=true
 
ARG RUBY_VERSION=4.0.1
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base
 
WORKDIR /rails
 
# Install base packages - replaced sqlite3 with libpq for PostgreSQL
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips libpq5 && \
    ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives
 
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so"
 
FROM base AS build
 
# Install packages needed to build gems + nodejs for assets
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libyaml-dev pkg-config libpq-dev nodejs && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives
 
COPY vendor/* ./vendor/
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile -j 1 --gemfile
 
COPY . .
 
RUN bundle exec bootsnap precompile -j 1 app/ lib/
 
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile
 
FROM base
 
# Install libpq for PostgreSQL runtime
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y libpq5 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives
 
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash
USER 1000:1000
 
COPY --chown=rails:rails --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --chown=rails:rails --from=build /rails /rails
 
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
 
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]
 