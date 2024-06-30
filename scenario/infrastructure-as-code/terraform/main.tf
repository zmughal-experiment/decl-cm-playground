resource "null_resource" "install_apache2" {
  provisioner "local-exec" {
    command = "apt-get update && apt-get install -y --no-install-recommends apache2 && apache2ctl -v"
  }
}
