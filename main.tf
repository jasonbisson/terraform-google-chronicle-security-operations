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


resource "google_project_service" "project_services" {
  project                    = var.project_id
  count                      = var.enable_apis ? length(var.activate_apis) : 0
  service                    = element(var.activate_apis, count.index)
  disable_on_destroy         = var.disable_services_on_destroy
  disable_dependent_services = var.disable_dependent_services
}


resource "random_id" "random_suffix" {
  byte_length = 4
}

resource "google_iam_workforce_pool" "pool" {
  provider          = google-beta
  workforce_pool_id = "${var.workforce_pool_id}-${random_id.random_suffix.hex}"
  parent            = "organizations/${var.org_id}"
  location          = var.location
  display_name      = var.display_name
  description       = var.description
  disabled          = var.disabled
  session_duration  = var.session_duration
}


resource "google_iam_workforce_pool_provider" "provider" {
  provider          = google-beta
  for_each          = { for i in var.wif_providers : i.provider_id => i }
  workforce_pool_id = google_iam_workforce_pool.pool.workforce_pool_id
  location          = google_iam_workforce_pool.pool.location
  provider_id       = each.value.provider_id

  attribute_mapping = var.attribute_mapping

  dynamic "saml" {
    for_each = lookup(each.value, "select_provider", null) == "saml" ? ["1"] : []
    content {
      idp_metadata_xml = each.value.provider_config.idp_metadata_xml
    }
  }

  #display_name = lookup(each.value, "display_name", null)
  display_name = var.display_name
  description  = lookup(each.value, "description", null)
  disabled     = lookup(each.value, "disabled", false)
}


resource "google_project_iam_member" "project_iam_member" {
  project = var.project_id
  role    = var.role
  member  = "${var.prefix}://iam.googleapis.com/${google_iam_workforce_pool.pool.id}/*"
}

module "enable_service_account_keys" {
  source      = "terraform-google-modules/org-policy/google"
  policy_for  = "project"
  project_id  = var.project_id
  constraint  = "iam.disableServiceAccountKeyCreation"
  policy_type = "boolean"
  enforce     = false
}

resource "google_service_account" "chronicle2soar" {
  project      = var.project_id
  account_id   = "nexus2soar"
  display_name = "Nexus to SOAR"
}

resource "google_organization_iam_custom_role" "org-custom-role" {
  org_id      = var.org_id
  role_id     = "Nexus_SOAR_Custom_Role"
  title       = "Nexus SOAR Custom Role"
  description = "Custom role for managing connections with Chronicle SOAR for Nexus"
  permissions = ["cloudasset.assets.searchAllResources","compute.instances.get","compute.instances.list","compute.instances.stop","iam.serviceAccounts.disable","policyanalyzer.serviceAccountLastAuthenticationActivities.query","pubsub.subscriptions.consume","pubsub.subscriptions.create","pubsub.subscriptions.delete","pubsub.subscriptions.get","pubsub.subscriptions.getIamPolicy","pubsub.subscriptions.list","pubsub.subscriptions.setIamPolicy","pubsub.subscriptions.update","pubsub.topics.attachSubscription","pubsub.topics.create","pubsub.topics.delete","pubsub.topics.detachSubscription","pubsub.topics.get","pubsub.topics.getIamPolicy","pubsub.topics.list","pubsub.topics.publish","pubsub.topics.setIamPolicy","pubsub.topics.update","pubsub.topics.updateTag","recommender.iamPolicyRecommendations.get","recommender.iamPolicyRecommendations.list","recommender.iamPolicyRecommendations.update","resourcemanager.organizations.getIamPolicy","securitycenter.assets.list","securitycenter.findingexternalsystems.update","securitycenter.findings.list","securitycenter.findings.setState","securitycenter.notificationconfig.create","securitycenter.notificationconfig.get","securitycenter.notificationconfig.update"]
  stage       = "GA"
}

resource "google_organization_iam_member" "custom_role_member" {
  org_id   = var.org_id
  role     = "organizations/${var.org_id}/roles/${google_organization_iam_custom_role.org-custom-role.role_id}"
  member   = "serviceAccount:${google_service_account.chronicle2soar.email}"
}