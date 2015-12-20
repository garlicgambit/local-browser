# Local Browser

## What does it do
* Browse websites with a browser which has no network access

## What can I do with it
* Open a webpage with your favorite browser and be sure that your browser will not leak any data to the web. This can improve your privacy and security without making any modifications to the browser.

## Project goals
* Prevent the browser from leaking any data to the web
* Make it simple to open a 'local' website with your favorite browser
* Automate/schedule fetching websites
* Protect against website usage patterns
* Make it decently secure out of the box (caveat emptor)

## Design
* A dedicated tool is used to download the website data
* A browser is used to process the website data
* Separate locked down user accounts are used to fetch and process the website data
* A firewall is used to block network access for the user account that uses the browser
* The Tor Browser user agent is used when downloading website data
* Works with Tor and other proxies
* Simple tools are used to minimize the attack surface

## Software
* Curl is used to fetch websites
* Sudo is used to switch between user accounts without a password prompt
* Iptables is used as the firewall
* A browser of your choice: Firefox, Chrome, Lynx, etc
* Optional: Tor is used to create anonymous connections

## OS support
* Debian and Ubuntu based Linux distributions

## License
* Consider the code to be public domain. If you or your jurisdiction do not accept that then consider the code to be released under Creative Commons 0 (CC0). If you or your jurisdiction do not accept that... well then settle for the MIT license. What we mean to say is that you are free to copy, modify and relicense the code by all means. But don't hold us liable for any damages incurred by using or abusing the software.
* Code which is copied from other projects remains under the original license.

## General security notes
* For increased security it is recommended to run it with a non-graphical browser to prevent Xorg from leaking data between users.
* For increased security it is recommended to run it with a security focused browser like the Tor Browser or better.
* For maximum security it is recommended to run it on a dedicated device.

## General privacy notes
* For increased privacy it is recommended to use a VPN or a proxy like Tor.

## Tor support/tips
* Some scripts support Tor out of the box. These scripts will use socksport 9050. If you already use Tor port 9050 for your normal web traffic and you want to separate that from Local Browser traffic then you should set the Local Browser scripts to use a different Tor socksport.
* Use the 'IsolateDestAddr' option with the Tor socksport for increased traffic isolation.

## Known issues
* The contents of the .Xauthority file changes on system reboot. So after a reboot the file needs to be copied from the regular Xorg user to the 'browserusergui' user.

## How to install Local Browser
1. Install git
    ```
    sudo apt-get update 
    sudo apt-get install git -y
    ```

2. Clone the git repository
    ```
    git clone https://github.com/garlicgambit/local-browser.git
    ```

## How to use Local Browser with Iceweasel/Firefox
1. Run config-gui.sh as root
    ```
    sudo ./config-gui.sh
    ```

2. Configure the iptables firewall with the output from config-gui.sh
    Every firewall configuration is different. So no standard answer is possible here.
    You have to figure out how to integrate the iptables rules in your current iptables configuration.

3. Open a website (you need to use 'http://' or 'https://' as a prefix for the website and use a trailling '/' )
    ```
    ./fetch-gui.sh https://www.example.com/
    ```

    Or preferably with quotes '' around the url:
    ```
    ./fetch-gui.sh 'https://www.example.com/'
    ```

4. Your browser should automatically open the webpage

## How to use Local Browser with Iceweasel/Firefox and Tor
1. Run config-gui-tor.sh as root
    ```
    sudo ./config-gui-tor.sh
    ```

2. Configure the local iptables firewall with the output from config-gui-tor.sh
    Every firewall configuration is different. So no standard answer is possible here.
    You have to figure out how to integrate the iptables rules in your current iptables configuration.

3. Open a website (prefix the website with a 'http://' or 'https://' and use a trailling slash '/' )
    ```
    ./fetch-gui-tor.sh https://www.example.com/
    ```

    Or preferably with quotes '' around the url:
    ```
    ./fetch-gui-tor.sh 'https://www.example.com/'
    ```

4. Your browser should automatically open the webpage

## How to use Local Browser with the non-grahical Lynx browser
1. Run config-non-gui.sh as root
    ```
    sudo ./config-non-gui.sh
    ```

2. Configure the local iptables firewall with the output from config-non-gui.sh
    Every firewall configuration is different. So no standard answer is possible here.
    You have to figure out how to integrate the iptables rules in your current iptables configuration.

3. Open a website (you need to use 'http://' or 'https://' as a prefix for the website and use a trailling '/' )
    ```
    ./fetch-non-gui.sh https://www.example.com/
    ```

    Or preferably with quotes '' around the url:
    ```
    ./fetch-gui.sh 'https://www.example.com/'
    ```

4. Your browser should automatically open the webpage

## How to use your favorite browser with Local Browser
1. Determine whether your browser is a graphical browser or not

2. Then determine whether you want to use Tor or not

3. Pick the correct files to edit based on the answers above

    Examples:
    If you want to use the graphical browser Chromium with Tor you need to edit:
    config-gui-tor.sh and fetch-gui-tor.sh

    If you want to use the non-graphical browser w3m without Tor you need to edit:
    config-non-gui.sh and fetch-non-gui.sh

4. Edit the two files with your favorite editor (nano used here)
    Example:
    ```
    nano config-gui-tor.sh
    nano fetch-gui-tor.sh
    ```

5. Look for the line with 'browser=....' in both files
    Change:
    browser=....

    To your favorite browser name:
    browser=chromium

    Example:

    From:
    ```
    browser=iceweasel
    ```
    To:
    ```
    browser=chromium
    ```

6. Save the file with nano
    Control x
    Save modified buffer: 'y'

7. You can now follow the normal configuration steps described in the other sections above

## Warning
* Use this project with caution, no guarantees that this will work in your situation.
* Every time your device connects to another device there is a chance of infection or compromise.

## Support this project
Bitcoin:
1LcxqboFReeGQjDyX5cvt4KGpABSF9ai2V

Monero:
463DQj1ebHSWrsyuFTfHSTDaACx3WZtmMFMwb6QEX7asGyUBaRe2fHbhMchpZnaQ6XKXcHZLq8Vt1BRSLpbqdr283QinCRK
