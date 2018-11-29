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

variable "tags" {
  description = "Generic tags to apply to this cluster's components"
  type = "map"
  default = {}
}

variable "data_volume" {
  description = "Information about the data volumes for beegfs"
  type = "map"
  default = {
    nvols = "1"
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
    source_ami = "ami-a0cfeed8"
  }
}

variable "md_data" {
  description = "EBS volume storing metadata"
  # There's one per md_node defined below
  type = "io1"
  size = "20"
  iops = "1000"
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

