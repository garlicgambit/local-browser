#!/bin/bash
#
# DESCRIPTION
# Open a website in a more private and secure way with your favorite browser.
# This is made possible by separating fetching the data from processing
# the data. Normally the browser will do both. With this script a separate
# program will fetch the data and the browser will only process the data.
# The browser itself has no network access due to strict firewall rules.
# This way the browser is not able to leak any data to the web.
#
# SUPPORT PROJECT:
# Bitcoin:
# 1FJ5VMCSXz4WFztzMYzCfWXX6Z5zCn4XDj
#
# Monero:
# 463DQj1ebHSWrsyuFTfHSTDaACx3WZtmMFMwb6QEX7asGyUBaRe2fHbhMchpZnaQ6XKXcHZLq8Vt1BRSLpbqdr283QinCRK

# Bash options
set -o errexit # exit script when a command fails
set -o nounset # exit script when a variable is not set


### VARIABLES ###

# Browsers which are supported
# - lynx
# - elinks
# - links
# - w3m

# The browser you want to use
browser=lynx

# The user account used to fetch the web data
fetch_user=fetchuser
# The user account used to open the browser
browser_user=browseruser

# General curl settings
connection_timeout=30
max_redirects=5
socks_ip=127.0.0.1
socks_port=9050

# HTTP headers
header_ua="User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:38.0) Gecko/20100101 Firefox/38.0"
header_accept="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
header_lang="Accept-Language: en-US,en;q=0.5"
header_enc="Accept-Encoding: gzip, deflate"
header_con="Connection: keep-alive"

strip_http_prefix=${1#*//}
domain_only=${strip_http_prefix%%/*}
strip_domain=${strip_http_prefix#*/}
page_clean=${strip_domain//[^a-zA-Z0-9]/}
page_only=${page_clean:-index.html}
page_on_disk=/home/"${fetch_user}"/"${domain_only}"/"${page_only}"


### FETCH DATA ###

# Fetch data with curl as the 'fetch_user'
sudo -n -u "${fetch_user}" curl --header "${header_ua}" \
                                --header "${header_accept}" \
                                --header "${header_lang}" \
                                --header "${header_enc}" \
                                --header "${header_con}" \
                                --connect-timeout "${connection_timeout}" \
                                --proto -all,+http,+https \
                                --no-sessionid \
                                --ipv4 \
                                --max-redirs "${max_redirects}" \
                                --socks5-hostname "${socks_ip}":"${socks_port}" \
                                --create-dirs \
                                --silent \
                                "$1" \
                                --output "${page_on_disk}".gz

### PROCESS DATA ###

# Set read and execute permissions on website directory
sudo -n -u "${fetch_user}" chmod o+rx /home/"${fetch_user}"/"${domain_only}"

# Check whether the file is in gzip or html format
if file --brief "${page_on_disk}".gz | grep --quiet "^gzip"; then
  sudo -n -u "${fetch_user}" gunzip --force "${page_on_disk}".gz
  # Check if decompressed file is in html format
  if ! file --brief "${page_on_disk}" | grep --quiet "^HTML"; then
    echo ""
    echo "This file type is currently not supported."
    echo ""
    exit 0
  fi
elif file --brief "${page_on_disk}".gz | grep --quiet "^HTML"; then
  sudo -n -u "${fetch_user}" mv "${page_on_disk}".gz "${page_on_disk}"
else
  echo ""
  echo "This file type is currently not supported."
  echo ""
  exit 0
fi

# Open file with browser as the 'browser_user'
sudo -n -u "${browser_user}" "${browser}" "${page_on_disk}" &>/dev/null &
