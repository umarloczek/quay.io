// todo dony copy all files (refactor file structure?) < nginx will be in different network, may not be connected
// todo digitalocean has networking issues after creating resource, check if resolved
// todo VIRTUAL_HOST should be passed here only (so replacemt of wordpress url should happen here also and be backwards compatible (if we take prod data to dev)
// todo configure firewall for ports 80 and 443 only
resource "digitalocean_droplet" "mywebserver" {
  # Obtain your ssh_key id number via your account. See Document https://developers.digitalocean.com/documentation/v2/#list-all-keys
  ssh_keys           = ["4e:ad:9d:dc:3b:7d:42:df:5a:e8:12:5c:b6:ca:0f:4c"]         # Key example
  image              = "docker-18-04"
  region             = "ams3"
  size               = "s-1vcpu-1gb"
  private_networking = true
  backups            = false
  ipv6               = false
  name               = "mywebserver-ams3"

  connection {
    host = digitalocean_droplet.mywebserver.ipv4_address
    type     = "ssh"
    private_key = file("~/.ssh/id_rsa")
    user     = "root"
    timeout  = "2m"
  }

  provisioner "remote-exec" {
    inline = [
//        "sudo apt-get update",
//        "sudo apt-get -y upgrade",
        "sudo apt install -y make",
        "sudo mkdir /apps",
    ]
  }
  provisioner "file" {
    source     = "./"
    destination = "/apps"
  }
  provisioner "remote-exec" {
    // #todo sleep before deployments to fix digitalocean networking issues?
    inline = [
      "cd /apps",
      "docker-compose -f docker-compose.proxy.yaml up -d",
      "docker-compose -f docker-compose.deploy.yaml up -d",
    ]
  }
}

// todo pass domain as env
// todo this domain must be added
// todo generate domain name automatically per "release"
resource "digitalocean_record" "mywebserver" {
  domain = "gowno.space"
  type   = "A"
  name   = "test"
  value  = digitalocean_droplet.mywebserver.ipv4_address
}

output "Public_ip" {
  value = digitalocean_droplet.mywebserver.ipv4_address
}

output "Name" {
  value = digitalocean_droplet.mywebserver.name
}
