resource "digitalocean_droplet" "gocd-server" {
    image = "ubuntu-16-04-x64"
    name = "gocd-server"
    count = 1
    region = "nyc3"
    size = "1gb"
    private_networking = true
    ssh_keys = [
        "${var.ssh_fingerprint}"
    ]

    connection {
        user = "root"
        type = "ssh"
        private_key = "${file("${var.pvt_key}")}"
        timeout = "60s"
    }

    provisioner "file" {
        source = "server-setup.sh"
        destination = "/root/server-setup.sh"
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /root/server-setup.sh",
            "/root/server-setup.sh"
        ]
    }
}