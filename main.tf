// Created a single Terraform resource defined with count = 2 using null_resource
resource "null_resource" "example" {
  count = 2

  triggers = {
    instance = "example-${count.index}"
  }
}

output "null_resource_ids" {
  description = "IDs of the created null resources (count = 2)"
  value       = [for r in null_resource.example : r.id]
}
