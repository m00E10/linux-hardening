#!/bin/bash

################################################################################
# READ THROUGH THE WHOLE FILE BEFORE RUNNING. Some settings may disable things #
# you actually want enabled (such as bluetooth), or you may wish to enable     #
# some settings that are commented out.                                        #
#                                                                              #
# Settings sourced from madaidans linux hardening guide                        #
# If you want more info regarding the settings used ctrl+f for them here:      #
# https://madaidans-insecurities.github.io/guides/linux-hardening.html#sysctl  #
################################################################################

user=your_daily_user_here

################################################################################
###                   IN THIS SECTION WE HARDEN THE KERNEL                   ###
################################################################################

# Hides kernel pointers, mitigates kernel pointer leaks
echo "kernel.kptr_restrict=2"                                >> /etc/sysctl.conf

# Further restricts access to kernel logs (dmesg)
echo "kernel.dmesg_restrict=1"                               >> /etc/sysctl.conf

# Prevents applications from viewing the boot-up kernel log
# Needs "quiet loglevel=0" set as a boot parameter or this will not work
#echo "kernel.printk=3 3 3 3"                                 >> /etc/sysctl.conf

# Restricts eBPF and enables JIT hardening techniques
echo "kernel.unprivileged_bpf_disabled=1"                    >> /etc/sysctl.conf
echo "net.core.bpf_jit_harden=2"                             >> /etc/sysctl.conf

# Prevents unprivileged users from loading line disciplines
echo "dev.tty.ldisc_autoload=0"                              >> /etc/sysctl.conf

# userfaultfd is often used in use-after-free exploits, so we restrict the call
echo "vm.unprivileged_userfaultfd=0"                         >> /etc/sysctl.conf

# Prevents another kernel from being loaded during runtime
echo "kernel.kexec_load_disabled=1"                          >> /etc/sysctl.conf

# Disable SysRq, which exposes (potentially dangerous) debugging info
echo "kernel.sysrq=0"                                        >> /etc/sysctl.conf

# Disables unprivileged namespaces. (Sorry you'll have to use bubblewrap-suid)
echo "kernel.unprivileged_userns_clone=0"                    >> /etc/sysctl.conf

# Disables ALL namespaces including for root. Not even bubblewrap-suid will work
#echo "user.max_user_namespaces=0"                            >> /etc/sysctl.conf

# Restricts kernel events, such as performance events.
echo "kernel.perf_event_paranoid=3"                          >> /etc/sysctl.conf

# Disable core dumps, which can contain sensitive information
echo "kernel.core_pattern=|/bin/false"                       >> /etc/sysctl.conf
echo "fs.suid_dumpable=0"                                    >> /etc/sysctl.conf

# Disable usage of swap space unless absolutely necessary
#vm.swappiness=1                                              >> /etc/sysctl.conf

################################################################################
###              IN THIS SECTION WE HARDEN THE NETWORK STACK                 ###
################################################################################

# Disable tcp timestamps which can leak system time
echo "net.ipv4.tcp_timestamps=0"                             >> /etc/sysctl.conf

# Protects against SYN flood attacks
echo "net.ipv4.tcp_syncookies=1"                             >> /etc/sysctl.conf

# Protects against time-wait assassination attacks
echo "net.ipv4.tcp_rfc1337=1"                                >> /etc/sysctl.conf

# Protects against IP spoofing by validating the source of all packets
echo "net.ipv4.conf.all.rp_filter=1"                         >> /etc/sysctl.conf
echo "net.ipv4.conf.default.rp_filter=1"                     >> /etc/sysctl.conf

# Disable ICMP redirect acceptance/sending, preventing MiTM & info disclosure
echo "net.ipv4.conf.all.accept_redirects=0"                  >> /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_redirects=0"              >> /etc/sysctl.conf
echo "net.ipv4.conf.all.secure_redirects=0"                  >> /etc/sysctl.conf
echo "net.ipv4.conf.default.secure_redirects=0"              >> /etc/sysctl.conf
echo "net.ipv6.conf.all.accept_redirects=0"                  >> /etc/sysctl.conf
echo "net.ipv6.conf.default.accept_redirects=0"              >> /etc/sysctl.conf
echo "net.ipv4.conf.all.send_redirects=0"                    >> /etc/sysctl.conf
echo "net.ipv4.conf.default.send_redirects=0"                >> /etc/sysctl.conf

# Ignore all ICMP requests, prevents Smurf attacks, clock fingerprinting, and
# generally makes your system harder to find on a network (will be hidden from
# ping sweeps)
echo "net.ipv4.icmp_echo_ignore_all=1"                       >> /etc/sysctl.conf

# Disables source routing which could be used for MiTM attacks
echo "net.ipv4.conf.all.accept_source_route=0"               >> /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_source_route=0"           >> /etc/sysctl.conf
echo "net.ipv6.conf.all.accept_source_route=0"               >> /etc/sysctl.conf
echo "net.ipv6.conf.default.accept_source_route=0"           >> /etc/sysctl.conf

# Disables IPv6 router advertisements which could be used for MiTM attacks
echo "net.ipv6.conf.all.accept_ra=0"                         >> /etc/sysctl.conf
echo "net.ipv6.conf.default.accept_ra=0"                     >> /etc/sysctl.conf

# Disables TCP SACK, which is commonly exploited but usually unecessary
echo "net.ipv4.tcp_sack=0"                                   >> /etc/sysctl.conf
echo "net.ipv4.tcp_dsack=0"                                  >> /etc/sysctl.conf
echo "net.ipv4.tcp_fack=0"                                   >> /etc/sysctl.conf

################################################################################
###                   IN THIS SECTION WE HARDEN USERSPACE                    ###
################################################################################

# Disable ptrace, which can be used to alter and inspect running processes
echo "kernel.yama.ptrace_scope=3"                            >> /etc/sysctl.conf

# Increases the bits of entropy used for ASLR
echo "vm.mmap_rnd_bits=32"                                   >> /etc/sysctl.conf
echo "vm.mmap_rnd_compat_bits=16"                            >> /etc/sysctl.conf

# Prevents symlinks from being followed if placed inside a world-writable sticky
# directory. Prevents hardlinks from being created by users that dont have rw to
# the source file. These together prevent many TOCTOU races.
echo "fs.protected_symlinks=1"                               >> /etc/sysctl.conf
echo "fs.protected_hardlinks=1"                              >> /etc/sysctl.conf

# Disallows opening of FIFOs / files in world-writable stickly directories that
# ARENT owned by the user. This makes data spoofing attacks harder.
echo "fs.protected_fifos=2"                                  >> /etc/sysctl.conf
echo "fs.protected_regular=2"                                >> /etc/sysctl.conf


################################################################################
###           IN THIS SECTION WE BLACKLIST OBSCURE KERNEL MODULES            ###
################################################################################

# Blacklisting obscure network protocols
echo "install dccp /bin/false"                               >> /etc/sysctl.conf
echo "install sctp /bin/false"                               >> /etc/sysctl.conf
echo "install rds /bin/false"                                >> /etc/sysctl.conf
echo "install tipc /bin/false"                               >> /etc/sysctl.conf
echo "install n-hdlc /bin/false"                             >> /etc/sysctl.conf
echo "install ax25 /bin/false"                               >> /etc/sysctl.conf
echo "install netrom /bin/false"                             >> /etc/sysctl.conf
echo "install x25 /bin/false"                                >> /etc/sysctl.conf
echo "install rose /bin/false"                               >> /etc/sysctl.conf
echo "install decnet /bin/false"                             >> /etc/sysctl.conf
echo "install econet /bin/false"                             >> /etc/sysctl.conf
echo "install af_802154 /bin/false"                          >> /etc/sysctl.conf
echo "install ipx /bin/false"                                >> /etc/sysctl.conf
echo "install appletalk /bin/false"                          >> /etc/sysctl.conf
echo "install psnap /bin/false"                              >> /etc/sysctl.conf
echo "install p8023 /bin/false"                              >> /etc/sysctl.conf
echo "install p8022 /bin/false"                              >> /etc/sysctl.conf
echo "install can /bin/false"                                >> /etc/sysctl.conf
echo "install atm /bin/false"                                >> /etc/sysctl.conf

# Blacklisting obscure filesystems
echo "install cramfs /bin/false"                             >> /etc/sysctl.conf
echo "install freevxfs /bin/false"                           >> /etc/sysctl.conf
echo "install jffs2 /bin/false"                              >> /etc/sysctl.conf
echo "install hfs /bin/false"                                >> /etc/sysctl.conf
echo "install hfsplus /bin/false"                            >> /etc/sysctl.conf
echo "install squashfs /bin/false"                           >> /etc/sysctl.conf
echo "install udf /bin/false"                                >> /etc/sysctl.conf

# Blacklisting obscure network filesystems
echo "install cifs /bin/true"                                >> /etc/sysctl.conf
echo "install nfs /bin/true"                                 >> /etc/sysctl.conf
echo "install nfsv3 /bin/true"                               >> /etc/sysctl.conf
echo "install nfsv4 /bin/true"                               >> /etc/sysctl.conf
echo "install gfs2 /bin/true"                                >> /etc/sysctl.conf

# Disables vivid which is only useful for testing and has been the cause of PE's
echo "install vivid /bin/false"                              >> /etc/sysctl.conf

# Disable bluetooth if you don't have/use it.
echo "install bluetooth /bin/false"                          >> /etc/sysctl.conf
echo "install btusb /bin/false"                              >> /etc/sysctl.conf

# Disables webcam if you don't have/use it.
echo "install uvcvideo /bin/false"                           >> /etc/sysctl.conf
