provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "admon_node" {
  ami = "${var.instance_ami}"
  instance_type = "${var.md_node["type"]}"

  root_block_device {
    volume_type = "standard"
    volume_size = "30"
  }

  tags = "${merge(
    map("Name", "${var.cluster_name}_admon"),
    var.tags
  )}"
}

# Create metadata servers- 
resource "aws_instance" "md_node" {
  count = "${var.md_node["nnodes"]}"
  ami = "${var.instance_ami}"
  instance_type = "${var.md_node["type"]}"

  root_block_device {
    volume_type = "standard"
    volume_size = "30"
  }

  tags = "${merge(
    map("Name", "${var.cluster_name}_md${count.index}"),
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

# Attach metadata volumes
resource "aws_volume_attachment" "md_volume_attachment" {
  count = "${var.md_node["nnodes"]}"
  device_name = "${var.ebs_device_names[0]}"
  volume_id = "${aws_ebs_volume.metadata_volumes.*.id[count.index]}"
  instance_id = "${aws_instance.md_node.*.id[count.index]}"
}


# Create data store volumes
resource "aws_ebs_volume" "data_volumes" {
  count = "${var.storage_node["nvols"] * var.storage_node["nnodes"]}"

  availability_zone = "${var.az}"
  size = "${var.data_volume["size"]}"
  type = "${var.data_volume["type"]}"

  tags = "${merge(
    map("Name", "${var.cluster_name}_stor${count.index}"),
    var.tags
  )}"
}

# Create storage servers- 
resource "aws_instance" "storage_node" {
  count = "${var.storage_node["nnodes"]}"
  ami = "${var.instance_ami}"
  instance_type = "${var.storage_node["type"]}"
  root_block_device {
    volume_type = "standard"
    volume_size = "30"
  }


  tags = "${merge(
    map("Name", "${var.cluster_name}_stor${count.index}"),
    var.tags
  )}"
}

# Attach storage volumes
resource "aws_volume_attachment" "storage_volume_attachment" {
  count = "${var.storage_node["nvols"] * var.storage_node["nnodes"]}"
  device_name = "${element(var.ebs_device_names, count.index % var.storage_node["nvols"])}"
  volume_id = "${aws_ebs_volume.data_volumes.*.id[count.index]}"
  instance_id = "${aws_instance.storage_node.*.id[floor(count.index/var.storage_node["nvols"])]}"
}
