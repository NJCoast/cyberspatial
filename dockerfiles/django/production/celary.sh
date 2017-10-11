#!/bin/bash
export BROKER_URL=amqp://$BROKER_USER:$BROKER_PASS@$BROKER_HOST:$BROKER_PORT

celery worker --app=geonode.celery_app:app -B -l INFO