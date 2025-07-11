output "bucket_url" {
  value = "https://console.cloud.google.com/storage/browser/${google_storage_bucket.example.name}"
}
