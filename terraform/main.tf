terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
    google-beta = ">= 3.8"
  }
}
provider "google-beta" {
  credentials = file(var.credentials_file)
  project = var.project
  region  =  var.region
  zone    = var.zone
}


provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region  =  var.region
  zone    = var.zone
  
}


resource "google_sql_database_instance" "master" {
name = "realw-app"
database_version = "POSTGRES_13"
region = "${var.region}"
settings {
tier = "db-custom-1-3840"
user_labels = {
      track        = "production"
      billing-code = 34802
      tier = "db-custom-1-3840"
    }

}
}

resource "google_sql_database" "database" {
name = "realwapp-db1"
instance = "${google_sql_database_instance.master.name}"
//charset = "utf8"
//collation = "utf8_general_ci"
}

resource "google_sql_user" "users" {
name = "djuser"
instance = "${google_sql_database_instance.master.name}"
host = "%"
password = "R0cVHAhG7pAN5CfspB8M"
}

resource "google_storage_bucket" "static-site" {
  name          = "realworld-media"
  location      = "${var.region}"
  force_destroy = true

  //uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  cors {
    origin          = ["http://image-store.com"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}




data "template_file" dbConnection_details{
  template = "${file("${path.module}/templates/dbConnection.tftpl")}"
   vars = {
   //consul_address = "${google_sql_database_instance.master.name}"
   DJPASS = "${google_sql_user.users.password}"
   PROJECT_ID = "${var.project}"
   REGION = "${var.region}"
   GS_BUCKET_NAME = "${google_storage_bucket.static-site.name}"
   DJ_ADMIN_PASSWORD = ""
  }
  
}

resource "local_file" "dbInfo" {
  content = data.template_file.dbConnection_details.rendered
  filename = "${path.module}/.env"

  
}


resource "google_project_service" "secretmanager" {
  provider = google-beta
  service  = "secretmanager.googleapis.com"
}


resource "google_secret_manager_secret" "app-secret" {
  provider = google-beta

  secret_id = "application_settings"
  labels = {
    label = "django-application_settings"
  }
  replication {
    automatic = true
  }

  depends_on = [google_project_service.secretmanager]
}




resource "google_secret_manager_secret_version" "app-secret-1" {
  provider = google-beta
  secret      = google_secret_manager_secret.app-secret.id
  secret_data = data.template_file.dbConnection_details.rendered

    provisioner "local-exec" {
    command = " rm   ${path.module}/.env"
    //when    = destroy
  }
}

resource "google_secret_manager_secret" "dj-admin-password" {
  provider = google-beta

  secret_id = "dj_admin_password"
  labels = {
    label = "django_admin_password"
  }
  replication {
    automatic = true
  }

  depends_on = [google_project_service.secretmanager]
}


resource "google_secret_manager_secret_version" "dj-admin-password-1" {
  provider = google-beta
  secret      = google_secret_manager_secret.dj-admin-password.id
  secret_data = var.dj_admin_password

}

