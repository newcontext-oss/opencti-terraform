# opencti-terraform
## Before you deploy
Before you get going, there are a some variables you will probably want to set. All of these can be found in `aws/terraform.tfvars`:
- `allowed_ips_application`: Array containing each of the IPs that are allowed to access the web application. Default `0.0.0.0/0` all IPs.
- `availability_zone`: The AWS availability zone. Default `us-east-1a`.
- `login_email`: The e-mail address used to login to the application. Default `login.email@example.com`.
- `region`: The AWS region used. Default `us-east`.
- `root_volume_size`: The root volume size for the EC2 instance. Without this, the volume is 7.7GB and fills up in a day. Default `32` (GB). Note that this will incur costs.
- `subnet_id`: The AWS subnet to use. No default specified.
- `vpc_id`: The VPC to use. No default specified.

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
