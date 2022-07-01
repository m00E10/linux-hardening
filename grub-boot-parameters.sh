#!/bin/bash

################################################################################
# Updates /etc/default/grub to include settings useful for system hardening    #
# Below you will find available settings commented and what they do            #
################################################################################

# Included. Disables slab merging, mitigates heap exploitation
# slab_nomerge

# Included. Zeros memory during allocation and free time, mitigates use-after-free xploits
# init_on_alloc=1
# init_on_free=1

# Included. Randomises page allocate freelists, improves security and performance
# page_alloc.shuffle=1

# Included. Enables Kernel Page Table Isolation, mitigates Meltodwn and some KASLR bypass
# randomize_kstack_offset=on

# Included. Disables vsyscalls, which are obsolete, mitigates ROP attacks
# vsyscall=none

# Included. Disables debugfs, mitigates kernel information leaks
# debugfs=off

# NOT Included. If a kernel exploit causes an "oops", crash the kernel instead of letting the
# exploit run. (SOME DRIVERS CAUSE HARMLESS OOPS, BE CAREFUL)
# oops=panic

# Included. Doesn't load kernel modules that have not been signed. Prevents malicious
# kernel module loading (but also prevents VirtualBox modules from loading)
# module.sig_enforce=1

# Included. Implements a clear security boundary between user space and kernel space.
# Prevents many PE vectors and information leaks
# lockdown=confidentiality

# NOT Included. Causes the kernel to panic on uncorrectable memory errors which could be
# exploited. (ONLY RELEVANT FOR SYSTEMS WITH ECC RAM, BE CAREFUL)
# mce=0

# NOT Included. Prevent information leaks during boot (excessive imo)
# quiet loglevel=0

# Included. Flat out disables the whole IPv6 stack. Simplifies firewall and (generally)
# network management
# ipv6.disable=1

function choose_microcode {
	if [ $(lscpu | grep Vendor | grep AMD | wc -l) -eq 1 ]; then
		pacman -Sy amd-ucode
	elif [ $(lscpu | grep Vendor | grep Intel | wc -l) -eq 1]; then
		pacman -Sy intel-ucode
	fi
}

function cpu_mitigations {
	if [ $(grep . /sys/devices/system/cpu/vulnerabilities/tsx_async_abort | grep Vulnerable | wc -l) -eq 1]; then
		mitigations="$mitigations tsx=off tsx_async_abort=full,nosmt"
	fi

	if [ $(grep . /sys/devices/system/cpu/vulnerabilities/mds | grep Vulnerable | wc -l) -eq 1]; then
		mitigations="$mitigations mds=full,nosmt"
	fi
	
	if [ $(grep . /sys/devices/system/cpu/vulnerabilities/spectre_v2 | grep Vulnerable | wc -l) -eq 1]; then
		mitigations="$mitigations spectre_v2=on"
	fi

	if [ $(grep . /sys/devices/system/cpu/vulnerabilities/spec_store_bypass | grep Vulnerable | wc -l) -eq 1]; then
		mitigations="$mitigations spec_store_bypass_disable=on"
	fi

	if [ $(grep . /sys/devices/system/cpu/vulnerabilities/l1tf | grep Vulnerable | wc -l) -eq 1]; then
		mitigations="$mitigations l1tf=full,force"
	fi
	
}

choose_microcode
cpu_mitigations
sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"[^\"]*/& slab_nomerge init_on_alloc=1 init_on_free=1 page_alloc.shuffle=1 randomize_kstack_offset=on vsyscall=none debugfs=off module.sig_enforce=1 lockdown=confidentiality ipv6.disable=1 $mitigations/" /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
