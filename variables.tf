variable "region" {
  description = "AWS Region for this cluster"
}

variable "az" {
  description = "The availability zone for this cluster"
}

variable "cluster_name" {
  description = "The name for this cluster"
  default = "beegfs"
}

variable "instance_ami" {
  description = "AMI to use for nodes in the cluster"
}

variable "tags" {
  description = "Generic tags to apply to this cluster's components"
  type = "map"
  default = {}
}

variable "key_name" {
  description = "Key pair name to use for connections"
}

variable "key_path" {
  description = "Path to the private key used for connecting"
}

variable "data_volume" {
  description = "Information about the data volumes for beegfs"
  type = "map"
  default = {
    size = "40"
    type = "standard"
  }
}

variable "storage_node" {
  description = "Information about the storage node(s)"
  # Storage nodes will have names like "<cluster_name>-stor<count>"
  type = "map"
  default = {
    nnodes = "1"               # Number of storage nodes
    nvols = "1"                # data volumes per node
    type = "m5.large"
  }
}

variable "md_data" {
  description = "EBS volume storing metadata"
  # There's one per md_node defined below
  type = "map"
  default = {
    type = "io1"
    size = "20"
    iops = "1000"
  }
}

variable "md_node" {
  description = "Information about the metadata node"
  # The management service will run on the first metadata node
  # node names will be like "<cluster_name>-md<count>
  type = "map"
  default = {
    nnodes = "1"
    type = "m5.large"
  }
}

variable "ebs_device_names" {
  description = "A list of EBS volume names"
  type = "list"
  default = [
    "/dev/sde",
    "/dev/sdf",
    "/dev/sdg",
    "/dev/sdh",
    "/dev/sdi",
    "/dev/sdj",
    "/dev/sdk",
    "/dev/sdl",
    "/dev/sdm",
    "/dev/sdn",
    "/dev/sdo",
    "/dev/sdp",
    "/dev/sdq",
    "/dev/sdr",
    "/dev/sds",
    "/dev/sdt",
    "/dev/sdu",
    "/dev/sdv",
    "/dev/sdw",
    "/dev/sdx",
    "/dev/sdy",
    "/dev/sdz"
  ]
}
