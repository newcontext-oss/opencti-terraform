# opencti-terraform
## AWS


## Azure

## Before you deploy
Before you get going, there are a few things you will need to do:
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

## Deployment
To deploy, navigate to the repository and run `terraform init`. Then, create a plan (`terraform plan`) and check it over. Once you're good to go, apply it (`terraform apply`).

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
