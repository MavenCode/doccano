#!/usr/bin/env bash

set -o errexit

#echo "Database connection"
#export DB_USER="admin"
#export DB_PASSWORD="admin"
#export DB_NAME DB_NAME="doccano-db"
#export PSQL_CLOUD_INSTANCE="mlops-kubeflow-00:us-central2:sql-mlops-kubeflow-00-4a32-master"
#
#export GOOGLE_APPLICATION_CREDENTIALS="./doccano-ai.key.json"
#chmod +x /doccano/cloud_sql_proxy
#mkdir /doccano/cloudsql_dir
#./cloud_sql_proxy -dir=/doccano/cloud_sql_proxy --instances=$PSQL_CLOUD_INSTANCE=tcp:5432 --credential_file=$GOOGLE_APPLICATION_CREDENTIALS &

#export ADMIN_USERNAME="mavencode"
#export ADMIN_PASSWORD="ap"
#export ADMIN_EMAIL="doccano@mavencode.com"

echo "Making staticfiles"
if [[ ! -d "app/staticfiles" ]]; then python app/manage.py collectstatic --noinput; fi

echo "Initializing database"
python app/manage.py wait_for_db
#python app/manage.py migrate
python app/manage.py create_roles

echo "Creating admin"
if [[ -n "${ADMIN_USERNAME}" ]] && [[ -n "${ADMIN_PASSWORD}" ]] && [[ -n "${ADMIN_EMAIL}" ]]; then
  python app/manage.py create_admin \
    --username "${ADMIN_USERNAME}" \
    --password "${ADMIN_PASSWORD}" \
    --email "${ADMIN_EMAIL}" \
    --noinput \
  || true
fi

echo "Starting django"
gunicorn --bind="0.0.0.0:${PORT:-8000}" --workers="${WORKERS:-1}" --pythonpath=app app.wsgi --timeout 300
