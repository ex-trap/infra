resource "google_compute_project_metadata" "ssh_keys" {
  metadata = {
    ssh-keys = <<EOF
      kaz:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPKlZKEWlSBuZcT407R2XQNNwwQ2LXEHFV54NMpMlBV8 kaz
    EOF
  }
}
