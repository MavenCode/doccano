terraform {
  required_version = ">= 0.12.0"
  backend "gcs" {
    bucket      = "doccano-platform-dev_tf"
    prefix      = "/dev/terraform/core-cloudsql/state"
    credentials = "../doccano-ai.key.json"
  }
}

provider google {
  credentials = var.credentials
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  version     = "~> 2.12.0"
}

provider "null" {
  version = "~> 2.1"
}

resource random_id random {
  byte_length = 2
}

module cloud_sql {
  source                     = "./cloudsql"
  region                     = var.region
  availability_type          = var.availability_type
  sql_instance_size          = var.sql_instance_size
  sql_disk_type              = var.sql_disk_type
  sql_disk_size              = var.sql_disk_size
  sql_require_ssl            = var.sql_require_ssl
  sql_master_zone            = var.sql_master_zone
  sql_connect_retry_interval = var.sql_connect_retry_interval
  sql_replica_zone           = var.sql_replica_zone
  sql_user                   = var.sql_user
  sql_pass                   = var.sql_pass
  project_name               = "${var.project_id}-${random_id.random.hex}"
}
