#!/bin/bash -e
# Why a wrapper script? Terraform doesn't support massively long scripts (the limit is 16k characters). The install script is much longer than that (even without the banner). This wrapper script sets up the base OS, installs the necessary tools to run the installation and connector scripts, and then pulls those in from an S3 bucket (as defined in s3.tf).
# The wrapper script is used by each of the providers (in `*/vm.tf`) and each variable has to be filled out in order to run. Unfortunately, this means that if you change something in one provider (or in this script), you have to change it in each of the others. It's not ideal, but FYI.

# Print all output to the specified logfile, the system log (-t: as opencti-install), and STDERR (-s).
exec > >(tee /var/log/opencti-install.log|logger -t opencti-install -s 2>/dev/console) 2>&1

echo "Update base OS"
apt-get update
apt-get upgrade -y

# Copy install and connectors script down from cloud storage.
if [[ ${cloud} == "aws" ]]
then
  echo "Install AWS CLI"
  apt-get install -y awscli
  echo "Copy the opencti installer script to /opt"
  aws s3 cp s3://${storage_bucket}/${install_script_name} /opt/${install_script_name}
  echo "Copy opencti connectors script to /opt"
  aws s3 cp s3://${storage_bucket}/${connectors_script_name} /opt/${connectors_script_name}
elif [[ ${cloud} == "azure" ]]
then
  echo "Install Azure CLI (this can take several minutes)"
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
  echo "Copy the opencti installer script to /opt"
  az storage blob download --account-name "${account_name}" --container-name "${storage_bucket}" --name "${install_script_name}" --file /opt/"${install_script_name}" --connection-string "${connection_string}"
  echo "Copy opencti connectors script to /opt"
  az storage blob download --account-name "${account_name}" --container-name "${storage_bucket}" --name "${connectors_script_name}" --file /opt/"${connectors_script_name}" --connection-string "${connection_string}"
elif [[ ${cloud} == "gcp" ]]
then
  echo "Copy the opencti installer script to /opt"
  gsutil cp gs://${storage_bucket}/${install_script_name} /opt/${install_script_name}
  echo "Copy opencti connectors script to /opt"
  gsutil cp gs://${storage_bucket}/${connectors_script_name} /opt/${connectors_script_name}
fi

echo "Make scripts executable"
chmod +x /opt/${install_script_name}
chmod +x /opt/${connectors_script_name}

echo "Starting OpenCTI installation script"
# Run the install script with the provided e-mail address.
# AWS automatically runs the script as root, Azure doesn't.
sudo /opt/${install_script_name} -e "${login_email}"
echo "OpenCTI installation script complete."

echo "Starting OpenCTI connectors script."
# Run the script without prompting the user (the default, `-p 0`, will prompt if the user wants to apply; this is less than ideal for an automated script).
sudo /opt/${connectors_script_name} -p 1
echo "OpenCTI wrapper script complete."
