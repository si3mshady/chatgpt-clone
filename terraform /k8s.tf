# gcloud container clusters get-credentials app-factory --region=us-west1
# gcloud container clusters delete app-factory --region=us-west1


provider "google" {

    project = "multi-tenant-414510"
    region = "us-west1"
    credentials = file("creds.json")
    
  
}

resource "google_container_cluster" "primary" {
  name               = "app-factory"
  location           = "us-west1"
  initial_node_count = 1
  node_config {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = "kratos@multi-tenant-414510.iam.gserviceaccount.com"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
        Name = "appfactory"
    }
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}


# # VPC
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
  name             = "postgres-rag"
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
resource "google_sql_user" "my_second_db_user" {
  instance     = google_sql_database_instance.postgres_public_ip_instance_name.name
  name         = "postgres"
  password     = "letsgetiton"
  project = "multi-tenant-414510"
  

}

output "cloud_sql_connection_name_" {
  value = google_sql_database_instance.postgres_public_ip_instance_name.connection_name
}


output "cloud_sql_ip_address_" {
  value = google_sql_database_instance.postgres_public_ip_instance_name.ip_address.0.ip_address
}



# #enableCloudSQLAdminAPI

# # terraform init
# # terraform apply