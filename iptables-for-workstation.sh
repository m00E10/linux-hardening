#!/bin/bash

################################################################################
# Rules sourced from the "Simple Stateful Firewall" article on the ArchWiki    #
# https://wiki.archlinux.org/title/simple_stateful_firewall                    #
################################################################################

echo "*filter"                                                                           >  /etc/iptables/iptables.rules

# Drop all Input traffic by default
echo ":INPUT DROP [0:0]"                                                                 >> /etc/iptables/iptables.rules

# Drop all forward traffic by default, we are not a router
echo ":FORWARD DROP [0:0]"                                                               >> /etc/iptables/iptables.rules

# Accept output traffic by default
echo ":OUTPUT ACCEPT [0:0]"                                                              >> /etc/iptables/iptables.rules

echo ":TCP - [0:0]"                                                                      >> /etc/iptables/iptables.rules
echo ":UDP - [0:0]"                                                                      >> /etc/iptables/iptables.rules

# Allow traffic that belongs to established, or related connections
echo "-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"                     >> /etc/iptables/iptables.rules

# Accept traffic from the loopback interface
echo "-A INPUT -i lo -j ACCEPT"                                                          >> /etc/iptables/iptables.rules

# Drop traffic with invalid headers/checksums/flags/messages
echo "-A INPUT -m conntrack --ctstate INVALID -j DROP"                                   >> /etc/iptables/iptables.rules

echo "-A INPUT -p udp -m conntrack --ctstate NEW -j UDP"                                 >> /etc/iptables/iptables.rules
echo "-A INPUT -p tcp --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j TCP" >> /etc/iptables/iptables.rules

# Reject UDP streams with port unreachable (default behavior)
echo "-A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable"                     >> /etc/iptables/iptables.rules

# Reject TCP traffic with TCP RESET
echo "-A INPUT -p tcp -j REJECT --reject-with tcp-reset"                                 >> /etc/iptables/iptables.rules

# Reject all remaining traffic with ICMP PROTO UNREACHABLE (default behavior)
echo "-A INPUT -j REJECT --reject-with icmp-proto-unreachable"                           >> /etc/iptables/iptables.rules
echo "COMMIT"                                                                            >> /etc/iptables/iptables.rules

iptables-restore /etc/iptables/iptables.rules
iptables -nvL
