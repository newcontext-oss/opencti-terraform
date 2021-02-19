#! /bin/bash -e

# Script: ubuntu_opencti_connectors.sh
# Purpose: To automate the installation of OpenCTI connectors based on the manual deployment here: https://www.notion.so/Connectors-4586c588462d4a1fb5e661f2d9837db8
# Disclaimer: This script is written for testing and runs as root. Check the code and use at your own risk! The author is not liable for any damages or unexpected explosions!
# License: Apache 2.0

# ################
# Define functions
# ################

# Function: print_banner
# Print a massive OpenCTI banner.
# Parameters: None
# Returns: Nothing
function print_banner {
  echo -e "\n\n\x1B[1;49;34mMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMWK00000000000000000000000000000000000000000XWMWXKKKKKKNWMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMXdcccccccccccccccccccccccccccccccccccccccclxNMW0dooooo0WMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMXdccdkOOOOOOOOOOOOOOOOOOOOOOOOkkOOOOOOOOOOOKWWWNKOkdooOWMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMXdclkNMMMMMMMMMMMMMMMMMMMMMWN0k0WMMMMMMMMMMMMXXWMWKxooOWMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMXdclkNMMMMMMMMMMMMMMMMMMMMNOdodxkO0KXNWMMMMMWKOXMMXxooOWMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMXdcckNMMMMMMMMMMMMMMMMMMWKdldOKK00OkkkkO0KXXN0x0WWXxooOWMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMXdclkNMMMMMMMMMMMMMMMMMMXdldkkkkOO0KKKK0OOkkkxoONWXxooOWMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMXdclkNMMMMMMMMMMMMMMMMMWOlokKKKK0OOkkkkO00KKKkokNWKdooOWMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMXdclkNMMMMMMMMMMMMMMMMMNxcoxkkkkO00KKKK0OkkkkdoOWNOoooOWMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMXdclkNMMMMMMMMMMMMMMMMMNkcoOKKKK0OkkkkkO0KK0xoxXN0doooOWMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMXdclkNMMMMMMMMMMMMMMMMMWOllokkkOO0KKKK00OxddoxKNKxooooOWMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMXdclkNMMMMMMMMMMMMMMMMMMKdcd0KKK0OkkkkOOkdodOXXOddddooOWMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMXdclkNMMMMMMMMMMMMMMMMMMWOlloxkOO0K0kdooox0XNKxdkK0xooOWMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMXdclkNMMMMMMMMMMMMMMMWWWMXxllxkxooooodkOKNN0kkOXWWXxooOWMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMXdclkNMMMMMMMMMMWXXXNNWWWXklclooodkOKNWNXK00XNWMMMXxooOWMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMXdcckNMMMMMMWX0OO0XNWNKOxdoolclkKNWWWWNXXNWMMMMMMMXxooOWMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMXdclkNMMMWN0xdx0NWX0kdoolldkxlldXMMMWWWMMMMMMMMMMMXxooOWMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMXdcckNMMN0dld0WWXOdollx0KOkxdlclkNMMMMMMMMMMMMMMMMKxooOWMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMNxccxNMXkllkNMNOdldO0kxxk0KXKkdllOWMMMMMMMMMMMMMMWKdod0WMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMWOlco0NkllkNMNkodxdxO0KK0kxxk0OocdKMMMMMMMMMMMMMMNOooxXMMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMMXxclxOocxXMW0olxKX0OxxxOKXKOxdlclOWMMMMMMMMMMMMWKdooOWMMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMMW0ocllll0WMNkoxxxxk0KK0kxxk0KKOdcdXMMMMMMMMMMMWXkookXMMMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMMMWOlcccoKMMXxokKXKOxxxOKXKOkxxkdcoKMMMMMMMMMMWNkooxKWMMMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMMMMNOlccoKMMNkdxxxk0KK0kxxk0KK0kocdXMMMMMMMMMWXkooxKWMMMMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMMMMMNOlclkNMWNXWNKOkxxOKKK0kxxkOdlkNMMMMMMMMWXxooxKWMMMMMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMMMMMMW0oclxKWMMMMMMWNKOxxkOKXKxllxXMMMMMMMMN0dookXWMMMMMMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMMMMMMMWKxlcokXWMMMMMMMMWX0kxxkdokXMMMMMMMWKkoodONMMMMMMMMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMMMMMMMMMN0dlldOXWMMMMMMMMMW0ookKWMMMMMMWXOdookKWMMMMMMMMMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMMMMMMMMMMWXOolloOXWMMMMMWX0k0XWMMMMMWNKkdooxKWMMMMMMMMMMMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMMMMMMMMMMMMWXOdlcox0NMMWNXNWMMMMMWNXOxoodkKNWMMMMMMMMMMMMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMMMMMMMMMMMMMMWN0xod0NMMWNWWWMWNX0OxdooxOKWMMMMMMMMMMMMMMMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXNWWX0kxxkOOkxdoodxOKNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWX0kxdoooddkO0XNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNXKKXNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM OPENCTI CONNECTORS MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\x1B[0m\n\n"
}

# Function: check_root
# Check if we are logged in as root (UID 0) and exit if not.
# Parameters: None
# Returns: Nothing
function check_root {
  echo "Checking if root..."
  if [ "$EUID" -ne 0 ]
  then
    echo "Elevated privileges required. Please run with sudo or as root."
    exit
  fi
}

# Function: warn_user
# Warn the user that the script is running with root privileges and to be cautious.
# Parameters: None
# Returns: Nothing
function warn_user {
  echo -e "\x1B[0;49;91mThis script runs with elevated access; check the code and use at your own risk!\x1B[0m"
  echo
}

# Function: quit_on_error
# On a failure, this function prints the reason for the failure and exits the script.
# Parameters: String containing exit reason
# Returns: Nothing
function quit_on_error {
  if [[ $? -gt 0 ]]
  then
    echo -e "\n\n $@ ...FAIL";
    exit 10
  else
    echo "$@ ...OK"
  fi
}

# ################
# Define constants
# ################

# Show a prompt? When called from the wrapper script, we want this script to run through without user intervention. However, the user is expected to edit this script and we will want to run prompts for them in that case.
while getopts p: flag
do
  case "${flag}" in
    a) show_user_prompt=${OPTARG}
    ;;

    *) show_user_prompt=0
    ;;
  esac
done

# Connectors
opencti_dir="/opt/opencti"
opencti_connector_dir="${opencti_dir}/connectors"
opencti_url="http://localhost:4000"
opencti_token=$(grep token ${opencti_dir}/config/production.json | cut -d\" -f4)

# Check Ubuntu version for Python:
# - 18 uses 3.6 (will install 3.7)
# - 20 uses 3.8
ubuntu_version=$(grep "Ubuntu " /etc/lsb-release | cut -d" " -f2 | cut -d\. -f1)
if [[ ${ubuntu_version} == 18 ]]
then
  python_ver="3.7"
elif [[ ${ubuntu_version} == 20 ]]
then
  # Using bionic since focal not avaialble yet for RabbitMQ
  python_ver="3"
else
  quit_on_error echo "You are using an unsupported version of Ubuntu. Exiting."
fi

# ###########
# Main script
# ###########
print_banner
check_root
warn_user

# Connectors hash:
# - 0: disabled
# - 1: enabled
# This will only set up your instance for the connectors enabled. You must supply an API token (e.g., alienvault token) and enable the service.
# It should be safe to run this after changing configs or enabling services.
declare -A CONNECTORS;
CONNECTORS['alienvault']=0
CONNECTORS['amitt']=0
CONNECTORS['crowdstrike']=0
CONNECTORS['cryptolaemus']=0
CONNECTORS['cve']=1
CONNECTORS['cyber-threat-coalition']=0
CONNECTORS['cybercrime-tracker']=0
CONNECTORS['export-file-csv']=1
CONNECTORS['export-file-stix']=1
CONNECTORS['hygiene']=0
CONNECTORS['import-file-pdf-observables']=1
CONNECTORS['import-file-stix']=1
CONNECTORS['ipinfo']=0
CONNECTORS['lastinfosec']=0
CONNECTORS['malpedia']=0
CONNECTORS['misp']=1
CONNECTORS['mitre']=1
CONNECTORS['opencti']=1
CONNECTORS['valhalla']=0
CONNECTORS['virustotal']=1

echo "The following connectors will be installed:"
for i in "${!CONNECTORS[@]}"
do
  if [[ ${CONNECTORS[$i]} == 1 ]]
  then
    echo $i
  fi
done

if [[ ! $show_user_prompt ]]
then
  echo
  read -p "Are you sure you want to continue with the list above? [y/N] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    echo 'User backed out. Exiting.'
    exit 1
  fi
fi

for i in "${!CONNECTORS[@]}"
do
  if [[ ${CONNECTORS[$i]} == 1 ]]
  then
    python${python_ver} -m pip -q install -r ${opencti_connector_dir}/$i/src/requirements.txt

    if [[ -f "${opencti_connector_dir}/$i/src/config.yml" ]]
    then
      sed -i"" -e "s=http://localhost:8080=${opencti_url}=g" "${opencti_connector_dir}/$i/src/config.yml"
      sed -i"" -e "s/token: 'ChangeMe'/token: '${opencti_token}'/g" "${opencti_connector_dir}/$i/src/config.yml"
      sed -i"" -e "s/id: 'ChangeMe'/id: '$(grep id: ${opencti_connector_dir}/$i/src/config.yml | cut -d\' -f2)'/g" "${opencti_connector_dir}/$i/src/config.yml"
    else
      cp "${opencti_connector_dir}/$i/src/config.yml.sample" "${opencti_connector_dir}/$i/src/config.yml"
      sed -i"" -e "s=http://localhost:8080=${opencti_url}=g" "${opencti_connector_dir}/$i/src/config.yml"
      sed -i"" -e "s/token: 'ChangeMe'/token: '${opencti_token}'/g" "${opencti_connector_dir}/$i/src/config.yml"
      sed -i"" -e "s/id: 'ChangeMe'/id: '$(uuidgen -r | tr -d '\n' | tr '[:upper:]' '[:lower:]')'/g" "${opencti_connector_dir}/$i/src/config.yml"
    fi

    if [[ ! -f "/etc/systemd/system/opencti-connector-$i.service" ]]
    then
      cat > /etc/systemd/system/opencti-connector-$i.service <<- EOT
[Unit]
Description=OpenCTI Connector - $i
After=network.target
[Service]
Type=simple
WorkingDirectory=${opencti_connector_dir}/$i/src
ExecStart=/usr/bin/python${python_ver} "${opencti_connector_dir}/$i/src/$i.py"
ExecReload=/bin/kill -s HUP \$MAINPID
ExecStop=/bin/kill -s TERM \$MAINPID
PrivateTmp=true
Restart=always
[Install]
WantedBy=multi-user.target
EOT

      systemctl daemon-reload
      systemctl start opencti-connector-$i.service
    fi

    if [[ $(systemctl status --no-pager opencti-connector-$i.service | grep 'Active: active') ]]
    then
      echo "opencti-connector-$i.service is already running, restarting due to config changes"
      systemctl restart opencti-connector-$i.service
    fi

    quit_on_error "Installing service for connector: $i"
  fi
done

echo "Performing daemon-reload"
systemctl daemon-reload
quit_on_error "Reloading systemctl daemon"
