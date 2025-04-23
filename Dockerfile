# Dockerfile
FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /myapp

# Install correct Bundler version first
RUN gem install bundler -v 2.3.6

COPY ./Budget-App/Gemfile ./Budget-App/Gemfile.lock ./
RUN bundle install

COPY ./Budget-App .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

