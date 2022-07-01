#!/bin/bash

sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& lsm=landlock,lockdown,yama,apparmor,bpf audit=1/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
pacman -Syu apparmor apparmor-openrc audit audit-openrc
rc-update add apparmor default
rc-update add auditd default

echo ""
echo "Reboot, then"
echo "# apparmor_parser /usr/share/apparmor/extra-profiles/"
echo ""
echo "Additional profiles can be found from krathalans apparmor profiles on github"
