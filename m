Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbYEGNvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbYEGNvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 09:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbYEGNvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 09:51:18 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:45780 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbYEGNvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 09:51:03 -0400
Date: Wed, 7 May 2008 15:42:23 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: Bernhard Walle <bwalle@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Solid freezes with 2.6.25
Message-ID: <20080507134223.GB4278@boogie.lpds.sztaki.hu>
References: <20080428142935.GQ14074@boogie.lpds.sztaki.hu> <20080428092513.495378af.akpm@linux-foundation.org> <20080429175419.6c8a0ebf@strauss.suse.de> <20080430133824.GC18711@boogie.lpds.sztaki.hu> <20080430165131.7426d5d3@strauss.suse.de> <20080507114343.GB5583@boogie.lpds.sztaki.hu> <20080507144520.17e9902a@strauss.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507144520.17e9902a@strauss.suse.de>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 02:45:20PM +0200, Bernhard Walle wrote:

> You can log it to a file or output it over serial console. Or make the
> window sticky. ;)

Well, the machine hung and I was on a different virtual desktop. The
output of the script together with netconsole output is below. Right now
I don't have another machine that could be used for serial console.

Gabor

Script output:
--------------

0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
62
64
3
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
37
65
27
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
52
65
11
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
36
64
29
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
37
70
22
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
66
62
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
60
69
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
51
70
8
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
24

(I suppose the end of the output was still in memory buffers when the
hang occured so...)

netconsole:
-----------

Initializing cgroup subsys cpuset
Linux version 2.6.25 (gombasg@boogie) (gcc version 4.2.3 (Debian 4.2.3-5)) #1 SMP Mon May 5 19:34:43 CEST 2008
Command line: BOOT_IMAGE=l2625 ro root=900 video=intelfb:1280x1024-16@60 resume=/dev/sda2 selinux=1 audit=1 nmi_watchdog=2
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cf2ac000 (usable)
 BIOS-e820: 00000000cf2ac000 - 00000000cf2ef000 (ACPI NVS)
 BIOS-e820: 00000000cf2ef000 - 00000000cf3c7000 (reserved)
 BIOS-e820: 00000000cf3c7000 - 00000000cf3d7000 (ACPI NVS)
 BIOS-e820: 00000000cf3d7000 - 00000000cf453000 (reserved)
 BIOS-e820: 00000000cf453000 - 00000000cf459000 (ACPI data)
 BIOS-e820: 00000000cf459000 - 00000000cf45a000 (ACPI NVS)
 BIOS-e820: 00000000cf45a000 - 00000000cf45c000 (ACPI data)
 BIOS-e820: 00000000cf45c000 - 00000000cf45d000 (ACPI NVS)
 BIOS-e820: 00000000cf45d000 - 00000000cf45e000 (reserved)
 BIOS-e820: 00000000cf45e000 - 00000000cf463000 (ACPI NVS)
 BIOS-e820: 00000000cf463000 - 00000000cf472000 (reserved)
 BIOS-e820: 00000000cf472000 - 00000000cf600000 (usable)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000ffa00000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
end_pfn_map = 1245184
DMI 2.4 present.
ACPI: RSDP 000F03C0, 0024 (r2  INTEL)
ACPI: XSDT CF45AF10, 0044 (r1  INTEL   DG31PR  6222004 MSFT    10013)
ACPI: FACP CF458D90, 00F4 (r4  INTEL   DG31PR  6222004 MSFT    10013)
ACPI: DSDT CF453010, 4D33 (r1  INTEL   DG31PR        0 INTL 20051117)
ACPI: FACS CF459F40, 0040
ACPI: APIC CF458F10, 006C (r2  INTEL   DG31PR  6222004 MSFT    10013)
ACPI: HPET CF461D10, 0038 (r1  INTEL ICH7HPET  6222004 AMI.        1)
ACPI: MCFG CF461C10, 003C (r1 INTEL  DG31PR    6222004 MSFT       97)
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-6bc61b] TEXT DATA BSS
early res: 3 [9fc00-a0bff] EBDA
early res: 4 [8000-dfff] PGTABLE
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1245184
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0:        0 ->      159
    0:      256 ->   848556
    0:   849010 ->   849408
    0:  1048576 ->  1245184
ACPI: PM-Timer IO Port: 0x408
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] disabled)
ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at d0000000 (gap: cf600000:2f71c000)
SMP: Allowing 4 CPUs, 2 hotplug CPUs
PERCPU: Allocating 34112 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1024785
Kernel command line: BOOT_IMAGE=l2625 ro root=900 video=intelfb:1280x1024-16@60 resume=/dev/sda2 selinux=1 audit=1 nmi_watchdog=2
audit: enabled (after initialization)
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
time.c: Detected 2199.953 MHz processor.
Console: colour VGA+ 80x50
console [tty0] enabled
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0xae21000 - 0xee21000
Memory: 4025872k/4980736k available (2717k kernel code, 155356k reserved, 1280k data, 248k init)
SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
Calibrating delay using timer specific routine.. 4403.17 BogoMIPS (lpj=8806355)
Security Framework initialized
SELinux:  Initializing.
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20070126
Using local APIC timer interrupts.
Detected 12.499 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4399.88 BogoMIPS (lpj=8799774)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Pentium(R) Dual  CPU  E2200  @ 2.20GHz stepping 0d
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Testing NMI watchdog ... OK.
net_namespace: 1016 bytes
xor: automatically using best checksumming function: generic_sse
   generic_sse:  8056.000 MB/sec
xor: using function: generic_sse (8056.000 MB/sec)
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: BIOS _OSI(Linux) query ignored
ACPI: DMI System Vendor:         
ACPI: DMI Product Name:         
ACPI: DMI Product Version:         
ACPI: DMI Board Name: DG31PR
ACPI: DMI BIOS Vendor: Intel Corp.
ACPI: DMI BIOS Date: 02/27/2008
ACPI: Please send DMI info above to linux-acpi@vger.kernel.org
ACPI: If "acpi_osi=Linux" works better, please notify linux-acpi@vger.kernel.org
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
system 00:01: iomem range 0xe0000000-0xe3ffffff has been reserved
system 00:02: ioport range 0x400-0x47f has been reserved
system 00:02: ioport range 0x1180-0x119f has been reserved
system 00:02: ioport range 0x500-0x53f has been reserved
system 00:02: iomem range 0xfec00000-0xfecfffff has been reserved
system 00:02: iomem range 0xfee00000-0xfee0ffff could not be reserved
system 00:02: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:02: iomem range 0xffb00000-0xffcfffff could not be reserved
system 00:02: iomem range 0xfc800000-0xfc800fff has been reserved
system 00:02: iomem range 0xfed20000-0xfed7ffff has been reserved
system 00:02: iomem range 0xffe00000-0xffffffff could not be reserved
system 00:03: ioport range 0x290-0x29f has been reserved
system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: e000-efff
  MEM window: 0xff800000-0xff8fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: d000-dfff
  MEM window: 0xff700000-0xff7fffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
audit: initializing netlink socket (enabled)
type=2000 audit(1210159066.436:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
async_tx: api initialized (sync-only)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
ACPI: Sleep Button (CM) [SLPB]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
ACPI: Power Button (CM) [PWRB]
ACPI: SSDT CF45EC10, 02CC (r1    AMI      IST        1 MSFT  3000001)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:01 is registered as cooling_device1
Linux agpgart interface v0.103
agpgart: Detected an Intel G33 Chipset.
agpgart: Detected 7164K stolen memory.
agpgart: AGP aperture is 256M @ 0xd0000000
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM chipsets
intelfb: Version 0.9.4
Driver 'sd' needs updating - please use bus_type methods
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf0f0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf0f8 irq 15
ata1.00: ATAPI: ASUS    DRW-1814BL, 1.13, max UDMA/66
ata1.00: configured for UDMA/66
scsi 0:0:0:0: CD-ROM            ASUS     DRW-1814BL       1.13 PQ: 0 ANSI: 5
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0xf0e0 ctl 0xf0d0 bmdma 0xf0a0 irq 17
ata4: SATA max UDMA/133 cmd 0xf0c0 ctl 0xf0b0 bmdma 0xf0a8 irq 17
ata3.00: ATA-7: Maxtor 7L250S0, BACE1G10, max UDMA/133
ata3.00: 488281250 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
ata4.00: ATA-7: Maxtor 7L250S0, BACE1G10, max UDMA/133
ata4.00: 488281250 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      Maxtor 7L250S0   BACE PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 488281250 512-byte hardware sectors (250000 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 488281250 512-byte hardware sectors (250000 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 >
sd 2:0:0:0: [sda] Attached SCSI disk
scsi 3:0:0:0: Direct-Access     ATA      Maxtor 7L250S0   BACE PQ: 0 ANSI: 5
sd 3:0:0:0: [sdb] 488281250 512-byte hardware sectors (250000 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdb] 488281250 512-byte hardware sectors (250000 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 < sdb5 >
sd 3:0:0:0: [sdb] Attached SCSI disk
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xff984000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f080
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f060
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f040
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000f020
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
usb 1-2: new high speed USB device using ehci_hcd and address 3
rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k
i2c /dev entries driver
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
raid6: int64x1   2069 MB/s
usb 1-2: configuration #1 chosen from 1 choice
hub 1-2:1.0: USB hub found
hub 1-2:1.0: 4 ports detected
raid6: int64x2   2605 MB/s
raid6: int64x4   2493 MB/s
raid6: int64x8   2013 MB/s
raid6: sse2x1    3512 MB/s
raid6: sse2x2    3919 MB/s
usb 2-1: new low speed USB device using uhci_hcd and address 2
raid6: sse2x4    6641 MB/s
raid6: using algorithm sse2x4 (6641 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
EDAC MC: Ver: 2.1.0 May  5 2008
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
NET: Registered protocol family 1
Marking TSC unstable due to TSC halts in idle
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
NET: Registered protocol family 17
registered taskstats version 1
rtc_cmos 00:08: setting system clock to 2008-05-07 11:17:49 UTC (1210159069)
md: Autodetecting RAID arrays.
usb 2-1: configuration #1 chosen from 1 choice
md: invalid raid superblock magic on sda5
md: sda5 does not have a valid v0.90 superblock, not importing!
md: invalid raid superblock magic on sdb5
md: sdb5 does not have a valid v0.90 superblock, not importing!
md: Scanned 4 and added 2 devices.
md: autorun ...
md: considering sdb1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: bind<sdb1>
md: running: <sdb1><sda1>
raid1: raid set md0 active with 2 out of 2 mirrors
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 248k freed
SELinux: policy loaded with handle_unknown=deny
type=1403 audit(1210159070.068:2): policy loaded auid=4294967295 ses=4294967295
type=1400 audit(1210159070.312:3): avc:  denied  { read write } for  pid=549 comm="hostname" name="console" dev=md0 ino=51241 scontext=system_u:system_r:hostname_t tcontext=user_u:object_r:device_t tclass=chr_file
type=1300 audit(1210159070.312:3): arch=40000003 syscall=11 success=yes exit=0 a0=9c3dd84 a1=9c3dd38 a2=9c3dd44 a3=9c3dd38 items=0 ppid=547 pid=549 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=tty1 ses=4294967295 comm="hostname" exe="/bin/hostname" subj=system_u:system_r:hostname_t key=(null)
type=1400 audit(1210159070.360:4): avc:  denied  { read write } for  pid=552 comm="mountpoint" name="console" dev=md0 ino=51241 scontext=system_u:system_r:mount_t tcontext=user_u:object_r:device_t tclass=chr_file
type=1300 audit(1210159070.360:4): arch=40000003 syscall=11 success=yes exit=0 a0=80e4a5c a1=80e4a08 a2=80e4a1c a3=80e4a08 items=0 ppid=550 pid=552 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=tty1 ses=4294967295 comm="mountpoint" exe="/bin/mountpoint" subj=system_u:system_r:mount_t key=(null)
type=1400 audit(1210159070.604:5): avc:  denied  { read write } for  pid=580 comm="restorecon" name="console" dev=md0 ino=51241 scontext=system_u:system_r:setfiles_t tcontext=user_u:object_r:device_t tclass=chr_file
type=1300 audit(1210159070.604:5): arch=40000003 syscall=11 success=yes exit=0 a0=a006a94 a1=a006ac8 a2=a006ad4 a3=a006ac8 items=0 ppid=572 pid=580 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=tty1 ses=4294967295 comm="restorecon" exe="/sbin/setfiles" subj=system_u:system_r:setfiles_t key=(null)
type=1400 audit(1210159071.652:6): avc:  denied  { getattr } for  pid=846 comm="hdparm" path="/proc/mdstat" dev=proc ino=4026531948 scontext=system_u:system_r:udev_t tcontext=system_u:object_r:proc_mdstat_t tclass=file
FDC 0 is a post-1991 82077
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt 0000:04:06.0[A] -> GSI 21 (level, low) -> IRQ 21
eth0: RealTek RTL8139 at 0xffffc20000028000, 00:c1:28:01:d5:f6, IRQ 21
input: Logitech USB RECEIVER as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input4
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 17
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ACPI Exception (video-1613): AE_NOT_FOUND, Evaluating _DOD [20070126]
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:17/input/input5
r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
eth1: RTL8168b/8111b at 0xffffc20000020000, 00:1c:c0:34:06:c9, XID 38500000 IRQ 380
input: USB HID v1.11 Mouse [Logitech USB RECEIVER] on usb-0000:00:1d.0-1
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
udev: renamed network interface eth0 to rtl
udev: renamed network interface eth1 to mobo
sr 0:0:0:0: Attached scsi generic sg0 type 5
sd 2:0:0:0: Attached scsi generic sg1 type 0
sd 3:0:0:0: Attached scsi generic sg2 type 0
ACPI: Video Device [GFX0] (multi-head: no  rom: yes  post: no)
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
printk: 24 messages suppressed.
type=1400 audit(1210159072.452:10): avc:  denied  { read write } for  pid=1266 comm="hwclock" name="console" dev=md0 ino=51241 scontext=system_u:system_r:hwclock_t tcontext=user_u:object_r:device_t tclass=chr_file
Adding 2008116k swap on /dev/sda2.  Priority:-1 extents:1 across:2008116k
Adding 2008116k swap on /dev/sdb2.  Priority:-2 extents:1 across:2008116k
EXT3 FS on md0, internal journal
w83627ehf: Found W83627DHG chip at 0x290
coretemp coretemp.0: Using relative temperature scale!
coretemp coretemp.1: Using relative temperature scale!
netconsole: local port 4444
netconsole: local IP 193.224.70.237
netconsole: interface mobo
netconsole: remote port 5555
netconsole: remote IP 193.224.70.213
netconsole: remote ethernet address 00:30:48:69:41:3a
netconsole: device mobo not up yet, forcing it
r8169: mobo: link down
r8169: mobo: link down
ADDRCONF(NETDEV_UP): mobo: link is not ready
r8169: mobo: link up
ADDRCONF(NETDEV_CHANGE): mobo: link becomes ready
console [netcon0] enabled
netconsole: network logging started
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
md: md3 stopped.
md: bind<sda5>
md: bind<sdb5>
raid1: raid set md3 active with 2 out of 2 mirrors
printk: 119 messages suppressed.
printk: 118 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
printk: 119 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
printk: 119 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
printk: 118 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
[drm:drm_update_drawable_info] *ERROR* Failed to copy cliprects from userspace
usb 1-2: USB disconnect, address 3
printk: 119 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
printk: 119 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
[drm:drm_update_drawable_info] *ERROR* Failed to copy cliprects from userspace
printk: 118 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
[drm:drm_update_drawable_info] *ERROR* Failed to copy cliprects from userspace
[drm:drm_update_drawable_info] *ERROR* Failed to copy cliprects from userspace
printk: 119 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
printk: 119 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
dropped pkt IN=mobo OUT= MAC=00:1c:c0:34:06:c9:00:19:b9:ec:f7:99:08:00 SRC=221.208.208.212 DST=193.224.70.237 LEN=486 TOS=0x00 PREC=0x00 TTL=45 ID=0 DF PROTO=UDP SPT=42549 DPT=1026 LEN=466 
dropped pkt IN=mobo OUT= MAC=00:1c:c0:34:06:c9:00:19:b9:ec:f7:99:08:00 SRC=221.208.208.212 DST=193.224.70.237 LEN=486 TOS=0x00 PREC=0x00 TTL=45 ID=0 DF PROTO=UDP SPT=42550 DPT=1026 LEN=466 
[drm:drm_update_drawable_info] *ERROR* Failed to copy cliprects from userspace
printk: 118 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
printk: 119 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
dropped pkt IN=mobo OUT= MAC=00:1c:c0:34:06:c9:00:19:b9:ec:f7:99:08:00 SRC=121.14.104.172 DST=193.224.70.237 LEN=48 TOS=0x00 PREC=0x00 TTL=110 ID=993 PROTO=TCP SPT=80 DPT=764 WINDOW=16384 RES=0x00 ACK SYN URGP=0 
[drm:drm_update_drawable_info] *ERROR* Failed to copy cliprects from userspace
[drm:drm_update_drawable_info] *ERROR* Failed to copy cliprects from userspace
printk: 119 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
[drm:drm_update_drawable_info] *ERROR* Failed to copy cliprects from userspace
[drm:drm_update_drawable_info] *ERROR* Failed to copy cliprects from userspace
[drm:drm_update_drawable_info] *ERROR* Failed to copy cliprects from userspace
usb 1-2: new high speed USB device using ehci_hcd and address 4
usb 1-2: configuration #1 chosen from 1 choice
hub 1-2:1.0: USB hub found
hub 1-2:1.0: 4 ports detected
[drm:drm_update_drawable_info] *ERROR* Failed to copy cliprects from userspace
printk: 119 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
dropped pkt IN=mobo OUT= MAC=00:1c:c0:34:06:c9:00:19:b9:ec:f7:99:08:00 SRC=74.53.58.169 DST=193.224.70.237 LEN=40 TOS=0x00 PREC=0x00 TTL=238 ID=19289 PROTO=TCP SPT=1557 DPT=1433 WINDOW=4096 RES=0x00 SYN URGP=0 
printk: 118 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
dropped pkt IN=mobo OUT= MAC=00:1c:c0:34:06:c9:00:19:b9:ec:f7:99:08:00 SRC=62.13.169.96 DST=193.224.70.237 LEN=40 TOS=0x00 PREC=0x00 TTL=48 ID=19882 PROTO=TCP SPT=53 DPT=1141 WINDOW=0 RES=0x00 ACK SYN URGP=0 
printk: 119 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
printk: 119 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
printk: 119 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
printk: 118 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
printk: 119 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
printk: 119 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
printk: 119 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
printk: 118 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
printk: 119 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
printk: 119 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
printk: 118 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
printk: 119 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
printk: 119 messages suppressed.
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
hpet_rtc_interrupt RTC_UIE 
NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Modules linked in: i915 drm rfcomm l2cap bluetooth xfrm_user xfrm4_tunnel tunnel4 ipcomp esp4 aead ah4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs ipt_ULOG microcode ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack xt_tcpudp ipt_LOG xt_limit iptable_filter ip_tables x_tables deflate zlib_deflate zlib_inflate ctr twofish twofish_common camellia serpent blowfish des_generic cbc aes_x86_64 aes_generic xcbc sha256_generic sha1_generic md5 crypto_null af_key fuse dm_crypt crypto_blkcipher dm_snapshot dm_mirror dm_mod netconsole configfs coretemp w83627ehf hwmon_vid snd_hda_intel snd_pcm snd_timer sg sr_mod snd r8169 video 8250_pnp 8250 serial_core i2c_i801 8139too snd_page_alloc usbhid iTCO_wdt floppy cdrom
Pid: 23111, comm: cc1 Not tainted 2.6.25 #1
RIP: 0010:[<ffffffff8021aaa0>]  [<ffffffff8021aaa0>] hpet_rtc_interrupt+0x166/0x349
RSP: 0018:ffffffff8064cec8  EFLAGS: 00000097
RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
RDX: 0000000000007d7d RSI: 0000000000000002 RDI: ffffffff80655ef8
RBP: 00000001001c203d R08: ffffffffff5fc128 R09: 0000000000000000
R10: 0000000000000046 R11: ffffffff802fe216 R12: 00000000000000a6
R13: ffff81012fe1d400 R14: 0000000000000004 R15: ffff8100b5b5be38
FS:  0000000000000000(0000) GS:ffffffff805e8000(0063) knlGS:00000000555706b0
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 0000000055935000 CR3: 00000000583ca000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cc1 (pid: 23111, threadinfo ffff8100b5b5a000, task ffff8100bd923260)
Stack:  0000000000000000 0000000000000000 0000000000000000 0000000000000000
 ffffffff00000000 0000000000000001 ffffffff806432c0 ffff81012fcc2d80
 0000000000000000 0000000000000000 0000000000000008 ffffffff8025d720
Call Trace:
 <IRQ>  [<ffffffff8025d720>] ? handle_IRQ_event+0x25/0x53
 [<ffffffff8025ec8a>] ? handle_edge_irq+0xdd/0x11c
 [<ffffffff8020c0cc>] ? call_softirq+0x1c/0x28
 [<ffffffff8020e26a>] ? do_IRQ+0xf1/0x15f
 [<ffffffff8020b451>] ? ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff802fe216>] ? selinux_file_permission+0x0/0x119
 [<ffffffff802f9be8>] ? avc_has_perm_noaudit+0x2/0x359
 [<ffffffff802fa9e5>] ? avc_has_perm+0x2f/0x5e
 [<ffffffff8028b212>] ? pipe_write+0x423/0x435
 [<ffffffff8026731b>] ? get_page_from_freelist+0x392/0x427
 [<ffffffff802fb6ca>] ? inode_has_perm+0x65/0x72
 [<ffffffff80284f14>] ? do_sync_write+0xd1/0x118
 [<ffffffff802829a3>] ? __mem_cgroup_add_list+0x9/0x5c
 [<ffffffff802fb771>] ? file_has_perm+0x9a/0xa9
 [<ffffffff802fe310>] ? selinux_file_permission+0xfa/0x119
 [<ffffffff802850f2>] ? rw_verify_area+0x7f/0x9f
 [<ffffffff8028568b>] ? vfs_write+0x86/0x143
 [<ffffffff80285c26>] ? sys_write+0x45/0x6e
 [<ffffffff8021e272>] ? sysenter_do_call+0x1b/0x66


Code: a0 28 00 bf 0a 00 00 00 48 89 c3 e8 27 6b ff ff 48 89 de 41 88 c4 48 c7 c7 f8 5e 65 80 e8 28 a1 28 00 45 84 e4 78 04 eb 12 f3 90 <48> 8b 05 d9 1d 3e 00 48 29 e8 48 83 f8 04 76 ee 48 c7 c7 f8 5e 
---[ end trace 872500f60116b571 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
