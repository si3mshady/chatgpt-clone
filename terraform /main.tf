# Execute Terraform Script
provider "google" {
  credentials = file("serviceaccount.json")
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.5"
    }
  }
}


# Define the VPC
resource "google_compute_network" "my_vpc" {
  name = "sandbox"
  project = "multi-tenant-414510"
}

# Define Subnet within the VPC
resource "google_compute_subnetwork" "my_subnet" {
  name          = "mypublicsubnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.my_vpc.self_link
  project = "multi-tenant-414510"
  region           = "us-west1"

}

# Deploy PostgreSQL Database
resource "google_sql_database_instance" "postgres_public_ip_instance_name" {
  database_version = "POSTGRES_15"
  name             = "postgres-public-ip"
  region           = "us-west1"
  project = "multi-tenant-414510"

  settings {
    availability_type = "ZONAL"
    ip_configuration {
      # Add optional authorized networks
      # Update to match the customer's networks
      
      authorized_networks {
        name  = "mypublic_ip"
        value = "0.0.0.0/0"
      }
      # Enable public IP
      ipv4_enabled = true
    }
    tier = "db-custom-2-7680"
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}

# Configure Connectivity
resource "google_sql_user" "my_db_user" {
  instance     = google_sql_database_instance.postgres_public_ip_instance_name.name
  name         = "postgres"
  password     = "letsgetiton"
  project = "multi-tenant-414510"
  

}

output "cloud_sql_connection_name" {
  value = google_sql_database_instance.postgres_public_ip_instance_name.connection_name
}


output "cloud_sql_ip_address" {
  value = google_sql_database_instance.postgres_public_ip_instance_name.ip_address.0.ip_address
}



#enableCloudSQLAdminAPI

# terraform init
# terraform apply