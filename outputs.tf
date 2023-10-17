/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "pool_id" {
  description = "Pool id"
  value       = google_iam_workforce_pool.pool.id
}

output "pool_state" {
  description = "Pool state"
  value       = google_iam_workforce_pool.pool.state
}

output "pool_name" {
  description = "Pool name"
  value       = google_iam_workforce_pool.pool.name
}

output "service_account" {
  description = "Name of SOAR Service Account to access Google Cloud Organization"
  value       = google_service_account.soar_to_google_cloud.email
}

output "project_id" {
  description = "Name of Google Cloud Project ID for Chronicle resources"
  value       = var.project_id
}