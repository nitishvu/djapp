    output "master_instance_name" {
  description = "The name of the master database instance"
  value       = google_sql_database_instance.master.name
}

output "master_public_ip_address" {
  description = "The public IPv4 address of the master instance."
  value       = google_sql_database_instance.master.public_ip_address
}

output "master_private_ip_address" {
  description = "The public IPv4 address of the master instance."
  value       = google_sql_database_instance.master.private_ip_address
}

output "master_ip_addresses" {
  description = "All IP addresses of the master instance JSON encoded, see https://www.terraform.io/docs/providers/google/r/sql_database_instance.html#ip_address-0-ip_address"
  value       = jsonencode(google_sql_database_instance.master.ip_address)
}

output "master_instance" {
  description = "Self link to the master instance"
  value       = google_sql_database_instance.master.self_link
}

output "master_proxy_connection" {
  description = "Master instance path for connecting with Cloud SQL Proxy. Read more at https://cloud.google.com/sql/docs/mysql/sql-proxy"
  value       = "${var.project}:${var.region}:${google_sql_database_instance.master.name}"
}

# ------------------------------------------------------------------------------
# MASTER CERT OUTPUTS
# ------------------------------------------------------------------------------

output "master_ca_cert" {
  description = "The CA Certificate used to connect to the master instance via SSL"
  value       = google_sql_database_instance.master.server_ca_cert.0.cert
}

output "master_ca_cert_common_name" {
  description = "The CN valid for the master instance CA Cert"
  value       = google_sql_database_instance.master.server_ca_cert.0.common_name
}

output "master_ca_cert_create_time" {
  description = "Creation time of the master instance CA Cert"
  value       = google_sql_database_instance.master.server_ca_cert.0.create_time
}

output "master_ca_cert_expiration_time" {
  description = "Expiration time of the master instance CA Cert"
  value       = google_sql_database_instance.master.server_ca_cert.0.expiration_time
}

output "master_ca_cert_sha1_fingerprint" {
  description = "SHA Fingerprint of the master instance CA Cert"
  value       = google_sql_database_instance.master.server_ca_cert.0.sha1_fingerprint
}

output "dbConnection_info" {
  
  value = data.template_file.dbConnection_details.rendered
}