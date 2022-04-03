#!/bin/bash

user=your_daily_user_here

echo "kernel.kptr_restrict=2"                                >> /etc/sysctl.conf
echo "kernel.dmesg_restrict=1"                               >> /etc/sysctl.conf
echo "kernel.printk=3 3 3 3"                                 >> /etc/sysctl.conf
echo "kernel.unprivileged_bpf_disabled=1"                    >> /etc/sysctl.conf
echo "net.core.bpf_jit_harden=2"                             >> /etc/sysctl.conf
echo "dev.tty.ldisc_autoload=0"                              >> /etc/sysctl.conf
echo "vm.unprivileged_userfaultfd=0"                         >> /etc/sysctl.conf
echo "kernel.kexec_load_disabled=1"                          >> /etc/sysctl.conf
echo "kernel.sysrq=4"                                        >> /etc/sysctl.conf
echo "kernel.unprivileged_userns_clone=0"                    >> /etc/sysctl.conf
echo "user.max_user_namespaces=0"                            >> /etc/sysctl.conf
echo "net.ipv4.tcp_timestamps=0"                             >> /etc/sysctl.conf
echo "net.ipv4.tcp_syncookies=1"                             >> /etc/sysctl.conf
echo "net.ipv4.tcp_rfc1337=1"                                >> /etc/sysctl.conf
echo "net.ipv4.conf.all.rp_filter=1"                         >> /etc/sysctl.conf
echo "net.ipv4.conf.default.rp_filter=1"                     >> /etc/sysctl.conf
echo "net.ipv4.conf.all.accept_redirects=0"                  >> /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_redirects=0"              >> /etc/sysctl.conf
echo "net.ipv4.conf.all.secure_redirects=0"                  >> /etc/sysctl.conf
echo "net.ipv4.conf.default.secure_redirects=0"              >> /etc/sysctl.conf
echo "net.ipv6.conf.all.accept_redirects=0"                  >> /etc/sysctl.conf
echo "net.ipv6.conf.default.accept_redirects=0"              >> /etc/sysctl.conf
echo "net.ipv4.conf.all.send_redirects=0"                    >> /etc/sysctl.conf
echo "net.ipv4.conf.default.send_redirects=0"                >> /etc/sysctl.conf
echo "net.ipv4.icmp_echo_ignore_all=1"                       >> /etc/sysctl.conf
echo "net.ipv4.conf.all.accept_source_route=0"               >> /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_source_route=0"           >> /etc/sysctl.conf
echo "net.ipv6.conf.all.accept_source_route=0"               >> /etc/sysctl.conf
echo "net.ipv6.conf.default.accept_source_route=0"           >> /etc/sysctl.conf
echo "net.ipv6.conf.all.accept_ra=0"                         >> /etc/sysctl.conf
echo "net.ipv6.conf.default.accept_ra=0"                     >> /etc/sysctl.conf
echo "net.ipv4.tcp_sack=0"                                   >> /etc/sysctl.conf
echo "net.ipv4.tcp_dsack=0"                                  >> /etc/sysctl.conf
echo "net.ipv4.tcp_fack=0"                                   >> /etc/sysctl.conf
echo "kernel.yama.ptrace_scope=3"                            >> /etc/sysctl.conf
echo "vm.mmap_rnd_bits=32"                                   >> /etc/sysctl.conf
echo "vm.mmap_rnd_compat_bits=16"                            >> /etc/sysctl.conf
echo "fs.protected_symlinks=1"                               >> /etc/sysctl.conf
echo "fs.protected_hardlinks=1"                              >> /etc/sysctl.conf
echo "fs.protected_fifos=2"                                  >> /etc/sysctl.conf
echo "fs.protected_regular=2"                                >> /etc/sysctl.conf
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
echo "install cramfs /bin/false"                             >> /etc/sysctl.conf
echo "install freevxfs /bin/false"                           >> /etc/sysctl.conf
echo "install jffs2 /bin/false"                              >> /etc/sysctl.conf
echo "install hfs /bin/false"                                >> /etc/sysctl.conf
echo "install hfsplus /bin/false"                            >> /etc/sysctl.conf
echo "install squashfs /bin/false"                           >> /etc/sysctl.conf
echo "install udf /bin/false"                                >> /etc/sysctl.conf
echo "install cifs /bin/true"                                >> /etc/sysctl.conf
echo "install nfs /bin/true"                                 >> /etc/sysctl.conf
echo "install nfsv3 /bin/true"                               >> /etc/sysctl.conf
echo "install nfsv4 /bin/true"                               >> /etc/sysctl.conf
echo "install gfs2 /bin/true"                                >> /etc/sysctl.conf
echo "install vivid /bin/false"                              >> /etc/sysctl.conf
echo "install bluetooth /bin/false"                          >> /etc/sysctl.conf
echo "install btusb /bin/false"                              >> /etc/sysctl.conf
echo "install uvcvideo /bin/false"                           >> /etc/sysctl.conf
echo "kernel.core_pattern=|/bin/false"                       >> /etc/sysctl.conf
echo "fs.suid_dumpable=0"                                    >> /etc/sysctl.conf
