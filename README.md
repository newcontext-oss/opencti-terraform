# opencti-terraform
## Before you deploy
Before you get going, you will need to edit `main.tf` with the path to your AWS credentials and with the e-mail you want OpenCTI to use.

## Deployment
To deploy, navigate to the repository and run `terraform init`. Then, create a plan (`terraform plan`) and apply (`terraform apply`).

Once the instance is online, connect to it via SSM (Systems Manager) in the AWS console. You can follow along with the install by checking the logfile:
```
tail -F /var/log/user-data.log
```

## Post-deployment
Once the installation is complete, you'll want to grab the admin password that was generated. Get this from
```
cat /opt/opencti/config/production.json
```

Next, go to port 4000 of the public ip of the machine (found in the aws console) and this should bring you to the OpenCTI login for that machine. If it does not, you will probably need to add your IP to the inbound (ingress) rule on the security group. Once that is added/applied, refresh your page and it should take you to the login.

Use the password you got from the `production.json` file and whatever the admin e-mail is set to (currently it is admin@example.com). I've noted in the code that this MUST be in an e-mail address format, although it doesn't have to be a real address.
