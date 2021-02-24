#! /bin/bash -e

# Script: ubuntu_opencti_installer.sh
# Purpose: To automate the installation of OpenCTI. Based on this manual deployment: https://www.notion.so/Manual-deployment-b911beba44234f179841582ab3894bb1
# Disclaimer: This script is written for testing and runs as root. Check the code and use at your own risk! The author is not liable for any damages or unexpected explosions!
# License: Apache 2.0

# ####################
# Function definitions
# ####################

# Function: print_banner
# Print a massive OpenCTI banner.
# Parameters: None
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
  echo -e "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM OPENCTI INSTALLER MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
  echo -e "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\x1B[0m\n\n"
}

# Function: log_section_heading
# Prints an obnoxious line, the time (with second precision), and the section heading. This visually separates the log and makes it more readable.
# Parameters:
# - $1: section heading
function log_section_heading {
  echo
  echo "###^^^###^^^###^^^###^^^###"
  date --iso-8601=seconds
  echo $1
  echo "###^^^###^^^###^^^###^^^###"
  echo
}

# Function: check_root
# Check if we are logged in as root (UID 0) and exit if not.
# Parameters: None
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
function warn_user {
  echo -e "\x1B[0;49;91mThis script runs with elevated access; check the code and use at your own risk!\x1B[0m"
  echo
}

# Function: quit_on_error
# On a failure, this function prints the reason for the failure and exits the script.
# Parameters: String containing exit reason
function quit_on_error {
  if [[ $? -gt 0 ]]
  then
    echo -e "\n\n $@ ...FAIL";
    exit 10
  else
    echo "$@ ...OK"
  fi
}

# Function: update_apt_pkg
# Non-interactive package management which updates the supplied package.
# Parameters: The package to update.
function update_apt_pkg {
  DEBIAN_FRONTEND=noninteractive apt-get -qq update
  quit_on_error "Checking packages"
}

# Function: check_apt_pkg
# Checks if a package is installed and updates it. If the package is not installed, it is installed.
# Parameters:
# - $1: package to install
# - $2: version to install
function check_apt_pkg {
  if [[ $(dpkg -l | grep $1) ]]
  then
    echo >&2 "$1 found, attempting upgrade: executing apt-get -y install --only-upgrade '$1''$2'";
    DEBIAN_FRONTEND=noninteractive apt-get install --only-upgrade "$1""$2"
    quit_on_error "Upgrading $1$2"
  else
    echo >&2 "$1 missing, attempting install: executing apt-get -y install '$1''$2'";
    DEBIAN_FRONTEND=noninteractive apt-get -y install "$1""$2"
    quit_on_error "Installing $1$2"
  fi
}

# Function: check_service
# Checks if a service is active or nah. Matches Grakn service output.
# Parameters:
# - $1: service to check
function check_service {
  if [[ $(systemctl show -p ActiveState --value "$1") == "active" ]]
  then
    echo "$1: RUNNING"
  else
    echo "$1: NOT RUNNING"
  fi
}

# Function: enable_service
# Checks if a service is disabled and enables it. If the service is already running, restart it. Otherwise, start the service.
# Parameters:
# - $1: service name
function enable_service {
  if [[ $(systemctl is-enabled "$1") == "disabled" ]]
  then
    echo "$1 service not enabled."
    systemctl enable --now "$1"
    quit_on_error "Enabling $1"
  elif [[ $(systemctl show -p SubState --value "$1") == "running" ]]
  then
    echo "$1 service already running."
    systemctl restart "$1"
    quit_on_error "Restarting $1"
  else
    echo "$1 service not running."
    systemctl start "$1"
    quit_on_error "Starting $1"
  fi
}

# Function: disable_service
# For the provided service, if it is enabled, disable it; otherwise, if it's running, stop it; otherwise do nothing.
# Parameters:
# - $1: service name
function disable_service {
  if [[ $(systemctl is-enabled "$1") == "enabled" ]]
  then
    echo "$1 service enabled. Disabling."
    systemctl disable --now "$1"
    quit_on_error "Disabling $1"
  elif [[ $(systemctl show -p SubState --value "$1") == "running" ]]
  then
    echo "$1 service still running. Stopping."
    systemctl stop "$1"
    quit_on_error "Stopping $1"
  else
    echo "$1 service not running."
    quit_on_error "Skipping $1"
  fi
}

# ################
# Define constants
# ################

# Check Ubuntu version for Python:
# - 18 uses 3.6 (will install 3.7)
# - 20 uses 3.8
ubuntu_version=$(grep "Ubuntu " /etc/lsb-release | cut -d" " -f2 | cut -d\. -f1)
if [[ ${ubuntu_version} == 18 ]]
then
  distro="bionic"
  run_python="python3.7"
elif [[ ${ubuntu_version} == 20 ]]
then
  # Using bionic since focal not avaialble yet for RabbitMQ
  distro="bionic"
  run_python="python3"
else
  quit_on_error echo "You are using an unsupported version of Ubuntu. Exiting."
fi

# Grakn
grakn_bin_version="2.0.0-alpha-6"
grakn_console_version="2.0.0-alpha-4"
grakn_core_all_version="2.0.0-alpha-4"
grakn_core_server_version="2.0.0-alpha-4"

# Minio
minio_dir="/opt/minio/data"

# Redis
redis_ver="6.0.5"

# RabbitMQ
rabbitmq_ver="3.8.5-1"
rabbitmq_release_url="https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc"

# OpenCTI
# This has to be in email address format, otherwise the opencti-server service will freak out and not start correctly. - KTW
# TODO: this e-mail needs to be scrubbed and read in from Terraform
while getopts e: flag
do
  case "${flag}" in
    e) opencti_email=${OPTARG}
    ;;

    *) opencti_email="user@example.com"
    ;;
  esac
done

opencti_ver="4.2.1"
opencti_dir="/opt/opencti"
opencti_worker_count=2

# ###########
# Main script
# ###########
print_banner
check_root
warn_user

# Enter script's root directory
script_pwd="$(dirname "$0")"

if [[ -d "${script_pwd}" ]]
then
  cd "${script_pwd}"
  log_section_heading "Entering script's root directory: ${script_pwd}"
fi

# Clean the slate: disable any service we will be messing with in this script. If you're looking through the install log and see errors here, it's fine; a lot of these aren't installed. This is just to be safe.
log_section_heading "Disable existing services"
for i in $(seq 1 $opencti_worker_count)
do
  disable_service "opencti-worker@$i"
done
disable_service 'opencti-server'
disable_service 'elasticsearch'
disable_service 'redis-server'
disable_service 'rabbitmq-server'
disable_service 'minio'
disable_service 'grakn'

# The VMs we're running are not that big and we're going to quickly fill the system log with our work (and especially the connectors). This will max out the logs at 100M.
echo "SystemMaxUse=100M" >> /etc/systemd/journald.conf

# Ensure required packages are installed at latest (or specified) version. Repositories were updated in the wrapper script.
log_section_heading "Installing and updating required packages"
update_apt_pkg
check_apt_pkg 'apt-transport-https'
check_apt_pkg 'curl'
check_apt_pkg 'git'
check_apt_pkg 'jq'
check_apt_pkg 'openssl'
check_apt_pkg 'software-properties-common'
check_apt_pkg 'tar'
check_apt_pkg 'wget'

## NodeJS
log_section_heading "NodeJS"
check_apt_pkg 'nodejs'
check_apt_pkg 'npm'
npm install -g n
n lts
sed -i 's|PATH.*|'"${PATH}:/usr/local/bin/node"'|g' /etc/environment
export PATH="$PATH:/usr/local/bin/node"
npm rebuild

## Yarn
log_section_heading "Yarn"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
update_apt_pkg
check_apt_pkg 'yarn'

## Python
log_section_heading "Python"
check_apt_pkg "${run_python}"
check_apt_pkg "python3-pip"
${run_python} -m pip install --upgrade pip
${run_python} -m pip -q install --ignore-installed PyYAML

## Grakn
log_section_heading "Grakn"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 8F3DA4B5E9AEF44C
sudo add-apt-repository 'deb [ arch=all ] https://repo.grakn.ai/repository/apt/ trusty main'
update_apt_pkg
# apt-get install -y grakn-console=2.0.0-alpha-3 # Required dependency
# apt-get install -y grakn-core-all
check_apt_pkg 'grakn-bin' "=${grakn_bin_version}"
check_apt_pkg 'grakn-core-server' "=${grakn_core_server_version}"
check_apt_pkg 'grakn-console' "=${grakn_console_version}"
check_apt_pkg 'grakn-core-all' "=${grakn_core_all_version}"

### Create systemd unit file for Grakn
cat <<EOT > /etc/systemd/system/grakn.service
[Unit]
Description=Grakn.AI Server daemon
After=network.target
[Service]
Type=forking
ExecStart=/usr/local/bin/grakn server start
ExecStop=/usr/local/bin/grakn server stop
ExecReload=/usr/local/bin/grakn server stop && /usr/local/bin/grakn server start
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOT
systemctl daemon-reload
enable_service 'grakn'

## Elasticsearch
log_section_heading "Elasticsearch"
echo "Setting up logrotate for Elasticsearch"
# rotate 20 logs at 50M means a maximum of 1GB Elasticsearch logs.
cat <<EOT > /etc/logrotate.d/elasticsearch
/var/log/elasticsearch/*.log {
  daily
  rotate 20
  size 50M
  copytruncate
  compress
  delaycompress
  missingok
  notifempty
  create 644 elasticsearch elasticsearch
}
EOT
wget -qO - 'https://artifacts.elastic.co/GPG-KEY-elasticsearch' | apt-key add -
add-apt-repository "deb https://artifacts.elastic.co/packages/7.x/apt stable main"
update_apt_pkg
check_apt_pkg 'elasticsearch'
enable_service 'elasticsearch'

## Minio
log_section_heading "Minio"
wget --quiet -O minio https://dl.min.io/server/minio/release/linux-amd64/minio
chmod +x minio
mv minio "/usr/local/bin/"
if [[ ! -d "${minio_dir}" ]]
then
  mkdir -p "${minio_dir}"
fi

### From: https://github.com/minio/minio-service/blob/master/linux-systemd/minio.service
if [[ ! -f "/etc/default/minio" ]]
then
  # .minio.access_key
  RMINIOAK="$(openssl rand -hex 12)"
  # .minio.secret_key
  RMINIOSK="$(openssl rand -base64 25 | tr -d '/')"
  cat > /etc/default/minio <<- EOT
# Volume to be used for MinIO server.
MINIO_VOLUMES="/opt/minio/data/"
# Use if you want to run MinIO on a custom port.
# MINIO_OPTS="--address :9199"
# Access Key of the server.
MINIO_ACCESS_KEY=${RMINIOAK}
# Secret key of the server.
MINIO_SECRET_KEY=${RMINIOSK}
EOT
else
  RMINIOAK="$(grep -o 'MINIO_ACCESS_KEY=.*' /etc/default/minio | cut -f2- -d=)"
  RMINIOSK="$(grep -o 'MINIO_SECRET_KEY=.*' /etc/default/minio | cut -f2- -d=)"
fi

curl "https://raw.githubusercontent.com/minio/minio-service/master/linux-systemd/minio.service" -o "/etc/systemd/system/minio.service"
sed -i'' -e 's/User=minio-user/User=root/g' "/etc/systemd/system/minio.service"
sed -i'' -e 's/Group=minio-user/Group=root/g' "/etc/systemd/system/minio.service"
systemctl daemon-reload
enable_service 'minio'

## Redis
log_section_heading "Redis"
update_apt_pkg
check_apt_pkg 'gcc'
check_apt_pkg 'build-essential'
check_apt_pkg 'libsystemd-dev'  # required for systemd notify to work
check_apt_pkg 'pkg-config'

if [[ ! -f "/usr/local/bin/redis-server" ]]
then
  wget --quiet "http://download.redis.io/releases/redis-${redis_ver}.tar.gz"
  tar xzf redis-${redis_ver}.tar.gz
  cd redis-${redis_ver}
  make -s
  quit_on_error "Building Redis ${redis_ver}..."
  make -s install
  quit_on_error "Installing Redis ${redis_ver}..."
  cd ..
fi

if [[ ! $(id redis) ]]
then
  adduser --system --group --no-create-home redis
  usermod -L redis
fi

if [[ ! -d "/var/lib/redis/" ]]
then
  mkdir -p "/var/lib/redis"
  chown redis:redis "/var/lib/redis"
  chmod ug+rwX "/var/lib/redis"
fi

if [[ ! -d "/etc/redis/" ]]
then
  mkdir -p "/etc/redis/"
  chown -R redis:redis "/etc/redis/"
fi

if [[ ! -f "/etc/redis/redis.conf" ]]
then
  cp "redis-${redis_ver}/redis.conf" "/etc/redis/redis.conf"
  sed -i 's/^supervised no/supervised systemd/' "/etc/redis/redis.conf"
  chown redis:redis "/etc/redis/redis.conf"
fi

if [[ ! -f "/etc/default/redis-server" ]]
then
  touch "/etc/default/redis-server"
  echo 'ULIMIT=65536' >> "/etc/default/redis-server"
fi

if [[ ! -f "/etc/systemd/system/redis-server.service" ]]
then
cat > /etc/systemd/system/redis-server.service <<- EOT
[Unit]
Description=Redis persistent key-value storage
After=network.target
[Service]
Type=notify
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecStop=/usr/local/bin/redis-cli -p 6379 shutdown
ExecReload=/bin/kill -USR2 \$MAINPID
TimeoutStartSec=10
TimeoutStopSec=10
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOT
  systemctl daemon-reload
fi

enable_service 'redis-server'

## RabbitMQ
log_section_heading "RabbitMQ"
curl -fsSL "${rabbitmq_release_url}" | apt-key add -
tee /etc/apt/sources.list.d/bintray.rabbitmq.list <<EOT
## Installs the latest Erlang 22.x release.
## Change component to "erlang-21.x" to install the latest 21.x version.
## "bionic" as distribution name should work for any later Ubuntu or Debian release.
## See the release to distribution mapping table in RabbitMQ doc guides to learn more.
deb [trusted=yes] https://dl.bintray.com/rabbitmq-erlang/debian ${distro} erlang
deb [trusted=yes] https://dl.bintray.com/rabbitmq/debian ${distro} main
EOT

update_apt_pkg
check_apt_pkg 'rabbitmq-server' "=${rabbitmq_ver}"
enable_service 'rabbitmq-server'

# Set RabbitMQ environment variables
RRMQUNAME="rabbitadmin"

# rabbitmq doesn't like '/'
RRMQPASS="$(openssl rand -base64 25 | tr -d '/' | tr -d '+')"

# get the info once
RMQ_user_list="$(rabbitmqctl list_users)"
if grep 'guest' <<< "${RMQ_user_list}"
then
  rabbitmqctl delete_user guest
fi

if ! grep "${RRMQUNAME}" <<< "${RMQ_user_list}"
then
  rabbitmqctl add_user "${RRMQUNAME}" "${RRMQPASS}"
else
  rabbitmqctl change_password "${RRMQUNAME}" "${RRMQPASS}"
fi
rabbitmqctl set_user_tags "${RRMQUNAME}" administrator
rabbitmqctl set_permissions -p / "${RRMQUNAME}" ".*" ".*" ".*"
rabbitmqctl start_app
rabbitmq-plugins enable rabbitmq_management

RMQ_user_list="$(rabbitmqctl list_users)"
echo -e "${RMQ_user_list}"

# Check status of services
log_section_heading "Checking service statuses"
check_service 'elasticsearch'
check_service 'grakn'
check_service 'minio'
check_service 'rabbitmq-server'
check_service 'redis-server'

# OpenCTI
log_section_heading "OpenCTI package installation"

echo "OpenCTI: download tarball"
wget --quiet -O opencti-release-${opencti_ver}.tar.gz "https://github.com/OpenCTI-Platform/opencti/releases/download/${opencti_ver}/opencti-release-${opencti_ver}.tar.gz"
tar -xzf "opencti-release-${opencti_ver}.tar.gz" --directory "/opt/"
rm "opencti-release-${opencti_ver}.tar.gz"

echo "Changing owner of ${opencti_dir} to:" $(whoami)":"$(id -gn)
chown -R $(whoami):$(id -gn) "${opencti_dir}"

echo "OpenCTI: Installing Python dependencies"
${run_python} -m pip -q install -r "${opencti_dir}/connectors/export-file-stix/src/requirements.txt"
${run_python} -m pip -q install -r "${opencti_dir}/connectors/import-file-stix/src/requirements.txt"
${run_python} -m pip -q install -r "${opencti_dir}/src/python/requirements.txt"
${run_python} -m pip -q install -r "${opencti_dir}/worker/requirements.txt"
${run_python} -m pip install requests==2.25.0

echo "OpenCTI: Edit configs"
## Setting: .app.admin.password
# RADMINPASS="opencti"
RADMINPASS="$(openssl rand -base64 25 | tr -d '/')"
## Setting: .app.admin.token
RADMINTOKEN="$(uuidgen -r | tr -d '\n' | tr '[:upper:]' '[:lower:]')"

echo "OpenCTI: Copy proper configs"
# Take default configuration and fill in our values.
cat ${opencti_dir}/config/default.json | jq ".app.admin.email=\"${opencti_email}\" | .app.admin.password=\"${RADMINPASS}\" | .app.admin.token=\"${RADMINTOKEN}\" | .minio.access_key=\"${RMINIOAK}\" | .minio.secret_key=\"${RMINIOSK}\" | .rabbitmq.username=\"${RRMQUNAME}\" | .rabbitmq.password=\"${RRMQPASS}\"" > ${opencti_dir}/config/production.json

echo "OpenCTI: Create unit file"
cat > /etc/systemd/system/opencti-server.service <<- EOT
[Unit]
Description=OpenCTI Server daemon
After=network.target
[Service]
Type=simple
WorkingDirectory=${opencti_dir}/
ExecStart=/usr/bin/yarn serv
ExecReload=/bin/kill -s HUP \$MAINPID
ExecStop=/bin/kill -s TERM \$MAINPID
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOT

echo "OpenCTI: Copy worker configuration"
cp "$opencti_dir/worker/config.yml.sample" "$opencti_dir/worker/config.yml"

echo "OpenCTI: Edit worker configuration"
sed -i'' -e 's/token: '"'"'ChangeMe'"'"'/token: '"${RADMINTOKEN}"'/g' "$opencti_dir/worker/config.yml"

# Switch to port 4000
sed -i "s/'http:\/\/localhost:8080'/'http:\/\/localhost:4000'/" "$opencti_dir/worker/config.yml"

echo "OpenCTI: create unit file"
cat > /etc/systemd/system/opencti-worker@.service <<- EOT
[Unit]
Description=OpenCTI Worker daemon %i
After=network.target opencti-server.service
[Service]
Type=simple
WorkingDirectory=${opencti_dir}/worker/
ExecStart=/usr/bin/${run_python} "${opencti_dir}/worker/worker.py"
ExecReload=/bin/kill -s HUP \$MAINPID
ExecStop=/bin/kill -s TERM \$MAINPID
PrivateTmp=true
Restart=always
[Install]
WantedBy=multi-user.target
EOT

echo "OpenCTI: daemon-reload"
systemctl daemon-reload

## Remove requirement for node v12-13 since we are installing v14; making it >= 12.
sed -i 's/"node": ">= 12.* < 13.0.0"/"node": ">= 12"/' $opencti_dir/package.json

echo "OpenCTI: Starting services - sleep 30 to wait for services to boot"
enable_service 'opencti-server'
sleep 30  # waiting for opencti to check all services
check_service 'opencti-server'

echo "OpenCTI: Enabling workers"
for i in $(seq 1 $opencti_worker_count)
do
  sleep 5
  enable_service "opencti-worker@$i"
  sleep 5
  check_service "opencti-worker@$i"
done

# Clean up packages
log_section_heading "Clean up packages"
apt-get clean
apt-get autoremove -y
