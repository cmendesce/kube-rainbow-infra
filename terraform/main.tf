provider "aws" {
  region = "${var.aws_region}"
}
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${var.aws_region}a"
}

resource "aws_security_group" "k8s-security-group" {
  name        = "md-k8s-security-group"
  vpc_id     = "${aws_vpc.default.id}"
  description = "allow all internal traffic, ssh, http from anywhere"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9411
    to_port     = 9411
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 30001
    to_port     = 30001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 30002
    to_port     = 30002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
   from_port   = 31601
   to_port     = 31601
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "k8s-master" {
  instance_type   = "${var.master_instance_type}"
  ami             = "${lookup(var.aws_amis, var.aws_region)}"
  key_name        = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.k8s-security-group.id}"]
  subnet_id = "${aws_subnet.default.id}"
  tags {
    Name = "k8s-master"
  }

  connection {
    user = "ubuntu"
    private_key = "${file("${var.private_key_path}")}"
  }

  provisioner "file" {
    source = "../manifests"
    destination = "/tmp/"
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
  #     "sudo echo \"deb http://apt.kubernetes.io/ kubernetes-xenial main\" | sudo tee --append /etc/apt/sources.list.d/kubernetes.list",
  #     "sudo apt-get update",
  #     "sudo apt-get install -y docker.io",
  #     "sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni"
  #   ]
  # }
}

resource "aws_instance" "k8s-node" {
  instance_type   = "${var.node_instance_type}"
  count           = "${var.node_count}"
  ami             = "${lookup(var.aws_amis, var.aws_region)}"
  key_name        = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.k8s-security-group.id}"]
  subnet_id = "${aws_subnet.default.id}"
  tags {
    Name = "k8s-node"
  }

  connection {
    user = "ubuntu"
    private_key = "${file("${var.private_key_path}")}"
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
  #     "sudo echo \"deb http://apt.kubernetes.io/ kubernetes-xenial main\" | sudo tee --append /etc/apt/sources.list.d/kubernetes.list",
  #     "sudo apt-get update",
  #     "sudo apt-get install -y docker.io",
  #     "sudo usermod -aG docker $USER",
  #     "sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni",
  #     "sudo sysctl -w vm.max_map_count=262144"
  #   ]
  # }
}

resource "aws_elb" "k8s-elb" {
  depends_on = [ "aws_instance.k8s-node" ]
  name = "k8s-elb"
  instances = ["${aws_instance.k8s-node.*.id}"]
  
  security_groups = ["${aws_security_group.k8s-security-group.id}"] 
  subnets = ["${aws_subnet.default.id}"]
  listener {
    lb_port = 80
    instance_port = 30001
    lb_protocol = "http"
    instance_protocol = "http"
  }

  listener {
    lb_port = 9411
    instance_port = 30002
    lb_protocol = "http"
    instance_protocol = "http"
  }

}
