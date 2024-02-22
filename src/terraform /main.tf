# This code is compatible with Terraform 4.25.0 and versions that are backwards compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

resource "google_compute_instance" "sandbox0" {
  boot_disk {
    auto_delete = true
    device_name = "sandbox0"

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-10-buster-v20240213"
      size  = 100
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = "e2-medium"

  metadata = {
    ssh-keys = "el.cloud.science.lab:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCqdbvAw3APqIdJOo0XO547PUGigMbnPjPOp9m+RL7J2h1KtHl+PEYWyscXicIhxIOOGKte1jj7wUzy9u+NTKd3BDhuY3oaR1/CMA8KaE0pNDbinUSvz4UMG17OZRpeVX7TslT0bMnzBl02xMAOGcbgYpFxFl2p9ki29pKkiI3vmfni6o6I85cjPfkswIExRYOWjdW0wJzWlY0tqdrd25dC6jvxVOePr75G9MS63sj6H7qAb/1pH6cxGOveeiR2kBE4Rl1jOifuvDUd8idZdpVUS2UMs4RIinoN2S0QFcgC/48ZCpbYuP1Bb/O5jIwV4DHYSEiVX4lPB3c4pRqx11AIO68BwsIKGTpHLqrw5Z6f4jl8q+b6rEy+XWafOj/N+HCjtSzdhgacRll62Doyk7JFxNFpUzs7sks7O8HRclz60dVR2nHlgA3UAaol2dxzvTpvjkfRlHmcsZjLEteRaICHMEgqRBLlve32Bwa5ayhawnmGRYgqaQGobqERDOljjU= el.cloud.science.lab@gmail.com"
  }

  name = "sandbox0"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/multi-tenant-414510/regions/us-west4/subnetworks/default"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "267242228702-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = false
    enable_secure_boot          = false
    enable_vtpm                 = false
  }

  tags = ["http-server", "https-server"]
  zone = "us-west4-b"
}
