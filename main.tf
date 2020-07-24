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