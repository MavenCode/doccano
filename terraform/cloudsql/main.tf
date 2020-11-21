resource google_sql_database_instance master {
  name             = "sql-${var.project_name}-master"
  region           = var.region
  database_version = "POSTGRES_13"

  settings {
    availability_type = var.availability_type
    tier              = var.sql_instance_size
    disk_type         = var.sql_disk_type
    disk_size         = var.sql_disk_size
    disk_autoresize   = true

    ip_configuration {
      require_ssl  = var.sql_require_ssl
      ipv4_enabled = true
    }

    location_preference {
      zone = "${var.region}-${var.sql_master_zone}"
    }

    backup_configuration {
      enabled    = true
      start_time = "00:00"
    }
  }
}

resource google_sql_database_instance replica {
  depends_on = [
    google_sql_database_instance.master,
  ]

  name                 = "sql-${var.project_name}-replica"
  count                = "1"
  region               = var.region
  database_version     = "POSTGRES_13"
  master_instance_name = google_sql_database_instance.master.name

  settings {
    tier            = var.sql_instance_size
    disk_type       = var.sql_disk_type
    disk_size       = var.sql_disk_size
    disk_autoresize = true

    location_preference {
      zone = "${var.region}-${var.sql_replica_zone}"
    }
  }
}

resource google_sql_user user {
  depends_on = [
    google_sql_database_instance.master,
    google_sql_database_instance.replica,
  ]

  instance = google_sql_database_instance.master.name
  name     = var.sql_user
  password = var.sql_pass
}

resource google_sql_database users {
  depends_on = [
    google_sql_user.user,
  ]
  name     = "${var.project_name}-db"
  instance = google_sql_database_instance.master.name
}