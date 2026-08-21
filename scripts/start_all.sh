#!/bin/bash
# start_all.sh - Boot up the entire Unified Auth Gateway polyglot environment locally

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR="$DIR/.."

echo "Starting Auth Server on port 8000..."
cd "$BASE_DIR/auth_server"
source venv/bin/activate
python manage.py runserver 8000 &
AUTH_PID=$!

echo "Starting Django API (Billing) on port 8001..."
cd "$BASE_DIR/django_api"
source venv/bin/activate
python manage.py runserver 8001 &
DJANGO_PID=$!

echo "Starting Spring Boot API (Orders) on port 8080..."
cd "$BASE_DIR/springboot_api"
./mvnw spring-boot:run &
SPRING_PID=$!

echo ""
echo "=========================================================="
echo "All services started!"
echo "Auth Server: http://localhost:8000"
echo "Django API: http://localhost:8001/billing/info/"
echo "Spring Boot API: http://localhost:8080/orders/info"
echo "Press Ctrl+C to terminate all services."
echo "=========================================================="

# Trap ctrl-c and kill all children
trap "echo 'Shutting down services...'; kill $AUTH_PID $DJANGO_PID $SPRING_PID; exit" SIGINT

wait
