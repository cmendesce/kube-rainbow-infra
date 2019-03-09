output "node_addresses" {
  value = ["${aws_instance.k8s-node.*.public_dns}"]
}

output "master_address" {
  value = "${aws_instance.k8s-master.public_dns}"
}

output "sock_shop_address" {
  value = "${aws_elb.k8s-elb.dns_name}"
}