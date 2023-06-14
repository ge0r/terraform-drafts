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

variable "toni" {
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

variable "bird-filename" {
  type=list(string) # type is not explicitly required
  default = [
    "/root/parrot.txt",
    "/root/sparrow.txt",
    "/root/eagle.txt",
    "/root/duck.txt"
  ]
}

variable "reptile-filename" {
  type=set(string) # type is not explicitly required
  default = [
    "/root/lizzard.txt",
    "/root/snake.txt",
    "/root/turtle.txt",
  ]
}
