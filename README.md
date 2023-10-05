# Workforce-Identity-Federation

This is module is used to create workforce identity pool and corrresponding providers . It will help your employees to access GCP services outside from Google cloud without leverage your external identity provider.

## Demo Reference Architecture
![Reference Architecture](diagram/Workforce.PNG)

The resources/services/activations/deletions that this module will create/trigger are:
- Create a Google Cloud Project with unique suffix
- Create a Workforce Identity Pool with unique suffix at Organization level
- Create a SAML & OIDC Workload Identity Providers under Workforce pool
- Update IAM Policy of new Google project using Group from Identity Provider

## Usage

### 
1. Clone repo
```
git clone https://github.com/jasonbisson/terraform-google-workforce-identity-federation.git

```

2. Rename and update required variables in terraform.tvfars.template
```
mv terraform.tfvars.template terraform.tfvars
#Update required variables
```

3. Execute Terraform commands with existing identity (human or service account) to build Workforce Identity Infrastructure.
```
cd ~/terraform-google-workforce-identity-federation/
terraform init
terraform plan
terraform apply
```

4. Copy name of Workforce Identity Pool ID from Terraform output or gcloud command
```
gcloud iam workforce-pools list --location=global --organization=Your Organization ID --format="value(name)"
``` 

5. Create Okta Application to support SAML authetication

* Login to https://<Your okta instance.okta.com>/ as Application Administrator
* Go to “Admin” console
* Go to Directory and create a group Google-<Pick a unique name> and assign your Okta idenity to group
* Create a new App Integration with SAML 2.0, “Google Cloud Console SSO <Pick a unique name>”
* Upload an Application Icon (Pick a fun icon)
* In “Configure SAML” enter below URLs
```
  Single sign-on URL: https://auth.cloud.google/signin-callback/locations/global/workforcePools/<Your Pool Name>/providers/<Your Provider Name>
  Audience URI (SP Entity ID): https://iam.googleapis.com/locations/global/workforcePools/<Your Pool Name>/providers/<Your Provider Name>
  Default RelayState: https://console.cloud.google/
  Name ID format: Unspecified
  Application username: Okta username
  Update application username on: Create and update
  Add Attribute Statements
  email  user.email
  department   user.department
  Add Group Attribute Statement
  groups Starts with Google-<Unique group created above>
```
* Are you a customer or partner Select “I'm an Okta customer adding an internal app”
* Save the application 
* Open the new application and click on Assignments tab
* Assign group Google-<Unique group created above> and save


6. Download Okta SAML Metadata xml file
* Go to new application 
* Click on “View SAML Setup Instructions” on right side
* Click on Sign On 
* Go to Provide the following IDP metadata to your SP provider and copy all content
* Save file as metadata.xml

7. Replace idp_metadata_xml Terraform variable
* Convert metadata.xml file into a single string and forward slashes '\' before each qoute '"'. 
* The placeholder idp_metadata_xml variable is shows exactly what the format needs to be.
* Update the variable idp_metadata_xml in terraform.tfvars
* Redeploy to update the variable
* Optional: A script under build/print_metadata_xml.py can be used to print the string

```
terraform plan
terraform apply
```

8. Click away
* Click on your new Okta Application
* Click on the continue signing into Google Cloud
* If you nailed it the Google Cloud Console will appear and the identity will have full view access to the new project

## Sample 

```hcl
module "workforce-identity-federation" {
  source            = "jasonbisson/workforce-identity-federation/google"
  version = "~> 0.1"
}

```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.45, < 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_member_roles"></a> [member\_roles](#module\_member\_roles) | terraform-google-modules/iam/google//modules/member_iam | n/a |

## Resources

| Name | Type |
|------|------|
| [google-beta_google_iam_workforce_pool.pool](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_iam_workforce_pool) | resource |
| [google-beta_google_iam_workforce_pool_provider.provider](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_iam_workforce_pool_provider) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the Pool | `string` | `null` | no |
| <a name="input_disabled"></a> [disabled](#input\_disabled) | Enable the Pool | `bool` | `false` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the Pool | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Location of the Pool | `string` | n/a | yes |
| <a name="input_parent"></a> [parent](#input\_parent) | Parent id | `string` | n/a | yes |
| <a name="input_project_bindings"></a> [project\_bindings](#input\_project\_bindings) | Project bindings | <pre>list(object(<br>  {<br>    project_id = string<br>    roles = list(string)<br>    attribute = string<br>    all_identities = bool<br>   }<br>))</pre> | n/a | yes |
| <a name="input_session_duration"></a> [session\_duration](#input\_session\_duration) | Session Duration | `string` | `"3600s"` | no |
| <a name="input_wif_providers"></a> [wif\_providers](#input\_wif\_providers) | Provider config | `list(any)` | n/a | yes |
| <a name="input_workforce_pool_id"></a> [workforce\_pool\_id](#input\_workforce\_pool\_id) | Workforce Pool ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_pool_id"></a> [pool\_id](#output\_pool\_id) | Pool id |
| <a name="output_pool_name"></a> [pool\_name](#output\_pool\_name) | Pool name |
| <a name="output_pool_state"></a> [pool\_state](#output\_pool\_state) | Pool state |
| <a name="output_provider_id"></a> [provider\_id](#output\_provider\_id) | Provider id |


## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.13 or above
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v3.61 or above

### Infrastructure deployment Account

A account with the following roles must be used to provision
the resources of this module:

- Workforce Identity Pool Admin: `roles/iam.workforcePoolAdmin`
- Project Creator 
- Project Deleter
- Billing User

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- Secure Token Service: `sts.googleapis.com`
- IAM Credentials: `iamcredentials.googleapis.com`
- Cloud Resource Manager: `cloudresourcemanager.googleapis.com`
- IAM: `iam.googleapis.com`

The [Project Factory module][project-factory-module] can be used to
provision a project with the necessary APIs enabled.


### Troubleshooting
So much trouble coming. Stay tuned.