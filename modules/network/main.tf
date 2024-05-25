resource "google_compute_network" "this" {
  name                    = var.project_name
  auto_create_subnetworks = false
}

output "network_name" {
  value = google_compute_network.this.name
}

resource "google_compute_subnetwork" "this" {
  name                     = "subnetwork"
  ip_cidr_range            = var.ip_cidr_range
  region                   = var.region
  network                  = google_compute_network.this.id
  private_ip_google_access = true
}

output "subnetwork_name" {
  value = google_compute_subnetwork.this.name
}

resource "google_compute_firewall" "default-allow-https" {
  name      = "default-allow-https"
  network   = google_compute_network.this.name
  priority  = 1000
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
}

// Permits incoming connections instances from other instances within the same VPC network.
resource "google_compute_firewall" "default-allow-internal" {
  name      = "default-allow-internal"
  network   = google_compute_network.this.name
  priority  = 1000
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }
  source_ranges = [var.ip_cidr_range]
}

// 	Lets you connect to instances with tools such as ssh, scp, or sftp.
resource "google_compute_firewall" "default-allow-ssh" {
  name      = "default-allow-ssh"
  network   = google_compute_network.this.name
  priority  = 2000
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "deny-all" {
  name      = "deny-all"
  network   = google_compute_network.this.name
  priority  = 65534
  direction = "INGRESS"

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

// NAT to allow subnet to access internet (we could remove this and add a external IP to the resources that need to access internet)
resource "google_compute_router" "router" {
  name    = "${var.project_name}-router"
  region  = var.region
  network = google_compute_network.this.id

  bgp {
    asn = 64514
  }
}

//Public NAT lets resources that don't have public IP addresses communicate with the internet.
resource "google_compute_router_nat" "nat" {
  name                               = "${var.project_name}-router-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES" // All of the IP ranges in every Subnetwork are allowed to Nat

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

// Reserve a global IPv4 address for our global load balancer
resource "google_compute_global_address" "default" {
  name = "${var.project_name}-address"
}

// SSL certificate
resource "google_compute_ssl_certificate" "consignar" {
  name_prefix = "consignar-cert"
  private_key = file(var.consignar_private_key_path)
  certificate = file(var.consignar_certificate_path)

  lifecycle {
    create_before_destroy = true
  }
}

// Network endpoint group (NEG) out of your serverless service (Web)
resource "google_compute_region_network_endpoint_group" "consignar_web_neg" {
  provider              = google-beta
  name                  = "${var.project_name}-web"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = var.cloud_run_web_service
  }
}

// Network endpoint group (NEG) out of your serverless service (REST)
resource "google_compute_region_network_endpoint_group" "consignar_rest_neg" {
  provider              = google-beta
  name                  = "${var.project_name}-rest"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = var.cloud_run_rest_service
  }

}

// Backend service that'll keep track of these network endpoints
resource "google_compute_backend_service" "consignar_web" {
  name        = "${var.project_name}-backend-web"
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 30

  backend {
    group = google_compute_region_network_endpoint_group.consignar_web_neg.id
  }
}

// Backend service that'll keep track of these network endpoints
resource "google_compute_backend_service" "consignar_rest" {
  name        = "${var.project_name}-backend-rest"
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 30

  backend {
    group = google_compute_region_network_endpoint_group.consignar_rest_neg.id
  }
}

// URL map that doesn't have any routing rules and sends the traffic to the backend service
resource "google_compute_url_map" "default" {
  name            = "${var.project_name}-urlmap"
  default_service = google_compute_backend_service.consignar_web.id

  host_rule {
    hosts        = [var.consignar_web_domain]
    path_matcher = "consignar-web-path"
  }

  host_rule {
    hosts        = [var.consignar_rest_domain]
    path_matcher = "consignar-rest-path"
  }

  path_matcher {
    name            = "consignar-web-path"
    default_service = google_compute_backend_service.consignar_web.id
  }

  path_matcher {
    name            = "consignar-rest-path"
    default_service = google_compute_backend_service.consignar_rest.id
  }
}

// HTTPS proxy to terminate the traffic with the Google-managed certificate and route it to the URL map !(max: 15 SSL certificates)
resource "google_compute_target_https_proxy" "default" {
  name = "${var.project_name}-https-proxy"

  url_map = google_compute_url_map.default.id
  ssl_certificates = [
    google_compute_ssl_certificate.consignar.id
  ]
}

// Global forwarding rule to route the HTTPS traffic on the IP address to the target HTTPS proxy
resource "google_compute_global_forwarding_rule" "default" {
  name = "${var.project_name}-lb"

  target     = google_compute_target_https_proxy.default.id
  port_range = "443"
  ip_address = google_compute_global_address.default.address
}

output "load_balancer_ip" {
  value = google_compute_global_address.default.address
}

// Handle HTTP traffic: 
resource "google_compute_url_map" "https_redirect" {
  name = "${var.project_name}-https-redirect"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource "google_compute_target_http_proxy" "https_redirect" {
  name    = "${var.project_name}-http-proxy"
  url_map = google_compute_url_map.https_redirect.id
}

resource "google_compute_global_forwarding_rule" "https_redirect" {
  name       = "${var.project_name}-lb-http"
  target     = google_compute_target_http_proxy.https_redirect.id
  port_range = "80"
  ip_address = google_compute_global_address.default.address
}
