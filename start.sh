#!/bin/bash

php artisan migrate --force || true
php artisan serve --host 0.0.0.0 --port 10000
