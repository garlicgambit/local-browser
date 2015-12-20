#!/bin/bash

# Bash options
set -o errexit # exit script when a command fails
set -o nounset # exit script when a variable is not set


### VARIABLES ###

# The user with access to X
normal_user=$(logname)
# Option to hardcode the correct user. Comment the line above.
# Uncomment the line below and change 'username' to the correct username.
#normal_user=username

# The browser you want to use
browser=lynx
# The user account used to fetch the web data
fetch_user=fetchuser
# The user account used to open the browser
browser_user=browseruser

# Tor/socks settings
socks_port=9050

# Files and folders
nologin_shell=/usr/sbin/nologin
sudo_localbrowser=/etc/sudoers.d/localbrowser


### SYSTEM CHECKS ###

# Only run as root
if [[ $(id -u) != "0" ]]; then
  echo "ERROR: Must be run as root...exiting script"
  exit 0
fi

# Inform user about configuration
echo ""
echo "Username: ${normal_user}"
echo "Browser: ${browser}"
echo ""
echo "Is this your normal username?"
echo "If not then you should stop the program and run it with your normal user account."
echo "Will wait for 20 seconds before continuing."
echo ""
sleep 20
echo "Starting installation."

### INSTALL SOFTWARE ###

# Get latest updates
apt-get update

# Install sytem requirements
apt-get install -y sudo curl gzip tor "${browser}"

### CONFIGURE ACCOUNTS ###

# Create fetch user
if ! id "${fetch_user}" &> /dev/null; then
  useradd --create-home --shell "${nologin_shell}" --expiredate 1 "${fetch_user}"
fi

# Create browser user
if ! id "${browser_user}" &> /dev/null; then
  useradd --create-home --shell "${nologin_shell}" --expiredate 1 "${browser_user}"
fi

# Configure sudoers
if [[ ! -e "${sudo_localbrowser}" ]]; then
  echo "${normal_user}    ALL=(${fetch_user}) NOEXEC:NOPASSWD: /usr/bin/curl" >> "${sudo_localbrowser}"
  echo "${normal_user}    ALL=(${fetch_user}) NOEXEC:NOPASSWD: /bin/chmod" >> "${sudo_localbrowser}"
  echo "${normal_user}    ALL=(${fetch_user}) NOEXEC:NOPASSWD: /bin/mv" >> "${sudo_localbrowser}"
  echo "${normal_user}    ALL=(${fetch_user}) NOPASSWD: /bin/gunzip" >> "${sudo_localbrowser}"
  echo "${normal_user}    ALL=(${browser_user}) NOEXEC:NOPASSWD: /usr/bin/${browser}" >> "${sudo_localbrowser}"
  chmod 440 "${sudo_localbrowser}"
fi

# Output example firewall rules for system with local Tor or socks proxy
echo ""
echo "Below are example firewall rules to add to a system which uses a local Tor or socks proxy."
echo "These rules might break your system. Use at own risk."
echo ""
echo "Example rules:"
echo "..."
echo "iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT"
echo "iptables -A OUTPUT -o lo -d 127.0.0.1/32 -p tcp --syn --dport ${socks_port} -m state --state NEW -m owner --uid-owner ${fetch_user} -j ACCEPT"
echo "iptables -A OUTPUT -m owner --uid-owner ${fetch_user} -j REJECT"
echo "iptables -A OUTPUT -m owner --uid-owner ${browser_user} -j REJECT"
echo "iptables -A OUTPUT -o lo -j ACCEPT"
echo "..."
echo ""
