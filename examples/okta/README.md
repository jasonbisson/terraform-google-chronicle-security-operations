# Create Custom SAML Application for Chronicle Authetication 

To autheticate into Chronicle a custom SAML application will be required to integrate into the Workforce Identity provider. The custom SAML application can be created in any identity provider such as Workspace, Okta, or Azure. However, in this example we will use the native Workspace option, but will show required attribues and groups required.

1. Login to Okta admin console. https://<Your Okta Instance>>.okta.com/admin/dashboard

2. Go to Directory -> Groups

3. Create a Google Group "Chronicle-admins" (Copy and paste name) and add People to the group

4. Go to Applications and click on Applications
<img src="diagram/applications.png" width="300" height="200">

5. Click on Create App Integration
<img src="diagram/appintegration.png" width="300" height="100">

6. Click on SAML 2.0 and next
<img src="diagram/saml2.0.png" width="400" height="100">

7. Update the name and icon for the application
<img src="diagram/appname.png" width="400" height="300">

8. Enter placeholder (Unique Workforce pool id will be created in next step) values for ACS URL and Entity ID. 
- ACS URL: https://auth.backstory.chronicle.security/signin-callback/locations/global/workforcePools/your_unique_workforce_pool_id/providers/chronicle
- Entity ID: https://iam.googleapis.com/locations/global/workforcePools/your_unique_workforce_pool_id/providers/chronicle

<img src="diagram/acsentity.png" width="800" height="400">

9. Update the attribues with the identical names (High rate of failure in this step).
<img src="diagram/attributes.png" width="700" height="400">

## Usage

### 
1. Clone repo
```
git clone https://github.com/jasonbisson/terraform-google-chronicle-security-operations.git
```

2. Rename and update required variables in terraform.tvfars.template
```
mv terraform.tfvars.template terraform.tfvars
#Update required variables
```

3. Execute Terraform commands with existing identity (human or service account) to build Workforce Identity Infrastructure.
```
cd ~/terraform-google-chronicle-security-operations/
terraform init
terraform plan
terraform apply
Copy the output of unique Workforce Pool ID to update the ACS & Entity values in Custom SAML app
```

4. Update ACS & Entity values of Custom SAML app with Workforce Pool ID in Google admin console. https://admin.google.com/

<img src="diagram/updateacsentity.png" width="900" height="200">




