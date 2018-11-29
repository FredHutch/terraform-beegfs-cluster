output "data_volumes" {
  value = "${aws_ebs_volume.data_volumes.*.id}"
}
