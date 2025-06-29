#!/bin/bash

php artisan migrate --force || true

# Start Laravel and tail the log
php artisan serve --host 0.0.0.0 --port 10000 &
tail -f storage/logs/laravel.log
