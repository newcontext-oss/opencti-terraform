# opencti-terraform
This repository is here to provide you with a quick and easy way to deploy an OpenCTI instance in the cloud (currently supporting AWS and Azure; working on GCP).

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

Then, you will need to login to Azure CLI and set some things. Let's do Azure login first. The purpose of this guide is to provide an easy way to evaluate if you like OpenCTI, not to start up a production instance. To that end, just run `az login` to login and be able to deploy the Terraform code. Authenticating via service principal is outside the scope of this guide.

Next, set the following before you can deploy:
- ...

## Deployment
To see what Terraform is going to do and make sure you're cool with it, create a plan (`terraform plan`) and check it over. Once you're good to go, apply it (`terraform apply`).

Once the instance is online, connect to it via SSM (Systems Manager) in the AWS console. You can follow along with the install by checking the logfile:
```
tail -F /var/log/user-data.log
```

## Post-deployment
Once the installation is complete, you'll want to grab the admin password that was generated. The username is the e-mail you provided in `main.tf` above. Get the password with:
```
cat /opt/opencti/config/production.json | jq '.app.admin.password'
```

Next, go to port 4000 of the public IP of the machine (found in the AWS console) and this will bring you to the OpenCTI login for that machine. If it does not, check the ingress rule in `security_group_tf`.
