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

# var.pet from variables.tf file
resource "local_file" "pet2" {
  filename = var.pet[0] # filename will be cat
  content  = "Pets2!"
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
output "welcome_message" {
  value       = local_file.welcome.content
  description = "The content value of the local_file welcome resource"
}
