output "pet_name" {
    value = random_pet.this.id
    description = "Random pet name used when naming s3 buckets."
}