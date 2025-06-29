#!/bin/bash

php artisan migrate --force || true

php artisan serve --host 0.0.0.0 --port 10000 &

# Wait for the log file to be created (max 10 seconds)
for i in {1..10}; do
  if [ -f storage/logs/laravel.log ]; then
    break
  fi
  echo "Waiting for storage/logs/laravel.log..."
  sleep 1
done

# Start tailing if it now exists
if [ -f storage/logs/laravel.log ]; then
  tail -f storage/logs/laravel.log
else
  echo "Laravel log file not found after timeout. Skipping tail."
  tail -f /dev/null  # keep container alive
fi
