#!/bin/bash
set -e

rm -f /ecommerce-app/tmp/pids/server.pid

exec "$@"