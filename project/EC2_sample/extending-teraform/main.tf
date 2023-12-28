resource "random_password" "password" {
    keepers = {
      datetime = timestamp()
    }
    length = 16
    special = true
}

output "password" {
    value = random_password.password.result
    sensitive = false
}