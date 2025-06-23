# Dockerfile
FROM ruby:3.1.2

RUN apt-get update -qq && \
    apt-get install -y nodejs postgresql-client

WORKDIR /myapp

COPY ./Budget-App/Gemfile ./Budget-App/Gemfile.lock ./
RUN gem install bundler -v 2.3.6
RUN bundle install

COPY ./Budget-App .

# Create database.yml
kubectl apply -f k8s/postgres/statefulset.yaml
kubectl apply -f k8s/rails/deployment.yamlRUN rm -f config/database.yml
COPY ./k8s/rails/database.yml config/database.yml

# Add health check endpoint
RUN echo 'Rails.application.routes.draw { get "/health", to: proc { [200, {}, ["ok"]] } }' > config/routes.rb

EXPOSE 3000

# Add entrypoint script
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["rails", "server", "-b", "0.0.0.0"]

