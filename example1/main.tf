# This resource has an explicit dependency on the random_pet.cat resource
# So (for whatever reason) we need random_pet.cat to be created before local_file.pet
resource "local_file" "pet" {
  filename        = "/root/pet.txt"
  content         = "Pets!"
  file_permission = "0700"

  depends_on = [
    random_pet.cat
  ]
}

resource "random_pet" "cat" {
  prefix    = "Mr"
  separator = "."
  length    = 1
}

# The array var.pet is defined in variables.tf file
resource "local_file" "pet2" {
  filename = var.pet[0] # filename will be cat
  content  = "Pets2!"

  lifecycle {
    # Reject any changes that would result into the resource getting destroyed (you could still just terraform destroy)
    # prevent_destroy = true

    # When updating this resource (actually due to the nature of immutable infrastructure, TF will delete the resource and replace it with a new one)
    # create the new resource first before destroying the old resource.
    create_before_destroy = true
  }
}

# Loops based on `count` and creates multiple files with names from the name bird-filename variable list.
# The resource local_file.bird will now be created as a list
resource "local_file" "bird" {
  filename = var.bird-filename[count.index]
  content = "test"
  count = length(var.bird-filename)
}

# The for_each meta argument acts similarly to loop. However it needs a variable set (a list without repeating elements) , not a list.
# We could also use `for_each = toset(var.reptile-filename)` if reptile-filename was a list instead of set
# The resource local_file.bird will now be created as a map. <---------
# This is recommended because it maps the resource to the filename as key, and not an index, and it will only delete the appropriate resource if the set changes.
resource "local_file" "reptile" {
  filename = each.value
  content = "test"
  for_each = var.reptile-filename
}

# Example Access Resource Attributes
resource "time_static" "time_update" {
}
# This resource has an implicit dependency on the time_static.time_update resource
# This is done because of the reference expression we use in content
resource "local_file" "time" {
  filename = "/root/time.txt"
  content  = "Time stamp of this file is ${time_static.time_update.id}"
}

# This will create a openssh key pair and encodes it in pem format.
# This is a logical resource that lines only in terraform state (see it with tf show)
resource "tls_private_key" "pvtkey" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
# This will create a file containe the private pem key of the above logical resource
resource "local_file" "key_details" {
  filename = "/root/key.txt"
  content  = tls_private_key.pvtkey.private_key_pem
}

# Example for output variables.
# Once you hit terraform apply the output of all output variables will appear at the end
resource "local_file" "welcome" {
  filename = "/root/message.txt"
  content  = "Welcome to Kodekloud."
}

# Will output (print) the value of the welcome file resource
output "welcome_message" {
  value       = local_file.welcome.content
  description = "The content value of the local_file welcome resource"
}

# Will output (print) the output of /etc/os-release
output "os-version" {
  value = data.local_file.os.content
}

# We treat /etc/os-release file as a data source, so despite not being provisioned by terraform we will read its contents
data "local_file" "os" {
  filename = "/etc/os-release"
}
