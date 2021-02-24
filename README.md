# opencti-terraform
This repository is here to provide you with a quick and easy way to deploy an OpenCTI instance in the cloud (currently supporting AWS and Azure; GCP on the roadmap).

If you run into any issues, please open an issue.

## Before you deploy
There is currently no simple way to tell Terraform to deploy to one cloud or another. Should that feature ever become available, the code will be restructured accordingly. In the meantime, if you would like to deploy to a cloud, you will need to first change into the `aws/` or `azure/` directory _before_ you run `terraform init`. The following sections will bring you through the entire process and outline the various settings you will need to set before you can deploy.

### AWS
First, change into the `aws/` directory:
```
cd aws/
```

Then, there are a few things you will need to configure before you can run Terraform:
- Edit `main.tf`:
  - (optional) Edit the AWS region (default is `us-east-1`).
  - Make sure your AWS credentials are in place and edit the path to them.
  - Edit the login e-mail (`opencti_install_email`).
  - Edit the `vpc_id`.
  - Edit the `subnet_id`
- In `security_group.tf`:
  - Add your public-facing IP address to the ingress rules (this can be a comma-separated list).
- (optional) In `ec2.tf`:
  - Edit the instance's tag `Name` (the default is "opencti").

### Azure
First, change into the `azure/` directory:
```
cd azure/
```

Then, you will need to login to Azure CLI and set some variables. Let's do Azure login first. To that end, just run `az login` to login and be able to deploy the Terraform code.

Before you deploy, you may wish to change some of the settings. These are all in `azure/terraform.tfvars`:
- `account_name`: The Azure account name. No default; this must be set.
- `admin_user`: The name of the admin user on the VM. Default `azureuser`
- `location`: The Azure region to deploy in. Default `eastus`.
- `login_email`: The e-mail address used to login to the OpenCTI web frontend. Default `login.email@example.com`.
- `os_disk_size`: The VM's disk size (in GB). Default `32` (the (minimum recommended spec)[https://github.com/OpenCTI-Platform/opencti/blob/5ede2579ee3c09c248d2111b483560f07d2f2c18/opencti-documentation/docs/getting-started/requirements.md]).

## Deployment
To see what Terraform is going to do and make sure you're cool with it, create a plan (`terraform plan`) and check it over. Once you're good to go, apply it (`terraform apply`).

### AWS
Once the instance is online, connect to it via SSM (Systems Manager) in the AWS console. You can follow along with the install by checking the logfile:
```
tail -F /var/log/user-data.log
```

### Azure
To login, run the following commands. These commands will remove the old SSH key, put the new one in place, fix its permissions, and SSH into the VM:
```
rm -f ~/.ssh/azureuser
cat terraform.tfstate | jq '.outputs.tls_private_key.value' | sed 's/"//g' | awk '{ gsub(/\\\\n/,"\\n") }1' > ~/.ssh/azureuser
chmod 400 ~/.ssh/azureuser
ssh -i ~/.ssh/azureuser azureuser@$(az vm show --resource-group opencti_rg --name opencti -d --query [publicIps] -o tsv)
```

## Post-deployment
Once the installation is complete, you'll want to grab the admin password that was generated. The username is the e-mail you provided in `terraform.tfvars`. Get the password by running the following on the VM:
```
cat /opt/opencti/config/production.json | jq '.app.admin.password'
```

Next, go to port 4000 of the public IP of the machine and login with the credentials you just grabbed.
