#!/bin/bash

# Ensure log folder and file exists
mkdir -p storage/logs
touch storage/logs/laravel.log

# Run migrations
php artisan migrate --force || true

# Start Laravel server in background
php artisan serve --host 0.0.0.0 --port 10000 &

# Wait for the log file to be used (not just created)
for i in {1..10}; do
  if [ -s storage/logs/laravel.log ]; then
    echo "Log file now has content."
    break
  fi
  echo "Waiting for log content in storage/logs/laravel.log..."
  sleep 1
done

# Tail the log or keep container alive
if [ -f storage/logs/laravel.log ]; then
  tail -f storage/logs/laravel.log
else
  echo "Laravel log file still missing. Keeping container alive..."
  tail -f /dev/null
fi
