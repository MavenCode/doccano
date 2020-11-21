echo "Database connection"
export DB_USER="admin"
export DB_PASSWORD="admin"
export DB_NAME DB_NAME="doccano-db"
export PSQL_CLOUD_INSTANCE="mlops-kubeflow-00:us-central2:sql-mlops-kubeflow-00-4a32-master"

export GOOGLE_APPLICATION_CREDENTIALS="./doccano-ai.key.json"
chmod +x cloud_sql_proxy_mac
mkdir ./cloudsql_dir
./cloud_sql_proxy_mac -dir=./cloudsql_dir --instances=$PSQL_CLOUD_INSTANCE=tcp:5432 --credential_file=$GOOGLE_APPLICATION_CREDENTIALS &
