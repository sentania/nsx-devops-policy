# Configure the VMware NSX-T Provider
provider "nsxt" {
    host = var.nsxIP
    username = var.nsxUser
    password = var.nsxPassword
    allow_unverified_ssl = true
}


resource "nsxt_policy_group" "MySQLClient" {
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

resource "nsxt_policy_group" "MySQLServer" {
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

resource "nsxt_policy_group" "WebServer" {
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

resource "nsxt_policy_security_policy" "PrivateCloudPolicies" {
  description  = "Private Cloud Blueprint Policies Section provisioned by Terraform"
  display_name = "Private Cloud Blueprint Policies"
  category = "Application"
  rule {
    display_name = "Allow Web Traffic"
    description  = ""
    action       = "ALLOW"
    ip_version  = "IPV4"
    services = [nsxt_policy_service.HTTP.path,nsxt_policy_service.HTTPS.path]
    destination_groups = [nsxt_policy_group.WebServer.path]
    scope = [nsxt_policy_group.WebServer.path]
  }
}