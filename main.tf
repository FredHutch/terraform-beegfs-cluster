provider "aws" {
  region = "${var.region}"
}

# Create volumes for datastore

resource "aws_ebs_volume" "data_volumes" {
  availability_zone = "${var.az}"
  count = "${var.data_volume["nvols"]}"
  size = "${var.data_volume["size"]}"
  type = "${var.data_volume["type"]}"
  tags = "${merge(
    map("Name", "${var.cluster_name}_vol${count.index}"),
    var.tags
  )}"
}

# Create storage servers- 
