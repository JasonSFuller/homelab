#!/bin/bash

# PURPOSE: Bootstrap a RHEL 9 host with just enough to prep for automation (or
#   troubleshoot if things go wrong).  Primarily intended for use in a kickstart
#   but should work elsewhere too.
# USAGE: curl -sfL http://192.168.123.2/ks/rhel9.sh | bash

GITHUB_USERNAME='jasonsfuller'

# Install my Github SSH keys.  https://github.com/settings/keys
install -o root -g root -m 0750 -d /root/.ssh
install -o root -g root -m 0640 \
  <(curl -sfL "https://github.com/${GITHUB_USERNAME}.keys") \
  /root/.ssh/authorized_keys

# I want to see text/boot messages and not the Red Hat graphical boot (rhgb).
# Also, disable the screensaver because it isn't necessary for VMs (and annoying
# while testing).
sed -i -r 's/rhgb quiet/consoleblank=0/' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

# The hostname, IP, distro, etc. is helpful, so show them on the console.
# NOTE: See `man agetty` for more detail and `agetty --show-issue` to render
#   /etc/issue in your terminal (or CTRL+D on the console).  Originally, I tried
#   "old skewl" ANSI codepage characters, but they don't display properly on
#   modern terminals (neither in the console or in emulators like gnome-terminal
#   or PuTTY).  The characters below are UTF-8 block elements.
cat << EOF > /etc/issue
$(tput clear)
    \e{red}       ▄▄███████▄▄       \e{reset}
    \e{red}    ▄███████████████▄    \e{reset}        ███         ███▀▀                ███ ▄▄▄
    \e{red}  ▄████▀▀███████▀▀████▄  \e{reset}    ███▀███ ███▀███ ███  ███▀███ ███ ███ ███ ███▀
    \e{red} ▄███▀    ▀███▀    ▀███▄ \e{reset}    ███ ███ ███▄███ ███▄ ▄▄▄▄███ ███ ███ ███ ███
    \e{red}▄████▄      ▀      ▄████▄\e{reset}    ███ ███ ███ ▄▄▄ ███  ███ ███ ███ ███ ███ ███
    \e{red}███████▄         ▄███████\e{reset}    ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀ ▀▀▀  ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀ ▀▀▀ ▀▀▀▀
    \e{red}████████▀       ▀████████\e{reset}                            ███▀ ▀▀▀
    \e{red}██████▀           ▀██████\e{reset}    ███▀███ ███▀███ ███▀███ ███  ███ ███▀███
    \e{red} ████      ▄█▄      ████ \e{reset}    ███ ▀▀▀ ███ ███ ███ ███ ███▄ ███ ███ ███
    \e{red}  ████▄  ▄█████▄  ▄████  \e{reset}    ███ ███ ███ ███ ███ ███ ███  ███ ███ ███
    \e{red}   ▀█████████████████▀   \e{reset}    ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀ ▀▀▀ ▀▀▀ ▀▀▀  ▀▀▀ ▀▀▀▀███
    \e{red}     ▀▀███████████▀▀     \e{reset}                                     ▀▀▀▀▀▀▀
    \e{red}         ▀▀▀▀▀▀▀         \e{reset}    \e{green}\e{bold}\n\e{reset}
                                 \e{green}\4\e{reset}
      DEFAULT CONFIGURATION      \S
                                 \e{darkgray}\r (\m)\e{reset}
      Complete setup before      \e{darkgray}\d \t\e{reset}
      using this machine!!!      \e{darkgray}\U logged in\e{reset}


EOF
