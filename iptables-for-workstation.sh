echo "*filter"                                                                           >  /etc/iptables/iptables.rules
echo ":INPUT DROP [0:0]"                                                                 >> /etc/iptables/iptables.rules
echo ":FORWARD DROP [0:0]"                                                               >> /etc/iptables/iptables.rules
echo ":OUTPUT ACCEPT [0:0]"                                                              >> /etc/iptables/iptables.rules
echo ":TCP - [0:0]"                                                                      >> /etc/iptables/iptables.rules
echo ":UDP - [0:0]"                                                                      >> /etc/iptables/iptables.rules
echo "-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                     >> /etc/iptables/iptables.rules
echo "-A INPUT -i lo -j ACCEPT"                                                          >> /etc/iptables/iptables.rules
echo "-A INPUT -m conntrack --ctstate INVALID -j DROP"                                   >> /etc/iptables/iptables.rules
echo "-A INPUT -p udp -m conntrack --ctstate NEW -j UDP"                                 >> /etc/iptables/iptables.rules
echo "-A INPUT -p tcp --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j TCP" >> /etc/iptables/iptables.rules
echo "-A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable"                     >> /etc/iptables/iptables.rules
echo "-A INPUT -p tcp -j REJECT --reject-with tcp-reset"                                 >> /etc/iptables/iptables.rules
echo "-A INPUT -j REJECT --reject-with icmp-proto-unreachable"                           >> /etc/iptables/iptables.rules
echo "COMMIT"                                                                            >> /etc/iptables.rules

iptables-restore /etc/iptables/iptables.rules
iptables -nvL
