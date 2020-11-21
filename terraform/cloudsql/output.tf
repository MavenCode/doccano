output "master_instance_sql_ipv4" {
  value       = google_sql_database_instance.master.ip_address[0].ip_address
  description = "The IPv4 address assigned for master"
}

output "master_instance_name" {
  value       = google_sql_database_instance.master.name
  description = "Master instance name"
}

output "db_name" {
  value       = google_sql_database.users.name
  description = "Database name"
}