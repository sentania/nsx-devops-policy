# Configure the VMware NSX-T Provider
provider "nsxt" {
    host = var.nsxIP
    username = var.nsxUser
    password = var.nsxPassword
    allow_unverified_ssl = true
}


resource "nsxt_policy_group" "MySQLClients" {
  display_name = "MySQLClients"
  description  = "MySQLClients Group provisioned by Terraform"
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
  display_name = "MySQLServers"
  description  = "MySQLServers Group provisioned by Terraform"
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
  display_name = "WebServers"
  description  = "WebServers Group provisioned by Terraform"
  criteria {
        condition {
            key         = "Tag"
            member_type = "SegmentPort"
            operator    = "EQUALS"
            value       = "Role|WebServer"
        }
    }
}


resource "nsxt_policy_group" "MySQLClient" {
  display_name = "MySQLClient - to be deleted"
  description  = "MySQLClient Group provisioned by Terraform"
}

resource "nsxt_policy_group" "MySQLServer" {
  display_name = "MySQLServer - to be deleted"
  description  = "MySQLServer Group provisioned by Terraform"
}

resource "nsxt_policy_group" "WebServer" {
  display_name = "WebServer - to be deleted"
  description  = "WebServer Group provisioned by Terraform"
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

