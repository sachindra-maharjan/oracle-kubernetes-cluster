provider "kubernetes" {
  config_path = "~/.kube/k8s-config"
}

provider "oci" {
  region = var.region
}

resource "kubernetes_namespace" "webapp_namespace" {
  metadata {
    name = "webapp-ns"
  }
}

data "oci_containerengine_node_pool" "k8s_np" {
  node_pool_id = var.node_pool_id
}

locals {
  active_nodes = [for node in data.oci_containerengine_node_pool.k8s_np.nodes : node if node.state == "ACTIVE"]
}

resource "oci_network_load_balancer_network_load_balancer" "nlb" {
  compartment_id = var.compartment_id
  display_name   = "k8s-nlb"
  subnet_id      = var.public_subnet_id

  is_private                     = false
  is_preserve_source_destination = false
}

resource "oci_network_load_balancer_backend_set" "nlb_backend_set" {
  health_checker {
    protocol = "TCP"
    port     = 10256
  }
  name                     = "k8s-backend-set"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  policy                   = "FIVE_TUPLE"

  is_preserve_source = false
}

resource "oci_network_load_balancer_backend" "nlb_backend" {
  count                    = length(local.active_nodes)
  backend_set_name         = oci_network_load_balancer_backend_set.nlb_backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  port                     = 31600
  target_id                = local.active_nodes[count.index].id
}

resource "oci_network_load_balancer_listener" "nlb_listener" {
  default_backend_set_name = oci_network_load_balancer_backend_set.nlb_backend_set.name
  name                     = "k8s-nlb-listener"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  port                     = "80"
  protocol                 = "TCP"
}
