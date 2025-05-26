#!/bin/bash
set -e

SERVICE=$1

# Microservice validation
VALID_SERVICES=("hotels-service" "users-service" "bookings-service")
if [ -n "$SERVICE" ] && [[ ! " ${VALID_SERVICES[@]} " =~ " ${SERVICE} " ]]; then
  echo "❌ Unknown service: $SERVICE"
  echo "Valid services: ${VALID_SERVICES[*]}"
  exit 1
fi

# Start microservice or project
if [ -z "$SERVICE" ]; then
  echo "🟢 Starting full development environment..."
  docker-compose up --build -d
else
  ENV_FILE="./$SERVICE/.env"
  if [ -f "$ENV_FILE" ]; then
    echo "📦 Loading environment from $ENV_FILE"
    set -o allexport
    source "$ENV_FILE"
    set +o allexport
  else
    echo "⚠️ Warning: .env file not found for $SERVICE at $ENV_FILE"
  fi

  echo "🟡 Starting microservice $SERVICE..."
  docker-compose up --build -d "$SERVICE"
fi
