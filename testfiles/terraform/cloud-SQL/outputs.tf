output "instance_connection_names" {
  description = "Cloud SQL connection names for each instance"
  value = {
    for name, instance in google_sql_database_instance.postgres_instances :
    name => instance.connection_name
  }
}

output "public_ip_addresses" {
  description = "Public IP addresses of the Cloud SQL instances"
  value = {
    for name, instance in google_sql_database_instance.postgres_instances :
    name => instance.public_ip_address
  }
}
