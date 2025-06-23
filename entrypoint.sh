#!/bin/bash
set -e

echo "Database Configuration:"
echo "Host: $DB_HOST"
echo "Username: $DB_USERNAME"
echo "Database: $DB_NAME"

export PGPASSWORD=$DB_PASSWORD

# More detailed connection check
until pg_isready -h "$DB_HOST" -U "$DB_USERNAME"; do
  echo "Postgres is unavailable - sleeping"
  sleep 5
done

echo "Postgres is up - checking database"

if psql -h "$DB_HOST" -U "$DB_USERNAME" -lqt | cut -d \| -f 1 | grep -qw "$DB_NAME"; then
    echo "Database exists"
else
    echo "Creating database"
    createdb -h "$DB_HOST" -U "$DB_USERNAME" "$DB_NAME"
fi

echo "Running migrations"
bundle exec rails db:migrate

echo "Database setup complete"
rm -f /myapp/tmp/pids/server.pid

exec "$@"
