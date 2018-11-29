provider "aws" {
  region = "${var.region}"
}

# Create volumes for datastore

resource "aws_ebs_volume" "data_volumes" {
  count = "${var.data_volume["nvols"]}"

  availability_zone = "${var.az}"
  size = "${var.data_volume["size"]}"
  type = "${var.data_volume["type"]}"

  tags = "${merge(
    map("Name", "${var.cluster_name}_stor${count.index}"),
    var.tags
  )}"

}

# Create metadata volumes
resource "aws_ebs_volume" "metadata_volumes" {
  count = "${var.md_node["nnodes"]}"

  availability_zone = "${var.az}"
  size = "${var.md_data["size"]}"
  type = "${var.md_data["type"]}"
  iops = "${var.md_data["iops"]}"

  tags = "${merge(
    map("Name", "${var.cluster_name}_md${count.index}"),
    var.tags
  )}"
}

# Create storage servers- 
