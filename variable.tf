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


variable "project_id" {
  description = "Google Cloud Project where Identity pool will be deployed"
}

variable "enable_apis" {
  description = "Whether to actually enable the APIs. If false, this module is a no-op."
  default     = "true"
}

variable "disable_services_on_destroy" {
  description = "Whether project services will be disabled when the resources are destroyed. https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_on_destroy"
  default     = "false"
  type        = string
}

variable "disable_dependent_services" {
  description = "Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed. https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_dependent_services"
  default     = "false"
  type        = string
}

variable "activate_apis" {
  description = "The list of apis to activate for Cloud Function"
  default     = ["sts.googleapis.com", "iamcredentials.googleapis.com", "cloudresourcemanager.googleapis.com", "iam.googleapis.com", "cloudasset.googleapis.com", "securitycenter.googleapis.com", "pubsub.googleapis.com", "compute.googleapis.com", "recommender.googleapis.com", "policyanalyzer.googleapis.com"]
  type        = list(string)
}


variable "environment" {
  description = "Environment tag to help identify the entire deployment"
  type        = string
  default     = "workforce"
}


variable "org_id" {
  description = "The numeric organization id"
  type        = string
}

variable "workforce_pool_id" {
  type        = string
  description = "workforce"
}

variable "location" {
  type        = string
  description = "Location of the Pool"
}

variable "display_name" {
  type        = string
  default     = "Chronicle Single Sign On"
  description = "Display name of the Pool"
}

variable "description" {
  type        = string
  default     = "Chronicle Single Sign On"
  description = "Description of the Pool"
}

variable "disabled" {
  type        = bool
  default     = false
  description = "Enable the Pool"
}

variable "session_duration" {
  type        = string
  default     = "3600s"
  description = "Session Duration"
}

variable "wif_providers" {
  type        = list(any)
  description = "Provider config"
}

variable "attribute_mapping" {
  type        = map(string)
  description = "attribute list"
}


variable "prefix" {
  description = "Prefix member or group or serviceaccount"
  type        = string
  default     = "principalSet"
}

variable "role" {
  description = "IAM role for Workforce testing"
  type        = string
}

