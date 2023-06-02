variable "pet" {
  default = ["cat", "dog", "parrot"]
  type    = list(any)
}

variable "file-content" {
  type = map(any)
  default = {
    "cat" = "I love cats"
    "dog" = "I love dogs"
  }
}

variable "Toni" {
  type = object({
    name         = string
    color        = string
    age          = number
    food         = list(string)
    favorite_pet = bool
  })

  default = {
    name         = "Toni"
    color        = "black"
    age          = "2"
    food         = ["chicken", "turkey", "meatball"]
    favorite_pet = true
  }
}
