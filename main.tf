# Configure the VMware NSX-T Provider
provider "nsxt" {
    host = var.nsxIP
    username = var.nsxUser
    password = var.nsxPassword
    allow_unverified_ssl = true
}


resource "nsxt_policy_group" "MySQLClients" {
  display_name = "MySQLClient"
  description  = "MySQLClient Group provisioned by Terraform"
  criteria {
      condition {
          key         = "Tag"
          member_type = "SegmentPort"
          operator    = "EQUALS"
          value       = "Role|MySQLClient"
      }
  }
}

resource "nsxt_policy_group" "MySQLServers" {
  display_name = "MySQLServer"
  description  = "MySQLServer Group provisioned by Terraform"
    criteria {
        condition {
            key         = "Tag"
            member_type = "SegmentPort"
            operator    = "EQUALS"
            value       = "Role|MySQLServer"
        }
    }
}

resource "nsxt_policy_group" "WebServers" {
  display_name = "WebServer"
  description  = "WebServer Group provisioned by Terraform"
  criteria {
        condition {
            key         = "Tag"
            member_type = "SegmentPort"
            operator    = "EQUALS"
            value       = "Role|WebServer"
        }
    }
}

resource "nsxt_policy_service" "WebServerServices" {
  description  = "Web Server Serivces provisioned by Terraform"
  display_name = "Web Server Services"

  l4_port_set_entry {
    display_name      = "Web Server Services"
    description       = "TCP port 80 and 443"
    protocol          = "TCP"
    destination_ports = [ "80", "443" ]
  }
}

resource "nsxt_policy_service" "MySQLServices" {
  description  = "MySQL Serivces provisioned by Terraform"
  display_name = "MySQL Services"

  l4_port_set_entry {
    display_name      = "MySQL Server Services"
    description       = "TCP port 3306"
    protocol          = "TCP"
    destination_ports = [ "3306" ]
  }
}

resource "nsxt_policy_security_policy" "PrivateCloudPolicies" {
  description  = "Private Cloud Blueprint Policies Section provisioned by Terraform"
  display_name = "Private Cloud Blueprint Policies"
  category = "Application"
  rule {
    display_name = "Web Traffic"
    description  = ""
    action       = "ALLOW"
    ip_version  = "IPV4"
    services = [nsxt_policy_service.WebServerServices.path]
    destination_groups = [nsxt_policy_group.WebServer.path]
    scope = [nsxt_policy_group.WebServer.path]
  }
    rule {
    display_name = "MySQL Traffic"
    description  = ""
    action       = "ALLOW"
    ip_version  = "IPV4"
    services = [nsxt_policy_service.MySQL.path]
    source_groups = [nsxt_policy_group.MySQLClints.path]
    destination_groups = [nsxt_policy_group.MySQLServers.path]
    scope = [nsxt_policy_group.MySQLClients.path,nsxt_policy_group.MySQLServers.path]
  }
}