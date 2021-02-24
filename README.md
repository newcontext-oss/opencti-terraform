# opencti-terraform
This repository is here to provide you with a quick and easy way to deploy an OpenCTI instance in the cloud (currently supporting AWS and Azure; GCP on the roadmap).

If you run into any issues, please open an issue.

## Before you deploy
This repository currently supports deploying into AWS and Azure (GCP forthcoming). You will need to first change into the `aws/` or `azure/` directory _before_ you run `terraform init`. The following sections will bring you through the entire process and outline the various settings you will need to set before you can deploy.

### AWS
First, change into the `aws/` directory:
```
cd aws/
```

Before you get going, there are a some variables you will probably want to set. All of these can be found in `aws/terraform.tfvars`:
- `allowed_ips_application`: Array containing each of the IPs that are allowed to access the web application. Default `0.0.0.0/0` all IPs.
- `availability_zone`: The AWS availability zone. Default `us-east-1a`.
- `login_email`: The e-mail address used to login to the application. Default `login.email@example.com`.
- `region`: The AWS region used. Default `us-east`. **NOTE:** if you change this, you will need to change the remote state region in `aws/main.tf`. Variable interpolation is not allowed in that block so it has to be hardcoded.
- `root_volume_size`: The root volume size for the EC2 instance. Without this, the volume is 7.7GB and fills up in a day. Default `32` (GB). Note that this will incur costs.
- `subnet_id`: The AWS subnet to use. No default specified.
- `vpc_id`: The VPC to use. No default specified.

If your AWS credentials are not stored in `~/.aws/credentials`, you will need to edit that line in `aws/main.tf`.

#### Remote state
The remote state is defined in `aws/main.tf`. Variable interpolation is not allowed in that block and the easiest choice (both for writing the code and for you using the code) was to pick sensible defaults and hardcode them. The variables are:
- `bucket`: The name of the S3 bucket to store the state file in. Default `opencti-storage`.
- `key`: The name of the state file. Default `terraform_state`.
- `region`: The region to use. Default `us-east-1`.

This is mentioned as an FYI for the end user, but if you change the region in `aws/terraform.tfvars`, you will want to change the region here, too. If you want to change the S3 bucket name (defined as a local variable in `aws/main.tf`), you will also want to change it here.

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
