#!/bin/bash -e
# Terraform doesn't support massively long scripts (the limit is 16k characters). The install script is much longer than that (even without the banner). This wrapper script sets up the base OS, installs the necessary tools to run the installation and connector scripts, and then pulls those in from an S3 bucket (as defined in s3.tf).

# SET THE FOLLOWING for your own deployment:
install_script_name='opencti-installer.sh'
connectors_script_name='opencti-connectors.sh'
login_email='admin@example.com'
is_aws=0
# If you're on AWS, also set this one:
# opencti_bucket_name=

# Print all output to the specified logfile,  the system log (-t: as opencti-install), and STDERR (-s).
exec > >(tee /var/log/opencti-install.log|logger -t opencti-install -s 2>/dev/console) 2>&1

echo "Update base OS"
apt-get update
apt-get upgrade -y

if [[ ${is_aws} ]]
  # Install AWS CLI so we can copy the install and connectors scripts down.
  apt-get install -y awscli
  echo "Copy the opencti installer script to /opt and execute it"
  aws s3 cp s3://${opencti_bucket_name}/${install_script_name} /opt/${install_script_name}
  chmod +x /opt/${install_script_name}
  echo "Copy opencti connectors script to /opt and execute it"
  aws s3 cp s3://${opencti_bucket_name}/${connectors_script_name} /opt/${connectors_script_name}
  chmod +x /opt/${connectors_script_name}
fi

echo "Starting OpenCTI installation script"
# Run the install script with the provided e-mail address (from main.tf)
/opt/${install_script_name} -e "${login_email}"

echo "OpenCTI installation script complete."

echo "Starting OpenCTI connectors script."
# Run the script without prompting the user (the default, `-p 0`, will prompt if the user wants to apply; this is less than ideal for an automated script).
/opt/${connectors_script_name} -p 1

echo "OpenCTI wrapper script complete."
