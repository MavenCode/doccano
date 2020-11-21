#!/usr/bin/env bash

set -o errexit

export DB_USER="admin"
export DB_PASSWORD="admin"
export DB_NAME DB_NAME="doccano-dev"
export PSQL_CLOUD_INSTANCE="mlops-kubeflow-00:us-central2:sql-mlops-kubeflow-00-4a32-master"

export GOOGLE_APPLICATION_CREDENTIALS="/doccano/doccano-ai.key.json"
chmod +x cloud_sql_proxy
mkdir ./cloudsql_dir
./cloud_sql_proxy -dir=./cloudsql_dir --instances=$PSQL_CLOUD_INSTANCE=tcp:5432 --credential_file=$GOOGLE_APPLICATION_CREDENTIALS &

flake8
python app/manage.py migrate
coverage run --source=app app/manage.py test server.tests api.tests authentification.tests
coverage report

(cd app/server/static && npm run lint)
