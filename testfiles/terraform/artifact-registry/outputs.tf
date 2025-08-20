output "repository_name" {
  value = google_artifact_registry_repository.repo.name
}

output "repository_format" {
  value = google_artifact_registry_repository.repo.format
}

output "repository_location" {
  value = google_artifact_registry_repository.repo.location
}
