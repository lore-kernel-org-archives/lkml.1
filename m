Return-Path: <linux-kernel-owner+w=401wt.eu-S1761948AbYBLIXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761948AbYBLIXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 03:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYBLIX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 03:23:28 -0500
Received: from smtp20.orange.fr ([80.12.242.26]:14898 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274AbYBLIXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 03:23:24 -0500
X-ME-UUID: 20080212082320233.05B011C000C2@mwinf2002.orange.fr
Message-ID: <47B15775.8010200@orange.fr>
Date: Tue, 12 Feb 2008 09:23:17 +0100
From: RM <roger.martinez-nospam@orange.fr>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: netdev
Content-Type: multipart/mixed;
 boundary="------------010803040504040203050400"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010803040504040203050400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Bonjour

Since kernel-2.6.24 i cannot connect to internet
networking process is not ok ; avahi bad
the problem for me in only with Amd64 processor
with Dell laptop and pentium4m kernel-2.6.24 and avahi service  is ok
i sent you syslog 2.6.24.1 and syslog and syslog-2.6.23.14

thanks for back please

Roger

--------------010803040504040203050400
Content-Type: text/plain;
 name="syslog kernel-2.6.24.1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="syslog kernel-2.6.24.1"

Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] Linux version 2.6.24.1-pays-dolmes (root@pays-dolmes1) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Sat Feb 9 17:20:49 CET 2008
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] Command line: root=/dev/sda8 ro 
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] BIOS-provided physical RAM map:
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000007efd0000 (usable)
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]  BIOS-e820: 000000007efd0000 - 000000007efde000 (ACPI data)
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]  BIOS-e820: 000000007efde000 - 000000007f000000 (ACPI NVS)
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] Entering add_active_range(0, 256, 520144) 1 entries of 256 used
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] end_pfn_map = 1048576
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] DMI present.
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] ACPI: RSDP 000F8510, 0014 (r0 ACPIAM)
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] ACPI: RSDT 7EFD0000, 0030 (r1 A M I  OEMRSDT   7000606 MSFT       97)
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] ACPI: FACP 7EFD0200, 0084 (r2 A M I  OEMFACP   7000606 MSFT       97)
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] ACPI: DSDT 7EFD0440, 47DC (r1  1ADIF 1ADIF006        6 INTL 20051117)
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] ACPI: FACS 7EFDE000, 0040
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] ACPI: MCFG 7EFD0400, 003C (r1 A M I  OEMMCFG   7000606 MSFT       97)
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] ACPI: OEMB 7EFDE040, 0060 (r1 A M I  AMI_OEM   7000606 MSFT       97)
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] Entering add_active_range(0, 256, 520144) 1 entries of 256 used
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] Zone PFN ranges:
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]   DMA             0 ->     4096
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]   DMA32        4096 ->  1048576
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]   Normal    1048576 ->  1048576
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] Movable zone start PFN for each node
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] early_node_map[2] active PFN ranges
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]     0:        0 ->      159
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]     0:      256 ->   520144
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] On node 0 totalpages: 520047
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]   DMA zone: 56 pages used for memmap
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]   DMA zone: 1210 pages reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]   DMA zone: 2733 pages, LIFO batch:0
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]   DMA32 zone: 7055 pages used for memmap
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]   DMA32 zone: 508993 pages, LIFO batch:31
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]   Normal zone: 0 pages used for memmap
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000]   Movable zone: 0 pages used for memmap
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] Nvidia board detected. Ignoring ACPI timer override.
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] If you got timer trouble try acpi_use_timer_override
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x4008
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] Intel MultiProcessor Specification v1.4
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] MPTABLE: OEM ID: nVidia   MPTABLE: Product ID: MCP51G/M     MPTABLE: APIC at: 0xFEE00000
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] Processor #0 (Bootup-CPU)
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] Processor #1
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] I/O APIC #2 at 0xFEC00000.
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] Setting APIC routing to flat
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] Processors: 2
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] Allocating PCI resources starting at 80000000 (gap: 7f000000:7fc00000)
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] PERCPU: Allocating 29152 bytes of per cpu data
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 511726
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] Kernel command line: root=/dev/sda8 ro 
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] Initializing CPU#0
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
Feb  9 23:39:08 pays-dolmes1 kernel: [    0.000000] TSC calibrated against PM_TIMER
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.672234] Marking TSC unstable due to TSCs unsynchronized
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.672236] time.c: Detected 2611.893 MHz processor.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.676912] Console: colour VGA+ 80x25
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.676915] console [tty0] enabled
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.679695] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.681246] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.681757] Checking aperture...
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.681790] CPU 0: aperture @ f85e000000 size 32 MB
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.681822] Aperture too small (32 MB)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.687983] No AGP bridge found
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.704288] Memory: 2043532k/2080576k available (2888k kernel code, 36524k reserved, 1199k data, 212k init)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.764183] Calibrating delay using timer specific routine.. 5226.27 BogoMIPS (lpj=2613136)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.764284] Security Framework initialized
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.764318] SELinux:  Disabled at boot.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.764363] Mount-cache hash table entries: 256
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.764501] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.764536] CPU: L2 Cache: 512K (64 bytes/line)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.764569] CPU: Physical Processor ID: 0
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.764601] CPU: Processor Core ID: 0
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.764650] SMP alternatives: switching to UP code
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.765204] ACPI: Core revision 20070126
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.766728] ACPI: setting ELCR to 0200 (from 0c20)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.767266] ExtINT not setup in hardware but reported by MP table
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.777699] Using local APIC timer interrupts.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.816013] APIC timer calibration result 12557193
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.816014] Detected 12.557 MHz APIC timer.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.816149] SMP alternatives: switching to SMP code
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.816662] Booting processor 1/2 APIC 0x1
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.826741] Initializing CPU#1
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.887044] Calibrating delay using timer specific routine.. 5223.78 BogoMIPS (lpj=2611894)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.887049] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.887051] CPU: L2 Cache: 512K (64 bytes/line)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.887053] CPU: Physical Processor ID: 0
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.887054] CPU: Processor Core ID: 1
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.887118] AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.887143] Brought up 2 CPUs
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.887479] CPU0 attaching sched-domain:
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.887481]  domain 0: span 3
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.887482]   groups: 1 2
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.887485] CPU1 attaching sched-domain:
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.887486]  domain 0: span 3
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.887487]   groups: 2 1
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.887658] net_namespace: 120 bytes
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.887995] NET: Registered protocol family 16
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.888151] ACPI: bus type pci registered
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.888243] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.888277] PCI: Not using MMCONFIG.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.888309] PCI: Using configuration type 1
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.891411] ACPI: EC: Look up EC in DSDT
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.895422] ACPI: Interpreter enabled
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.895456] ACPI: (supports S0 S1 S3 S5)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.895571] ACPI: Using PIC for interrupt routing
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.895786] Error attaching device data
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.895820] Error attaching device data
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.902726] ACPI: PCI Root Bridge [PCI0] (0000:00)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.903628] PCI: Transparent bridge - 0000:00:10.0
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.903674] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.903850] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.903922] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.903994] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PA._PRT]
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.904083] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.911773] ACPI: PCI Interrupt Link [LNKA] (IRQs *10 11 14 15)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.912058] ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11 14 15) *0, disabled.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.912380] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11 14 15) *0, disabled.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.912700] ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11 14 15) *0, disabled.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.913021] ACPI: PCI Interrupt Link [LNEA] (IRQs 10 11 14 15) *0, disabled.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.913345] ACPI: PCI Interrupt Link [LNEB] (IRQs 10 11 14 15) *0, disabled.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.913664] ACPI: PCI Interrupt Link [LNEC] (IRQs *10 11 14 15)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.913942] ACPI: PCI Interrupt Link [LNED] (IRQs 10 11 14 15) *0, disabled.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.914264] ACPI: PCI Interrupt Link [LUB0] (IRQs 5 7 10 *11 14 15)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.914583] ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7 *10 11 14 15)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.914901] ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 10 *11 14 15)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.915221] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 *11 14 15)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.915520] ACPI: PCI Interrupt Link [LACI] (IRQs 5 7 10 11 14 15) *0, disabled.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.915885] ACPI: PCI Interrupt Link [LMC9] (IRQs 5 7 10 11 14 15) *0, disabled.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.916251] ACPI: PCI Interrupt Link [LSMB] (IRQs *5 7 10 11 14 15)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.916568] ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 10 *11 14 15)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.916888] ACPI: PCI Interrupt Link [LSA0] (IRQs *5 7 14 15)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.917169] ACPI: PCI Interrupt Link [LSA1] (IRQs *5 7 14 15)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.917477] ACPI: PCI Interrupt Link [LATA] (IRQs 5 7 10 11 14 15) *0, disabled.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.917793] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  72, should be 6D [20070126]
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.917881] Linux Plug and Play Support v0.97 (c) Adam Belay
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.917933] pnp: PnP ACPI init
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.917969] ACPI: bus type pnp registered
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.922035] pnp: PnP ACPI: found 15 devices
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.922071] ACPI: ACPI bus type pnp unregistered
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.922249] SCSI subsystem initialized
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.922308] libata version 3.00 loaded.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.922388] PCI: Using ACPI for IRQ routing
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.922421] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928068] system 00:07: iomem range 0xfefe0000-0xfefe01ff has been reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928107] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928141] system 00:08: ioport range 0x800-0x80f has been reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928175] system 00:08: ioport range 0x4000-0x407f has been reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928210] system 00:08: ioport range 0x4080-0x40ff has been reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928244] system 00:08: ioport range 0x4400-0x447f has been reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928279] system 00:08: ioport range 0x4480-0x44ff has been reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928313] system 00:08: ioport range 0x4800-0x487f has been reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928348] system 00:08: ioport range 0x4880-0x48ff has been reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928382] system 00:08: ioport range 0x2000-0x207f has been reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928418] system 00:08: ioport range 0x2080-0x20ff has been reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928453] system 00:08: iomem range 0xfea80000-0xfeabffff has been reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928488] system 00:08: iomem range 0xfee01000-0xfeefffff has been reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928527] system 00:09: iomem range 0xfec00000-0xfec00fff could not be reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928570] system 00:09: iomem range 0xfee00000-0xfee00fff could not be reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928616] system 00:0c: ioport range 0xa00-0xa0f has been reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928651] system 00:0c: ioport range 0xa10-0xa1f has been reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928690] system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928728] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928762] system 00:0e: iomem range 0xc0000-0xcffff has been reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928797] system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928832] system 00:0e: iomem range 0x100000-0x7fffffff could not be reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.928875] system 00:0e: iomem range 0xfec00000-0xffffffff could not be reserved
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929185] PCI: Bridge: 0000:00:02.0
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929216]   IO window: disabled.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929248]   MEM window: disabled.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929279]   PREFETCH window: disabled.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929311] PCI: Bridge: 0000:00:03.0
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929341]   IO window: disabled.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929372]   MEM window: disabled.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929403]   PREFETCH window: disabled.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929435] PCI: Bridge: 0000:00:04.0
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929466]   IO window: disabled.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929497]   MEM window: disabled.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929528]   PREFETCH window: disabled.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929560] PCI: Bridge: 0000:00:10.0
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929591]   IO window: e000-efff
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929624]   MEM window: feb00000-febfffff
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929657]   PREFETCH window: disabled.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929699] PCI: Setting latency timer of device 0000:00:02.0 to 64
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929704] PCI: Setting latency timer of device 0000:00:03.0 to 64
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929708] PCI: Setting latency timer of device 0000:00:04.0 to 64
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929714] PCI: Setting latency timer of device 0000:00:10.0 to 64
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.929737] NET: Registered protocol family 2
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.930040] Time: acpi_pm clocksource has been installed.
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.939094] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.939682] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.941677] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.942222] TCP: Hash tables configured (established 262144 bind 65536)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.942258] TCP reno registered
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.945883] audit: initializing netlink socket (disabled)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.950054] audit(1202596713.240:1): initialized
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.950239] VFS: Disk quotas dquot_6.5.1
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.950289] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.950390] NTFS driver 2.1.29 [Flags: R/W].
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.950442] SGI XFS with security attributes, realtime, large block/inode numbers, no debug enabled
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.950638] SGI XFS Quota Management subsystem
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.950697] io scheduler noop registered
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.950729] io scheduler anticipatory registered (default)
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.950762] io scheduler deadline registered
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.950802] io scheduler cfq registered
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.950844] Boot video device is 0000:00:05.0
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.968461] Real Time Clock Driver v1.12ac
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.968514] Linux agpgart interface v0.102
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.968546] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.968705] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.969178] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.969776] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.969823] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.969859] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Feb  9 23:39:08 pays-dolmes1 kernel: [   24.969941] Probing IDE interface ide0...
Feb  9 23:39:08 pays-dolmes1 kernel: [   25.692090] hdb: HL-DT-STDVD-ROM GDR8164B, ATAPI CD/DVD-ROM drive
Feb  9 23:39:08 pays-dolmes1 kernel: [   26.405987] hda: HL-DT-ST DVDRAM GSA-H10N, ATAPI CD/DVD-ROM drive
Feb  9 23:39:08 pays-dolmes1 kernel: [   26.406081] Probing IDE interface ide1...
Feb  9 23:39:08 pays-dolmes1 kernel: [   26.924783] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Feb  9 23:39:08 pays-dolmes1 kernel: [   26.927093] hda: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
Feb  9 23:39:08 pays-dolmes1 kernel: [   26.927247] Uniform CD-ROM driver Revision: 3.20
Feb  9 23:39:08 pays-dolmes1 kernel: [   26.936893] hdb: ATAPI 52X DVD-ROM drive, 256kB Cache
Feb  9 23:39:08 pays-dolmes1 kernel: [   26.943109] st: Version 20070203, fixed bufsize 32768, s/g segs 256
Feb  9 23:39:08 pays-dolmes1 kernel: [   26.943164] Driver 'st' needs updating - please use bus_type methods
Feb  9 23:39:08 pays-dolmes1 kernel: [   26.943242] Driver 'sd' needs updating - please use bus_type methods
Feb  9 23:39:08 pays-dolmes1 kernel: [   26.943356] sata_nv 0000:00:0e.0: version 3.5
Feb  9 23:39:08 pays-dolmes1 kernel: [   26.943586] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 5
Feb  9 23:39:08 pays-dolmes1 kernel: [   26.943620] PCI: setting IRQ 5 as level-triggered
Feb  9 23:39:08 pays-dolmes1 kernel: [   26.943623] ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [LSA0] -> GSI 5 (level, low) -> IRQ 5
Feb  9 23:39:08 pays-dolmes1 kernel: [   26.943925] PCI: Setting latency timer of device 0000:00:0e.0 to 64
Feb  9 23:39:08 pays-dolmes1 kernel: [   26.944017] scsi0 : sata_nv
Feb  9 23:39:08 pays-dolmes1 kernel: [   26.944150] scsi1 : sata_nv
Feb  9 23:39:08 pays-dolmes1 kernel: [   26.944315] ata1: SATA max UDMA/133 cmd 0xd800 ctl 0xd480 bmdma 0xd000 irq 5
Feb  9 23:39:08 pays-dolmes1 kernel: [   26.944351] ata2: SATA max UDMA/133 cmd 0xd400 ctl 0xd080 bmdma 0xd008 irq 5
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.397698] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.401811] ata1.00: ATA-7: Maxtor 6V250F0, VA111900, max UDMA/133
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.401846] ata1.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 0/32)
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.408896] ata1.00: configured for UDMA/133
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.862630] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.866763] ata2.00: ATA-7: Maxtor 6V250F0, VA111900, max UDMA/133
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.866798] ata2.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 0/32)
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.873849] ata2.00: configured for UDMA/133
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.873942] scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6V250F0   VA11 PQ: 0 ANSI: 5
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.874070] sd 0:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.874111] sd 0:0:0:0: [sda] Write Protect is off
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.874144] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.874153] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.874231] sd 0:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.874270] sd 0:0:0:0: [sda] Write Protect is off
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.874303] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.874311] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.874356]  sda: sda1 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 sda13 >
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.980418] sd 0:0:0:0: [sda] Attached SCSI disk
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.980509] sd 0:0:0:0: Attached scsi generic sg0 type 0
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.980584] scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6V250F0   VA11 PQ: 0 ANSI: 5
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.980699] sd 1:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.980738] sd 1:0:0:0: [sdb] Write Protect is off
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.980771] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.980779] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.980841] sd 1:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.980880] sd 1:0:0:0: [sdb] Write Protect is off
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.980912] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.980921] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Feb  9 23:39:08 pays-dolmes1 kernel: [   27.980965]  sdb: sdb1 < sdb5 sdb6 sdb7 sdb8 sdb9 sdb10 sdb11 sdb12 sdb13 >
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.089566] sd 1:0:0:0: [sdb] Attached SCSI disk
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.089648] sd 1:0:0:0: Attached scsi generic sg1 type 0
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.089897] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 5
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.089931] ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [LSA1] -> GSI 5 (level, low) -> IRQ 5
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.090197] PCI: Setting latency timer of device 0000:00:0f.0 to 64
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.090268] scsi2 : sata_nv
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.090393] scsi3 : sata_nv
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.090558] ata3: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 5
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.090594] ata4: SATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 5
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.393548] ata3: SATA link down (SStatus 0 SControl 300)
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.706500] ata4: SATA link down (SStatus 0 SControl 300)
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.717060] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.719569] serio: i8042 KBD port at 0x60,0x64 irq 1
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.719605] serio: i8042 AUX port at 0x60,0x64 irq 12
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.719705] mice: PS/2 mouse device common for all mice
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.719835] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.720163] ip_tables: (C) 2000-2006 Netfilter Core Team
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.720219] TCP cubic registered
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.720256] NET: Registered protocol family 1
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.720294] ieee80211: 802.11 data/management/control stack, git-1.1.13
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.720328] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.720372] ieee80211_crypt: registered algorithm 'NULL'
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.720374] ieee80211_crypt: registered algorithm 'WEP'
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.736822] input: AT Translated Set 2 keyboard as /class/input/input0
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.844860] ReiserFS: sda8: found reiserfs format "3.6" with standard journal
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.844900] ReiserFS: sda8: using ordered data mode
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.848706] ReiserFS: sda8: journal params: device sda8, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.850054] ReiserFS: sda8: checking transaction log (sda8)
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.886758] ReiserFS: sda8: Using r5 hash to sort names
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.886817] VFS: Mounted root (reiserfs filesystem) readonly.
Feb  9 23:39:08 pays-dolmes1 kernel: [   28.886861] Freeing unused kernel memory: 212k freed
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.266465] input: Power Button (FF) as /class/input/input1
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.280397] ACPI: Power Button (FF) [PWRF]
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.280518] input: Power Button (CM) as /class/input/input2
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.280580] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.280671] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.296393] ACPI: Power Button (CM) [PWRB]
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.410878] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x5000
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.410929] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x6000
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.445588] usbcore: registered new interface driver usbfs
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.445652] usbcore: registered new interface driver hub
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.447750] usbcore: registered new device driver usb
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.450665] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.450669] ohci_hcd: block sizes: ed 80 td 96
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.450956] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 11
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.450995] PCI: setting IRQ 11 as level-triggered
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.450998] ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LUB0] -> GSI 11 (level, low) -> IRQ 11
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.451275] PCI: Setting latency timer of device 0000:00:0b.0 to 64
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.451281] ohci_hcd 0000:00:0b.0: OHCI Host Controller
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.451491] drivers/usb/core/inode.c: creating file 'devices'
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.451497] drivers/usb/core/inode.c: creating file '001'
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.451513] ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus number 1
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.451568] ohci_hcd 0000:00:0b.0: created debug files
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.451579] ohci_hcd 0000:00:0b.0: irq 11, io mem 0xfeade000
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.462868] input: PC Speaker as /class/input/input3
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.481583] ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504275] ohci_hcd 0000:00:0b.0: OHCI controller state
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504279] ohci_hcd 0000:00:0b.0: OHCI 1.0, NO legacy support registers
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504283] ohci_hcd 0000:00:0b.0: control 0x683 RWE RWC HCFS=operational CBSR=3
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504286] ohci_hcd 0000:00:0b.0: cmdstatus 0x00000 SOC=0
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504289] ohci_hcd 0000:00:0b.0: intrstatus 0x00000004 SF
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504291] ohci_hcd 0000:00:0b.0: intrenable 0x8000004a MIE RHSC RD WDH
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504297] ohci_hcd 0000:00:0b.0: hcca frame #0003
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504300] ohci_hcd 0000:00:0b.0: roothub.a 01001208 POTPGT=1 NOCP NPS NDP=8(8)
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504303] ohci_hcd 0000:00:0b.0: roothub.b 00000000 PPCM=0000 DR=0000
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504306] ohci_hcd 0000:00:0b.0: roothub.status 00008000 DRWE
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504309] ohci_hcd 0000:00:0b.0: roothub.portstatus [0] 0x00000100 PPS
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504312] ohci_hcd 0000:00:0b.0: roothub.portstatus [1] 0x00000100 PPS
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504315] ohci_hcd 0000:00:0b.0: roothub.portstatus [2] 0x00000100 PPS
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504318] ohci_hcd 0000:00:0b.0: roothub.portstatus [3] 0x00000100 PPS
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504321] ohci_hcd 0000:00:0b.0: roothub.portstatus [4] 0x00000100 PPS
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504324] ohci_hcd 0000:00:0b.0: roothub.portstatus [5] 0x00000100 PPS
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504327] ohci_hcd 0000:00:0b.0: roothub.portstatus [6] 0x00000100 PPS
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504330] ohci_hcd 0000:00:0b.0: roothub.portstatus [7] 0x00000100 PPS
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504348] usb usb1: default language 0x0409
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504376] usb usb1: uevent
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504387] usb usb1: usb_probe_device
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504438] usb usb1: configuration #1 chosen from 1 choice
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504477] usb usb1: adding 1-0:1.0 (config #1, interface 0)
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504486] usb 1-0:1.0: uevent
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504494] hub 1-0:1.0: usb_probe_interface
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504496] hub 1-0:1.0: usb_probe_interface - got id
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504497] hub 1-0:1.0: USB hub found
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504538] hub 1-0:1.0: 8 ports detected
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504569] hub 1-0:1.0: standalone hub
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504571] hub 1-0:1.0: no power switching (usb 1.0)
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504572] hub 1-0:1.0: no over-current protection
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504574] hub 1-0:1.0: power on to power good time: 2ms
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504578] hub 1-0:1.0: local power source is good
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.504579] hub 1-0:1.0: trying to enable port power on non-switchable hub
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.605294] drivers/usb/core/inode.c: creating file '001'
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.605303] usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.605305] usb usb1: Product: OHCI Host Controller
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.605340] usb usb1: Manufacturer: Linux 2.6.24.1-pays-dolmes ohci_hcd
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.605374] usb usb1: SerialNumber: 0000:00:0b.0
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.605434] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.605460] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.605749] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 11
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.605784] ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [LMAC] -> GSI 11 (level, low) -> IRQ 11
Feb  9 23:39:08 pays-dolmes1 kernel: [   30.605868] PCI: Setting latency timer of device 0000:00:14.0 to 64
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.084895] input: ImPS/2 Generic Wheel Mouse as /class/input/input4
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.099809] parport_pc 00:06: reported by Plug and Play ACPI
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.099897] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.119697] forcedeth 0000:00:14.0: ifname eth0, PHY OUI 0x1c1 @ 1, addr 00:16:17:88:04:a9
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.119745] forcedeth 0000:00:14.0: highdma pwrctl timirq gbit lnktim desc-v3
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.120422] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.120459] PCI: setting IRQ 10 as level-triggered
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.120462] ACPI: PCI Interrupt 0000:04:08.0[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.162737] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 10
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.162775] ACPI: PCI Interrupt 0000:00:0b.1[B] -> Link [LUB2] -> GSI 10 (level, low) -> IRQ 10
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.163015] PCI: Setting latency timer of device 0000:00:0b.1 to 64
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.163021] ehci_hcd 0000:00:0b.1: EHCI Host Controller
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.163095] drivers/usb/core/inode.c: creating file '002'
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.163105] ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus number 2
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.163164] ehci_hcd 0000:00:0b.1: reset hcs_params 0x101888 dbg=1 cc=1 pcc=8 !ppc ports=8
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.163171] ehci_hcd 0000:00:0b.1: reset portroute 0 0 0 0 0 0 0 0 
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.163174] ehci_hcd 0000:00:0b.1: reset hcc_params a086 caching frame 256/512/1024 park
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.163195] ehci_hcd 0000:00:0b.1: park 0
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.163198] ehci_hcd 0000:00:0b.1: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.163206] ehci_hcd 0000:00:0b.1: debug port 1
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.163241] PCI: cache line size of 64 is not supported by device 0000:00:0b.1
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.163242] ehci_hcd 0000:00:0b.1: supports USB remote wakeup
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.163254] ehci_hcd 0000:00:0b.1: irq 10, io mem 0xfeadfc00
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.163288] ehci_hcd 0000:00:0b.1: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.163293] ehci_hcd 0000:00:0b.1: init command 010009 (park)=0 ithresh=1 period=256 RUN
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.169149] ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.169221] usb usb2: default language 0x0409
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.169245] usb usb2: uevent
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.169259] usb usb2: usb_probe_device
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.169299] usb usb2: configuration #1 chosen from 1 choice
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.169336] usb usb2: adding 2-0:1.0 (config #1, interface 0)
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.169346] usb 2-0:1.0: uevent
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.169354] hub 2-0:1.0: usb_probe_interface
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.169356] hub 2-0:1.0: usb_probe_interface - got id
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.169357] hub 2-0:1.0: USB hub found
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.169395] hub 2-0:1.0: 8 ports detected
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.169426] hub 2-0:1.0: standalone hub
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.169427] hub 2-0:1.0: no power switching (usb 1.0)
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.169429] hub 2-0:1.0: individual port over-current protection
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.169430] hub 2-0:1.0: Single TT
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.169431] hub 2-0:1.0: TT requires at most 8 FS bit times (666 ns)
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.169433] hub 2-0:1.0: power on to power good time: 20ms
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.169436] hub 2-0:1.0: local power source is good
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.169438] hub 2-0:1.0: trying to enable port power on non-switchable hub
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.171705] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[10]  MMIO=[febff800-febfffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.270196] drivers/usb/core/inode.c: creating file '001'
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.270204] usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.270206] usb usb2: Product: EHCI Host Controller
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.270241] usb usb2: Manufacturer: Linux 2.6.24.1-pays-dolmes ehci_hcd
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.270275] usb usb2: SerialNumber: 0000:00:0b.1
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.270397] hub 2-0:1.0: state 7 ports 8 chg 0000 evt 0000
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.270657] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 11
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.270691] ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [LAZA] -> GSI 11 (level, low) -> IRQ 11
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.270918] PCI: Setting latency timer of device 0000:00:10.1 to 64
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.322126] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.564836] Adding 1951856k swap on /dev/sda12.  Priority:-1 extents:1 across:1951856k
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.571297] Adding 1951856k swap on /dev/sdb12.  Priority:-2 extents:1 across:1951856k
Feb  9 23:39:08 pays-dolmes1 kernel: [   31.684081] ohci_hcd 0000:00:0b.0: auto-stop root hub
Feb  9 23:39:08 pays-dolmes1 kernel: [   32.434251] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[8817160004a90010]
Feb  9 23:39:08 pays-dolmes1 kernel: [   32.587284] device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.266802] ReiserFS: sda13: found reiserfs format "3.6" with standard journal
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.266852] ReiserFS: sda13: using ordered data mode
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.271223] ReiserFS: sda13: journal params: device sda13, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.272653] ReiserFS: sda13: checking transaction log (sda13)
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.279037] ReiserFS: sda13: Using r5 hash to sort names
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.302024] ReiserFS: sda5: found reiserfs format "3.6" with standard journal
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.302065] ReiserFS: sda5: using ordered data mode
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.357991] ReiserFS: sda5: journal params: device sda5, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.359445] ReiserFS: sda5: checking transaction log (sda5)
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.370477] ReiserFS: sda5: Using r5 hash to sort names
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.387840] ReiserFS: sda11: found reiserfs format "3.6" with standard journal
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.387894] ReiserFS: sda11: using ordered data mode
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.424342] ReiserFS: sda11: journal params: device sda11, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.425710] ReiserFS: sda11: checking transaction log (sda11)
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.474897] ReiserFS: sda11: Using r5 hash to sort names
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.501392] ReiserFS: sda7: found reiserfs format "3.6" with standard journal
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.501434] ReiserFS: sda7: using ordered data mode
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.504741] ReiserFS: sda7: journal params: device sda7, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.506121] ReiserFS: sda7: checking transaction log (sda7)
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.519856] ReiserFS: sda7: Using r5 hash to sort names
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.536378] ReiserFS: sda9: found reiserfs format "3.6" with standard journal
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.536421] ReiserFS: sda9: using ordered data mode
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.546492] ReiserFS: sda9: journal params: device sda9, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.547859] ReiserFS: sda9: checking transaction log (sda9)
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.597954] ReiserFS: sda9: Using r5 hash to sort names
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.651714] ReiserFS: sda10: found reiserfs format "3.6" with standard journal
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.651765] ReiserFS: sda10: using ordered data mode
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.661387] ReiserFS: sda10: journal params: device sda10, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.662745] ReiserFS: sda10: checking transaction log (sda10)
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.691822] ReiserFS: sda10: Using r5 hash to sort names
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.734377] ReiserFS: sda6: found reiserfs format "3.6" with standard journal
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.734426] ReiserFS: sda6: using ordered data mode
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.743069] ReiserFS: sda6: journal params: device sda6, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.744535] ReiserFS: sda6: checking transaction log (sda6)
Feb  9 23:39:08 pays-dolmes1 kernel: [   55.756169] ReiserFS: sda6: Using r5 hash to sort names
Feb  9 23:39:08 pays-dolmes1 kernel: [   57.391247] NET: Registered protocol family 17
Feb  9 23:39:08 pays-dolmes1 kernel: [   57.798025] NET: Registered protocol family 10
Feb  9 23:39:08 pays-dolmes1 kernel: [   57.798265] lo: Disabled Privacy Extensions
Feb  9 23:39:08 pays-dolmes1 named[2859]: starting BIND 9.3.4 -u bind
Feb  9 23:39:08 pays-dolmes1 named[2859]: found 2 CPUs, using 2 worker threads
Feb  9 23:39:08 pays-dolmes1 named[2859]: loading configuration from '/etc/bind/named.conf'
Feb  9 23:39:08 pays-dolmes1 named[2859]: listening on IPv6 interfaces, port 53
Feb  9 23:39:08 pays-dolmes1 named[2859]: could not listen on UDP socket: permission denied
Feb  9 23:39:08 pays-dolmes1 named[2859]: listening on all IPv6 interfaces failed
Feb  9 23:39:08 pays-dolmes1 named[2859]: listening on IPv4 interface lo, 127.0.0.1#53
Feb  9 23:39:08 pays-dolmes1 named[2859]: could not listen on UDP socket: permission denied
Feb  9 23:39:08 pays-dolmes1 named[2859]: creating IPv4 interface lo failed; interface ignored
Feb  9 23:39:08 pays-dolmes1 named[2859]: listening on IPv4 interface eth1, 192.168.1.2#53
Feb  9 23:39:08 pays-dolmes1 named[2859]: could not listen on UDP socket: permission denied
Feb  9 23:39:08 pays-dolmes1 named[2859]: creating IPv4 interface eth1 failed; interface ignored
Feb  9 23:39:08 pays-dolmes1 named[2859]: not listening on any interfaces
Feb  9 23:39:08 pays-dolmes1 named[2859]: couldn't add command channel 127.0.0.1#953: permission denied
Feb  9 23:39:08 pays-dolmes1 named[2859]: couldn't add command channel ::1#953: permission denied
Feb  9 23:39:08 pays-dolmes1 named[2859]: listening on IPv6 interfaces, port 53
Feb  9 23:39:08 pays-dolmes1 named[2859]: could not listen on UDP socket: permission denied
Feb  9 23:39:08 pays-dolmes1 named[2859]: listening on all IPv6 interfaces failed
Feb  9 23:39:08 pays-dolmes1 named[2859]: additionally listening on IPv4 interface lo, 127.0.0.1#53
Feb  9 23:39:08 pays-dolmes1 named[2859]: could not listen on UDP socket: permission denied
Feb  9 23:39:08 pays-dolmes1 named[2859]: creating IPv4 interface lo failed; interface ignored
Feb  9 23:39:08 pays-dolmes1 named[2859]: additionally listening on IPv4 interface eth1, 192.168.1.2#53
Feb  9 23:39:08 pays-dolmes1 named[2859]: could not listen on UDP socket: permission denied
Feb  9 23:39:08 pays-dolmes1 named[2859]: creating IPv4 interface eth1 failed; interface ignored
Feb  9 23:39:08 pays-dolmes1 named[2859]: zone 0.in-addr.arpa/IN: loaded serial 1
Feb  9 23:39:08 pays-dolmes1 named[2859]: zone 127.in-addr.arpa/IN: loaded serial 1
Feb  9 23:39:08 pays-dolmes1 named[2859]: zone 255.in-addr.arpa/IN: loaded serial 1
Feb  9 23:39:08 pays-dolmes1 named[2859]: zone localhost/IN: loaded serial 1
Feb  9 23:39:08 pays-dolmes1 named[2859]: running
Feb  9 23:39:08 pays-dolmes1 dnsmasq[2922]: started, version 2.35 cachesize 150
Feb  9 23:39:08 pays-dolmes1 dnsmasq[2922]: compile time options: IPv6 GNU-getopt no-ISC-leasefile DBus I18N 
Feb  9 23:39:08 pays-dolmes1 dnsmasq[2922]: warning: setting capabilities failed: Operation not permitted
Feb  9 23:39:08 pays-dolmes1 dnsmasq[2922]: running as root
Feb  9 23:39:08 pays-dolmes1 dnsmasq[2922]: reading /var/run/dnsmasq/resolv.conf
Feb  9 23:39:08 pays-dolmes1 dnsmasq[2922]: using nameserver 80.10.246.3#53
Feb  9 23:39:08 pays-dolmes1 dnsmasq[2922]: using nameserver 80.10.246.130#53
Feb  9 23:39:08 pays-dolmes1 dnsmasq[2922]: using nameserver 192.168.1.1#53
Feb  9 23:39:08 pays-dolmes1 dnsmasq[2922]: ignoring nameserver 127.0.0.1 - local interface
Feb  9 23:39:08 pays-dolmes1 dnsmasq[2922]: read /etc/hosts - 9 addresses
Feb  9 23:39:09 pays-dolmes1 mysqld_safe[3060]: started
Feb  9 23:39:09 pays-dolmes1 mysqld[3063]: 080209 23:39:09  InnoDB: Started; log sequence number 0 43655
Feb  9 23:39:10 pays-dolmes1 mysqld[3063]: 080209 23:39:10 [Note] /usr/sbin/mysqld: ready for connections.
Feb  9 23:39:10 pays-dolmes1 mysqld[3063]: Version: '5.0.32-Debian_7etch5-log'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  Debian etch distribution
Feb  9 23:39:10 pays-dolmes1 /etc/mysql/debian-start[3101]: Upgrading MySQL tables if necessary.
Feb  9 23:39:12 pays-dolmes1 /etc/mysql/debian-start[3206]: Checking for crashed MySQL tables.
###########                                                                                                ##############
###########                                                                                                ##############
###########Feb  9 23:39:14 pays-dolmes1 avahi-daemon[3251]: cap_set_proc() failed: Operation not permitted ##############
Feb  9 23:39:16 pays-dolmes1 kernel: [   68.438870] eth1: no IPv6 routers present
Feb  9 23:40:04 pays-dolmes1 rpc.statd[3514]: Version 1.0.10 Starting
Feb  9 23:40:05 pays-dolmes1 ntpd[3530]: ntpd 4.2.2p4@1.1585-o Sun Mar  4 13:05:22 UTC 2007 (1)
Feb  9 23:40:05 pays-dolmes1 ntpd[3531]: precision = 2.000 usec
Feb  9 23:40:05 pays-dolmes1 ntpd[3531]: Listening on interface wildcard, 0.0.0.0#123 Disabled
Feb  9 23:40:05 pays-dolmes1 ntpd[3531]: Listening on interface wildcard, ::#123 Disabled
Feb  9 23:40:05 pays-dolmes1 ntpd[3531]: Listening on interface lo, ::1#123 Enabled
Feb  9 23:40:05 pays-dolmes1 ntpd[3531]: Listening on interface eth1, fe80::216:17ff:fe88:4a9#123 Enabled
Feb  9 23:40:05 pays-dolmes1 ntpd[3531]: Listening on interface lo, 127.0.0.1#123 Enabled
Feb  9 23:40:05 pays-dolmes1 ntpd[3531]: Listening on interface eth1, 192.168.1.2#123 Enabled
Feb  9 23:40:05 pays-dolmes1 ntpd[3531]: kernel time sync status 0040
Feb  9 23:40:05 pays-dolmes1 ntpd[3531]: frequency initialized 0.000 PPM from /var/lib/ntp/ntp.drift
Feb  9 23:40:05 pays-dolmes1 /usr/sbin/cron[3547]: (CRON) INFO (pidfile fd = 3)
Feb  9 23:40:05 pays-dolmes1 /usr/sbin/cron[3548]: (CRON) STARTUP (fork ok)
Feb  9 23:40:05 pays-dolmes1 /usr/sbin/cron[3548]: (CRON) INFO (Running @reboot jobs)
Feb  9 23:40:06 pays-dolmes1 portsentry[3578]: adminalert: PortSentry 1.2 is starting. 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 1 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 11 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 15 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 79 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 111 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: ERROR: Socket 111 is in use and will not be monitored. Attempting to continue 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 119 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 143 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 540 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 635 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 1080 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 1524 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 2000 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 5742 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 6667 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 12345 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 12346 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 20034 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 27665 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 31337 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 32771 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 32772 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 32773 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 32774 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 40421 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 49724 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: Going into stealth listen mode on TCP port: 54320 
Feb  9 23:40:06 pays-dolmes1 portsentry[3585]: adminalert: PortSentry is now active and listening. 
Feb  9 23:40:06 pays-dolmes1 portsentry[3588]: adminalert: PortSentry 1.2 is starting. 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 1 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 7 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 9 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 69 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 161 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 162 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 513 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 635 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 640 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 641 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 700 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 37444 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 34555 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 31335 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 32770 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 32771 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 32772 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 32773 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 32774 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 31337 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: Going into stealth listen mode on UDP port: 54321 
Feb  9 23:40:06 pays-dolmes1 portsentry[3589]: adminalert: PortSentry is now active and listening. 
Feb  9 23:42:44 pays-dolmes1 ntpd[3788]: signal_no_reset: signal 17 had flags 4000000
Feb  9 23:43:26 pays-dolmes1 ntpd_initres[3788]: host name not found: 0.debian.pool.ntp.org
Feb  9 23:43:26 pays-dolmes1 ntpd_initres[3788]: couldn't resolve `0.debian.pool.ntp.org', giving up on it
Feb  9 23:44:06 pays-dolmes1 ntpd_initres[3788]: host name not found: 1.debian.pool.ntp.org
Feb  9 23:44:06 pays-dolmes1 ntpd_initres[3788]: couldn't resolve `1.debian.pool.ntp.org', giving up on it
Feb  9 23:44:46 pays-dolmes1 ntpd_initres[3788]: host name not found: 2.debian.pool.ntp.org
Feb  9 23:44:46 pays-dolmes1 ntpd_initres[3788]: couldn't resolve `2.debian.pool.ntp.org', giving up on it
Feb  9 23:45:26 pays-dolmes1 ntpd_initres[3788]: host name not found: 3.debian.pool.ntp.org
Feb  9 23:45:26 pays-dolmes1 ntpd_initres[3788]: couldn't resolve `3.debian.pool.ntp.org', giving up on it

#########################################################################################################################################

Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] Linux version 2.6.23.14-pays-dolmes (root@pays-dolmes1) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Tue Feb 5 18:11:03 CET 2008
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] Command line: root=/dev/sda8 ro 
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] BIOS-provided physical RAM map:
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000007efd0000 (usable)
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]  BIOS-e820: 000000007efd0000 - 000000007efde000 (ACPI data)
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]  BIOS-e820: 000000007efde000 - 000000007f000000 (ACPI NVS)
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] Entering add_active_range(0, 256, 520144) 1 entries of 256 used
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] end_pfn_map = 1048576
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] DMI present.
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] ACPI: RSDP 000F8510, 0014 (r0 ACPIAM)
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] ACPI: RSDT 7EFD0000, 0030 (r1 A M I  OEMRSDT   7000606 MSFT       97)
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] ACPI: FACP 7EFD0200, 0084 (r2 A M I  OEMFACP   7000606 MSFT       97)
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] ACPI: DSDT 7EFD0440, 47DC (r1  1ADIF 1ADIF006        6 INTL 20051117)
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] ACPI: FACS 7EFDE000, 0040
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] ACPI: MCFG 7EFD0400, 003C (r1 A M I  OEMMCFG   7000606 MSFT       97)
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] ACPI: OEMB 7EFDE040, 0060 (r1 A M I  AMI_OEM   7000606 MSFT       97)
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] Entering add_active_range(0, 256, 520144) 1 entries of 256 used
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] Zone PFN ranges:
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]   DMA             0 ->     4096
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]   DMA32        4096 ->  1048576
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]   Normal    1048576 ->  1048576
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] Movable zone start PFN for each node
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] early_node_map[2] active PFN ranges
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]     0:        0 ->      159
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]     0:      256 ->   520144
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] On node 0 totalpages: 520047
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]   DMA zone: 56 pages used for memmap
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]   DMA zone: 1185 pages reserved
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]   DMA zone: 2758 pages, LIFO batch:0
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]   DMA32 zone: 7055 pages used for memmap
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]   DMA32 zone: 508993 pages, LIFO batch:31
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]   Normal zone: 0 pages used for memmap
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000]   Movable zone: 0 pages used for memmap
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] Nvidia board detected. Ignoring ACPI timer override.
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] If you got timer trouble try acpi_use_timer_override
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x4008
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] Intel MultiProcessor Specification v1.4
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] MPTABLE: OEM ID: nVidia   MPTABLE: Product ID: MCP51G/M     MPTABLE: APIC at: 0xFEE00000
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] Processor #0 (Bootup-CPU)
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] Processor #1
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] I/O APIC #2 at 0xFEC00000.
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] Setting APIC routing to flat
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] Processors: 2
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] Allocating PCI resources starting at 80000000 (gap: 7f000000:7fc00000)
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] PERCPU: Allocating 30376 bytes of per cpu data
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] Built 1 zonelists in Zone order.  Total pages: 511751
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] Kernel command line: root=/dev/sda8 ro 
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] Initializing CPU#0
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
Feb 10 00:27:07 pays-dolmes1 kernel: [    0.000000] Marking TSC unstable due to TSCs unsynchronized
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.224071] time.c: Detected 2611.961 MHz processor.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.228746] Console: colour VGA+ 80x25
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.228748] console [tty0] enabled
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.231491] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.233032] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.233563] Checking aperture...
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.233596] CPU 0: aperture @ f85e000000 size 32 MB
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.233628] Aperture too small (32 MB)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.239784] No AGP bridge found
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.255898] Memory: 2043632k/2080576k available (2844k kernel code, 36424k reserved, 1140k data, 212k init)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.315032] Calibrating delay using timer specific routine.. 5226.35 BogoMIPS (lpj=2613179)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.315128] Security Framework v1.0.0 initialized
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.315163] SELinux:  Disabled at boot.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.315207] Mount-cache hash table entries: 256
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.315334] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.315369] CPU: L2 Cache: 512K (64 bytes/line)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.315402] CPU: Physical Processor ID: 0
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.315433] CPU: Processor Core ID: 0
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.315483] SMP alternatives: switching to UP code
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.316040] ACPI: Core revision 20070126
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.317635] ACPI: setting ELCR to 0200 (from 0c20)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.318166] ExtINT not setup in hardware but reported by MP table
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.328601] Using local APIC timer interrupts.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.366916] result 12557523
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.366946] Detected 12.557 MHz APIC timer.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.367115] SMP alternatives: switching to SMP code
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.367635] Booting processor 1/2 APIC 0x1
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.377713] Initializing CPU#1
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.437989] Calibrating delay using timer specific routine.. 5223.02 BogoMIPS (lpj=2611514)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.437994] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.437996] CPU: L2 Cache: 512K (64 bytes/line)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.437998] CPU: Physical Processor ID: 0
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.437999] CPU: Processor Core ID: 1
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.438066] AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.439011] Brought up 2 CPUs
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.439568] NET: Registered protocol family 16
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.439714] ACPI: bus type pci registered
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.439806] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.439840] PCI: Not using MMCONFIG.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.439871] PCI: Using configuration type 1
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.442861] ACPI: EC: Look up EC in DSDT
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.446721] ACPI: Interpreter enabled
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.446754] ACPI: (supports S0 S1 S3 S5)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.446870] ACPI: Using PIC for interrupt routing
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.447072] Error attaching device data
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.447107] Error attaching device data
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.454179] ACPI: PCI Root Bridge [PCI0] (0000:00)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.455013] PCI: Transparent bridge - 0000:00:10.0
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.455074] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.455239] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.455307] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.455373] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PA._PRT]
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.455455] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.463165] ACPI: PCI Interrupt Link [LNKA] (IRQs *10 11 14 15)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.463438] ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11 14 15) *0, disabled.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.463746] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11 14 15) *0, disabled.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.464061] ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11 14 15) *0, disabled.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.464369] ACPI: PCI Interrupt Link [LNEA] (IRQs 10 11 14 15) *0, disabled.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.464677] ACPI: PCI Interrupt Link [LNEB] (IRQs 10 11 14 15) *0, disabled.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.464986] ACPI: PCI Interrupt Link [LNEC] (IRQs *10 11 14 15)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.465256] ACPI: PCI Interrupt Link [LNED] (IRQs 10 11 14 15) *0, disabled.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.465564] ACPI: PCI Interrupt Link [LUB0] (IRQs 5 7 10 *11 14 15)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.465872] ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7 *10 11 14 15)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.466180] ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 10 *11 14 15)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.466488] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 *11 14 15)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.466775] ACPI: PCI Interrupt Link [LACI] (IRQs 5 7 10 11 14 15) *0, disabled.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.467130] ACPI: PCI Interrupt Link [LMC9] (IRQs 5 7 10 11 14 15) *0, disabled.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.467483] ACPI: PCI Interrupt Link [LSMB] (IRQs *5 7 10 11 14 15)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.467789] ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 10 *11 14 15)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.468097] ACPI: PCI Interrupt Link [LSA0] (IRQs *5 7 14 15)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.468367] ACPI: PCI Interrupt Link [LSA1] (IRQs *5 7 14 15)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.468663] ACPI: PCI Interrupt Link [LATA] (IRQs 5 7 10 11 14 15) *0, disabled.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.468973] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  72, should be 6D [20070126]
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.469061] Linux Plug and Play Support v0.97 (c) Adam Belay
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.469111] pnp: PnP ACPI init
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.469147] ACPI: bus type pnp registered
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.472972] pnp: PnP ACPI: found 15 devices
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.473007] ACPI: ACPI bus type pnp unregistered
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.473172] SCSI subsystem initialized
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.473230] libata version 2.21 loaded.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.473292] PCI: Using ACPI for IRQ routing
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.473325] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479028] pnp: 00:07: iomem range 0xfefe0000-0xfefe01ff has been reserved
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479067] pnp: 00:08: iomem range 0xfea80000-0xfeabffff has been reserved
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479102] pnp: 00:08: iomem range 0xfee01000-0xfeefffff has been reserved
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479139] pnp: 00:09: iomem range 0xfec00000-0xfec00fff could not be reserved
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479182] pnp: 00:09: iomem range 0xfee00000-0xfee00fff could not be reserved
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479228] pnp: 00:0c: ioport range 0xa00-0xa0f has been reserved
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479263] pnp: 00:0c: ioport range 0xa10-0xa1f has been reserved
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479299] pnp: 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479337] pnp: 00:0e: iomem range 0x0-0x9ffff could not be reserved
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479371] pnp: 00:0e: iomem range 0xc0000-0xcffff has been reserved
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479406] pnp: 00:0e: iomem range 0xe0000-0xfffff could not be reserved
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479441] pnp: 00:0e: iomem range 0x100000-0x7fffffff could not be reserved
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479675] PCI: Bridge: 0000:00:02.0
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479706]   IO window: disabled.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479737]   MEM window: disabled.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479768]   PREFETCH window: disabled.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479800] PCI: Bridge: 0000:00:03.0
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479831]   IO window: disabled.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479862]   MEM window: disabled.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479893]   PREFETCH window: disabled.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479925] PCI: Bridge: 0000:00:04.0
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479956]   IO window: disabled.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.479979] Time: acpi_pm clocksource has been installed.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.480021]   MEM window: disabled.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.480052]   PREFETCH window: disabled.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.480084] PCI: Bridge: 0000:00:10.0
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.480115]   IO window: e000-efff
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.480147]   MEM window: feb00000-febfffff
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.480179]   PREFETCH window: disabled.
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.480220] PCI: Setting latency timer of device 0000:00:02.0 to 64
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.480225] PCI: Setting latency timer of device 0000:00:03.0 to 64
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.480230] PCI: Setting latency timer of device 0000:00:04.0 to 64
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.480235] PCI: Setting latency timer of device 0000:00:10.0 to 64
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.480259] NET: Registered protocol family 2
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.490030] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.490502] TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.492039] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.492575] TCP: Hash tables configured (established 131072 bind 65536)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.492611] TCP reno registered
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.495827] audit: initializing netlink socket (disabled)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.495872] audit(1202599583.232:1): initialized
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.496030] VFS: Disk quotas dquot_6.5.1
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.496067] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.496164] NTFS driver 2.1.28 [Flags: R/W].
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.496218] SGI XFS with security attributes, realtime, large block/inode numbers, no debug enabled
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.496419] SGI XFS Quota Management subsystem
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.496467] io scheduler noop registered
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.496498] io scheduler anticipatory registered (default)
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.496531] io scheduler deadline registered
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.496572] io scheduler cfq registered
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.496612] Boot video device is 0000:00:05.0
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.513375] Real Time Clock Driver v1.12ac
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.513425] Linux agpgart interface v0.102
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.513457] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.517728] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.518164] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.518750] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.518861] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.518896] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Feb 10 00:27:07 pays-dolmes1 kernel: [  126.518981] Probing IDE interface ide0...
Feb 10 00:27:07 pays-dolmes1 kernel: [  127.191049] hda: HL-DT-ST DVDRAM GSA-H10N, ATAPI CD/DVD-ROM drive
Feb 10 00:27:07 pays-dolmes1 kernel: [  127.904945] hdb: HL-DT-STDVD-ROM GDR8164B, ATAPI CD/DVD-ROM drive
Feb 10 00:27:07 pays-dolmes1 kernel: [  127.955782] Probing IDE interface ide1...
Feb 10 00:27:07 pays-dolmes1 kernel: [  128.474728] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Feb 10 00:27:07 pays-dolmes1 kernel: [  128.477037] hda: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
Feb 10 00:27:07 pays-dolmes1 kernel: [  128.477205] Uniform CD-ROM driver Revision: 3.20
Feb 10 00:27:07 pays-dolmes1 kernel: [  128.486725] hdb: ATAPI 52X DVD-ROM drive, 256kB Cache
Feb 10 00:27:07 pays-dolmes1 kernel: [  128.492875] st: Version 20070203, fixed bufsize 32768, s/g segs 256
Feb 10 00:27:07 pays-dolmes1 kernel: [  128.493038] sata_nv 0000:00:0e.0: version 3.5
Feb 10 00:27:07 pays-dolmes1 kernel: [  128.493274] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 5
Feb 10 00:27:07 pays-dolmes1 kernel: [  128.493308] PCI: setting IRQ 5 as level-triggered
Feb 10 00:27:07 pays-dolmes1 kernel: [  128.493311] ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [LSA0] -> GSI 5 (level, low) -> IRQ 5
Feb 10 00:27:07 pays-dolmes1 kernel: [  128.493736] PCI: Setting latency timer of device 0000:00:0e.0 to 64
Feb 10 00:27:07 pays-dolmes1 kernel: [  128.493822] scsi0 : sata_nv
Feb 10 00:27:07 pays-dolmes1 kernel: [  128.493943] scsi1 : sata_nv
Feb 10 00:27:07 pays-dolmes1 kernel: [  128.494007] ata1: SATA max UDMA/133 cmd 0x000000000001d800 ctl 0x000000000001d482 bmdma 0x000000000001d000 irq 5
Feb 10 00:27:07 pays-dolmes1 kernel: [  128.494054] ata2: SATA max UDMA/133 cmd 0x000000000001d400 ctl 0x000000000001d082 bmdma 0x000000000001d008 irq 5
Feb 10 00:27:07 pays-dolmes1 kernel: [  128.947660] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Feb 10 00:27:07 pays-dolmes1 kernel: [  128.951799] ata1.00: ATA-7: Maxtor 6V250F0, VA111900, max UDMA/133
Feb 10 00:27:07 pays-dolmes1 kernel: [  128.951834] ata1.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 0/32)
Feb 10 00:27:07 pays-dolmes1 kernel: [  128.958777] ata1.00: configured for UDMA/133
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.412591] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.416708] ata2.00: ATA-7: Maxtor 6V250F0, VA111900, max UDMA/133
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.416742] ata2.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 0/32)
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.423683] ata2.00: configured for UDMA/133
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.423777] scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6V250F0   VA11 PQ: 0 ANSI: 5
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.423893] sd 0:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.423935] sd 0:0:0:0: [sda] Write Protect is off
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.423967] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.423978] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.424053] sd 0:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.424093] sd 0:0:0:0: [sda] Write Protect is off
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.424128] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.424138] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.424184]  sda: sda1 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 sda13 >
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.531994] sd 0:0:0:0: [sda] Attached SCSI disk
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.532079] sd 0:0:0:0: Attached scsi generic sg0 type 0
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.532159] scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6V250F0   VA11 PQ: 0 ANSI: 5
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.532268] sd 1:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.532308] sd 1:0:0:0: [sdb] Write Protect is off
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.532340] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.532350] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.532412] sd 1:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.532451] sd 1:0:0:0: [sdb] Write Protect is off
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.532484] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.532493] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.532537]  sdb: sdb1 < sdb5 sdb6 sdb7 sdb8 sdb9 sdb10 sdb11 sdb12 sdb13 >
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.641887] sd 1:0:0:0: [sdb] Attached SCSI disk
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.641964] sd 1:0:0:0: Attached scsi generic sg1 type 0
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.642229] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 5
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.642263] ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [LSA1] -> GSI 5 (level, low) -> IRQ 5
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.642521] PCI: Setting latency timer of device 0000:00:0f.0 to 64
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.642592] scsi2 : sata_nv
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.642712] scsi3 : sata_nv
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.642776] ata3: SATA max UDMA/133 cmd 0x000000000001cc00 ctl 0x000000000001c882 bmdma 0x000000000001c400 irq 5
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.642823] ata4: SATA max UDMA/133 cmd 0x000000000001c800 ctl 0x000000000001c482 bmdma 0x000000000001c408 irq 5
Feb 10 00:27:07 pays-dolmes1 kernel: [  129.945510] ata3: SATA link down (SStatus 0 SControl 300)
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.259462] ata4: SATA link down (SStatus 0 SControl 300)
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.270002] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.272490] serio: i8042 KBD port at 0x60,0x64 irq 1
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.272525] serio: i8042 AUX port at 0x60,0x64 irq 12
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.272651] mice: PS/2 mouse device common for all mice
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.272776] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.272951] ip_tables: (C) 2000-2006 Netfilter Core Team
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.273006] TCP cubic registered
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.273043] NET: Registered protocol family 1
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.273076] ieee80211: 802.11 data/management/control stack, git-1.1.13
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.273110] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.273154] ieee80211_crypt: registered algorithm 'NULL'
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.273155] ieee80211_crypt: registered algorithm 'WEP'
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.289539] input: AT Translated Set 2 keyboard as /class/input/input0
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.396449] ReiserFS: sda8: found reiserfs format "3.6" with standard journal
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.396488] ReiserFS: sda8: using ordered data mode
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.400294] ReiserFS: sda8: journal params: device sda8, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.401658] ReiserFS: sda8: checking transaction log (sda8)
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.435436] ReiserFS: sda8: Using r5 hash to sort names
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.435492] VFS: Mounted root (reiserfs filesystem) readonly.
Feb 10 00:27:07 pays-dolmes1 kernel: [  130.435538] Freeing unused kernel memory: 212k freed
Feb 10 00:27:07 pays-dolmes1 kernel: [  131.687417] ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not present [20070126]
Feb 10 00:27:07 pays-dolmes1 kernel: [  131.687517] ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not present [20070126]
Feb 10 00:27:07 pays-dolmes1 kernel: [  131.689067] input: Power Button (FF) as /class/input/input1
Feb 10 00:27:07 pays-dolmes1 kernel: [  131.689122] ACPI: Power Button (FF) [PWRF]
Feb 10 00:27:07 pays-dolmes1 kernel: [  131.689218] input: Power Button (CM) as /class/input/input2
Feb 10 00:27:07 pays-dolmes1 kernel: [  131.689268] ACPI: Power Button (CM) [PWRB]
Feb 10 00:27:07 pays-dolmes1 kernel: [  131.961832] input: PC Speaker as /class/input/input3
Feb 10 00:27:07 pays-dolmes1 kernel: [  131.999687] usbcore: registered new interface driver usbfs
Feb 10 00:27:07 pays-dolmes1 kernel: [  131.999748] usbcore: registered new interface driver hub
Feb 10 00:27:07 pays-dolmes1 kernel: [  131.999803] usbcore: registered new device driver usb
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.002476] ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.002766] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 10
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.002803] PCI: setting IRQ 10 as level-triggered
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.002807] ACPI: PCI Interrupt 0000:00:0b.1[B] -> Link [LUB2] -> GSI 10 (level, low) -> IRQ 10
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.003084] PCI: Setting latency timer of device 0000:00:0b.1 to 64
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.003090] ehci_hcd 0000:00:0b.1: EHCI Host Controller
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.003366] drivers/usb/core/inode.c: creating file 'devices'
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.003372] drivers/usb/core/inode.c: creating file '001'
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.003377] ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus number 1
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.003433] ehci_hcd 0000:00:0b.1: reset hcs_params 0x101888 dbg=1 cc=1 pcc=8 !ppc ports=8
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.003440] ehci_hcd 0000:00:0b.1: reset portroute 0 0 0 0 0 0 0 0 
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.003443] ehci_hcd 0000:00:0b.1: reset hcc_params a086 caching frame 256/512/1024 park
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.003468] ehci_hcd 0000:00:0b.1: park 0
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.003475] ehci_hcd 0000:00:0b.1: debug port 1
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.003509] PCI: cache line size of 64 is not supported by device 0000:00:0b.1
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.003511] ehci_hcd 0000:00:0b.1: supports USB remote wakeup
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.003523] ehci_hcd 0000:00:0b.1: irq 10, io mem 0xfeadfc00
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.003559] ehci_hcd 0000:00:0b.1: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.003565] ehci_hcd 0000:00:0b.1: init command 010009 (park)=0 ithresh=1 period=256 RUN
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.007790] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.007794] ohci_hcd: block sizes: ed 80 td 96
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.012792] ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.012862] usb usb1: default language 0x0409
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.012867] usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.012869] usb usb1: Product: EHCI Host Controller
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.012901] usb usb1: Manufacturer: Linux 2.6.23.14-pays-dolmes ehci_hcd
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.012935] usb usb1: SerialNumber: 0000:00:0b.1
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.012989] usb usb1: uevent
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.013003] usb usb1: usb_probe_device
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.013052] usb usb1: configuration #1 chosen from 1 choice
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.013089] usb usb1: adding 1-0:1.0 (config #1, interface 0)
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.013096] usb 1-0:1.0: uevent
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.013099] usb 1-0:1.0: uevent
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.013107] hub 1-0:1.0: usb_probe_interface
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.013109] hub 1-0:1.0: usb_probe_interface - got id
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.013110] hub 1-0:1.0: USB hub found
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.013147] hub 1-0:1.0: 8 ports detected
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.013179] hub 1-0:1.0: standalone hub
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.013180] hub 1-0:1.0: no power switching (usb 1.0)
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.013181] hub 1-0:1.0: individual port over-current protection
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.013182] hub 1-0:1.0: Single TT
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.013184] hub 1-0:1.0: TT requires at most 8 FS bit times (666 ns)
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.013186] hub 1-0:1.0: power on to power good time: 20ms
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.013189] hub 1-0:1.0: local power source is good
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.013191] hub 1-0:1.0: trying to enable port power on non-switchable hub
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.095284] forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.115172] drivers/usb/core/inode.c: creating file '001'
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.115207] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.115287] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x5000
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.115338] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x6000
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.115644] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 11
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.115678] PCI: setting IRQ 11 as level-triggered
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.115682] ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [LMAC] -> GSI 11 (level, low) -> IRQ 11
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.115768] PCI: Setting latency timer of device 0000:00:14.0 to 64
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.115773] forcedeth: using HIGHDMA
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.575355] input: ImPS/2 Generic Wheel Mouse as /class/input/input4
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.577936] parport_pc 00:06: reported by Plug and Play ACPI
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.578020] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.629444] eth0: forcedeth.c: subsystem: 01462:7252 bound to 0000:00:14.0
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.629917] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 11
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.629952] ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LUB0] -> GSI 11 (level, low) -> IRQ 11
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.630227] PCI: Setting latency timer of device 0000:00:0b.0 to 64
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.630233] ohci_hcd 0000:00:0b.0: OHCI Host Controller
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.630310] drivers/usb/core/inode.c: creating file '002'
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.630321] ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus number 2
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.630375] ohci_hcd 0000:00:0b.0: created debug files
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.630387] ohci_hcd 0000:00:0b.0: irq 11, io mem 0xfeade000
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.630732] net eth1: device_rename: sysfs_create_symlink failed (-17)
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684129] ohci_hcd 0000:00:0b.0: OHCI controller state
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684134] ohci_hcd 0000:00:0b.0: OHCI 1.0, NO legacy support registers
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684138] ohci_hcd 0000:00:0b.0: control 0x683 RWE RWC HCFS=operational CBSR=3
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684141] ohci_hcd 0000:00:0b.0: cmdstatus 0x00000 SOC=0
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684144] ohci_hcd 0000:00:0b.0: intrstatus 0x00000004 SF
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684146] ohci_hcd 0000:00:0b.0: intrenable 0x8000004a MIE RHSC RD WDH
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684152] ohci_hcd 0000:00:0b.0: hcca frame #0003
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684155] ohci_hcd 0000:00:0b.0: roothub.a 01001208 POTPGT=1 NOCP NPS NDP=8(8)
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684158] ohci_hcd 0000:00:0b.0: roothub.b 00000000 PPCM=0000 DR=0000
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684161] ohci_hcd 0000:00:0b.0: roothub.status 00008000 DRWE
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684164] ohci_hcd 0000:00:0b.0: roothub.portstatus [0] 0x00000100 PPS
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684167] ohci_hcd 0000:00:0b.0: roothub.portstatus [1] 0x00000100 PPS
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684170] ohci_hcd 0000:00:0b.0: roothub.portstatus [2] 0x00000100 PPS
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684174] ohci_hcd 0000:00:0b.0: roothub.portstatus [3] 0x00000100 PPS
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684177] ohci_hcd 0000:00:0b.0: roothub.portstatus [4] 0x00000100 PPS
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684180] ohci_hcd 0000:00:0b.0: roothub.portstatus [5] 0x00000100 PPS
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684183] ohci_hcd 0000:00:0b.0: roothub.portstatus [6] 0x00000100 PPS
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684186] ohci_hcd 0000:00:0b.0: roothub.portstatus [7] 0x00000100 PPS
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684201] usb usb2: default language 0x0409
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684206] usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684208] usb usb2: Product: OHCI Host Controller
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684243] usb usb2: Manufacturer: Linux 2.6.23.14-pays-dolmes ohci_hcd
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684277] usb usb2: SerialNumber: 0000:00:0b.0
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684329] usb usb2: uevent
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684344] usb usb2: usb_probe_device
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684383] usb usb2: configuration #1 chosen from 1 choice
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684420] usb usb2: adding 2-0:1.0 (config #1, interface 0)
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684427] usb 2-0:1.0: uevent
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684429] usb 2-0:1.0: uevent
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684438] hub 2-0:1.0: usb_probe_interface
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684439] hub 2-0:1.0: usb_probe_interface - got id
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684441] hub 2-0:1.0: USB hub found
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684479] hub 2-0:1.0: 8 ports detected
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684510] hub 2-0:1.0: standalone hub
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684511] hub 2-0:1.0: no power switching (usb 1.0)
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684513] hub 2-0:1.0: no over-current protection
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684514] hub 2-0:1.0: power on to power good time: 2ms
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684519] hub 2-0:1.0: local power source is good
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.684520] hub 2-0:1.0: trying to enable port power on non-switchable hub
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.786104] hub 2-0:1.0: state 7 ports 8 chg 0000 evt 0000
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.786139] drivers/usb/core/inode.c: creating file '001'
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.786535] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 11
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.786571] ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [LAZA] -> GSI 11 (level, low) -> IRQ 11
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.786834] PCI: Setting latency timer of device 0000:00:10.1 to 64
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.797885] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.811580] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.811622] ACPI: PCI Interrupt 0000:04:08.0[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
Feb 10 00:27:07 pays-dolmes1 kernel: [  132.862900] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[10]  MMIO=[febff800-febfffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
Feb 10 00:27:07 pays-dolmes1 kernel: [  133.058354] Adding 1951856k swap on /dev/sda12.  Priority:-1 extents:1 across:1951856k
Feb 10 00:27:07 pays-dolmes1 kernel: [  133.073886] Adding 1951856k swap on /dev/sdb12.  Priority:-2 extents:1 across:1951856k
Feb 10 00:27:07 pays-dolmes1 kernel: [  133.965936] ohci_hcd 0000:00:0b.0: auto-stop root hub
Feb 10 00:27:07 pays-dolmes1 kernel: [  134.122011] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[8817160004a90010]
Feb 10 00:27:07 pays-dolmes1 kernel: [  138.574828] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.002031] ReiserFS: sda13: found reiserfs format "3.6" with standard journal
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.002083] ReiserFS: sda13: using ordered data mode
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.006449] ReiserFS: sda13: journal params: device sda13, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.007876] ReiserFS: sda13: checking transaction log (sda13)
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.015919] ReiserFS: sda13: Using r5 hash to sort names
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.037251] ReiserFS: sda5: found reiserfs format "3.6" with standard journal
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.037290] ReiserFS: sda5: using ordered data mode
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.101482] ReiserFS: sda5: journal params: device sda5, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.102916] ReiserFS: sda5: checking transaction log (sda5)
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.113932] ReiserFS: sda5: Using r5 hash to sort names
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.131368] ReiserFS: sda11: found reiserfs format "3.6" with standard journal
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.131424] ReiserFS: sda11: using ordered data mode
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.167869] ReiserFS: sda11: journal params: device sda11, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.169392] ReiserFS: sda11: checking transaction log (sda11)
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.226723] ReiserFS: sda11: Using r5 hash to sort names
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.253766] ReiserFS: sda7: found reiserfs format "3.6" with standard journal
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.253807] ReiserFS: sda7: using ordered data mode
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.264873] ReiserFS: sda7: journal params: device sda7, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.266549] ReiserFS: sda7: checking transaction log (sda7)
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.279991] ReiserFS: sda7: Using r5 hash to sort names
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.296342] ReiserFS: sda9: found reiserfs format "3.6" with standard journal
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.296385] ReiserFS: sda9: using ordered data mode
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.306476] ReiserFS: sda9: journal params: device sda9, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.307864] ReiserFS: sda9: checking transaction log (sda9)
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.358083] ReiserFS: sda9: Using r5 hash to sort names
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.411872] ReiserFS: sda10: found reiserfs format "3.6" with standard journal
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.411925] ReiserFS: sda10: using ordered data mode
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.421519] ReiserFS: sda10: journal params: device sda10, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.422899] ReiserFS: sda10: checking transaction log (sda10)
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.451733] ReiserFS: sda10: Using r5 hash to sort names
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.494555] ReiserFS: sda6: found reiserfs format "3.6" with standard journal
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.494605] ReiserFS: sda6: using ordered data mode
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.503115] ReiserFS: sda6: journal params: device sda6, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.504594] ReiserFS: sda6: checking transaction log (sda6)
Feb 10 00:27:07 pays-dolmes1 kernel: [  161.541247] ReiserFS: sda6: Using r5 hash to sort names
Feb 10 00:27:07 pays-dolmes1 kernel: [  163.155250] NET: Registered protocol family 17
Feb 10 00:27:07 pays-dolmes1 kernel: [  167.784439] NET: Registered protocol family 10
Feb 10 00:27:07 pays-dolmes1 kernel: [  167.784545] lo: Disabled Privacy Extensions
Feb 10 00:27:07 pays-dolmes1 kernel: [  170.218584] Capability LSM initialized
Feb 10 00:27:07 pays-dolmes1 named[2992]: starting BIND 9.3.4 -u bind
Feb 10 00:27:07 pays-dolmes1 named[2992]: found 2 CPUs, using 2 worker threads
Feb 10 00:27:07 pays-dolmes1 named[2992]: loading configuration from '/etc/bind/named.conf'
Feb 10 00:27:07 pays-dolmes1 named[2992]: listening on IPv6 interfaces, port 53
Feb 10 00:27:07 pays-dolmes1 named[2992]: listening on IPv4 interface lo, 127.0.0.1#53
Feb 10 00:27:07 pays-dolmes1 named[2992]: listening on IPv4 interface eth1, 192.168.1.2#53
Feb 10 00:27:07 pays-dolmes1 named[2992]: command channel listening on 127.0.0.1#953
Feb 10 00:27:07 pays-dolmes1 named[2992]: command channel listening on ::1#953
Feb 10 00:27:07 pays-dolmes1 named[2992]: zone 0.in-addr.arpa/IN: loaded serial 1
Feb 10 00:27:07 pays-dolmes1 named[2992]: zone 127.in-addr.arpa/IN: loaded serial 1
Feb 10 00:27:07 pays-dolmes1 named[2992]: zone 255.in-addr.arpa/IN: loaded serial 1
Feb 10 00:27:07 pays-dolmes1 named[2992]: zone localhost/IN: loaded serial 1
Feb 10 00:27:07 pays-dolmes1 named[2992]: running
Feb 10 00:27:08 pays-dolmes1 dnsmasq: failed to create listening socket: Address already in use
Feb 10 00:27:08 pays-dolmes1 dnsmasq: FAILED to start up
Feb 10 00:27:08 pays-dolmes1 mysqld_safe[3145]: started
Feb 10 00:27:09 pays-dolmes1 mysqld[3148]: 080210  0:27:09  InnoDB: Started; log sequence number 0 43655
Feb 10 00:27:09 pays-dolmes1 mysqld[3148]: 080210  0:27:09 [Note] /usr/sbin/mysqld: ready for connections.
Feb 10 00:27:09 pays-dolmes1 mysqld[3148]: Version: '5.0.32-Debian_7etch5-log'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  Debian etch distribution
Feb 10 00:27:09 pays-dolmes1 /etc/mysql/debian-start[3185]: Upgrading MySQL tables if necessary.
Feb 10 00:27:10 pays-dolmes1 /etc/mysql/debian-start[3277]: Checking for crashed MySQL tables.
Feb 10 00:27:11 pays-dolmes1 kernel: [  174.311546] tsdev (compaq touchscreen emulation) is scheduled for removal.
Feb 10 00:27:11 pays-dolmes1 kernel: [  174.311548] See Documentation/feature-removal-schedule.txt for details.
#########Feb 10 00:27:13 pays-dolmes1 avahi-daemon[3334]: Found user 'avahi' (UID 104) and group 'avahi' (GID 105).
#########Feb 10 00:27:13 pays-dolmes1 avahi-daemon[3334]: Successfully dropped root privileges.
#########Feb 10 00:27:13 pays-dolmes1 avahi-daemon[3334]: avahi-daemon 0.6.16 starting up.
#########Feb 10 00:27:13 pays-dolmes1 avahi-daemon[3334]: Successfully called chroot().
#########Feb 10 00:27:13 pays-dolmes1 avahi-daemon[3334]: Successfully dropped remaining capabilities.
#########Feb 10 00:27:13 pays-dolmes1 avahi-daemon[3334]: No service found in /etc/avahi/services.
#########Feb 10 00:27:13 pays-dolmes1 avahi-daemon[3334]: New relevant interface eth1.IPv4 for mDNS.
#########Feb 10 00:27:13 pays-dolmes1 avahi-daemon[3334]: Joining mDNS multicast group on interface eth1.IPv4 with address 192.168.1.2.
#########Feb 10 00:27:13 pays-dolmes1 avahi-daemon[3334]: Network interface enumeration completed.
#########Feb 10 00:27:13 pays-dolmes1 avahi-daemon[3334]: Registering new address record for 192.168.1.2 on eth1.
#########Feb 10 00:27:13 pays-dolmes1 avahi-daemon[3334]: Registering HINFO record with values 'X86_64'/'LINUX'.
#########Feb 10 00:27:14 pays-dolmes1 avahi-daemon[3334]: Server startup complete. Host name is pays-dolmes1.local. Local service cookie is 3161239924.
Feb 10 00:27:16 pays-dolmes1 kernel: [  178.578501] eth1: no IPv6 routers present
Feb 10 00:27:44 pays-dolmes1 rpc.statd[3592]: Version 1.0.10 Starting
Feb 10 00:27:44 pays-dolmes1 ntpd[3607]: ntpd 4.2.2p4@1.1585-o Sun Mar  4 13:05:22 UTC 2007 (1)
Feb 10 00:27:44 pays-dolmes1 ntpd[3608]: precision = 1.000 usec
Feb 10 00:27:44 pays-dolmes1 ntpd[3608]: Listening on interface wildcard, 0.0.0.0#123 Disabled
Feb 10 00:27:44 pays-dolmes1 ntpd[3608]: Listening on interface wildcard, ::#123 Disabled
Feb 10 00:27:44 pays-dolmes1 ntpd[3608]: Listening on interface lo, ::1#123 Enabled
Feb 10 00:27:44 pays-dolmes1 ntpd[3608]: Listening on interface eth1, fe80::216:17ff:fe88:4a9#123 Enabled
Feb 10 00:27:44 pays-dolmes1 ntpd[3608]: Listening on interface lo, 127.0.0.1#123 Enabled
Feb 10 00:27:44 pays-dolmes1 ntpd[3608]: Listening on interface eth1, 192.168.1.2#123 Enabled
Feb 10 00:27:44 pays-dolmes1 ntpd[3608]: kernel time sync status 0040
Feb 10 00:27:44 pays-dolmes1 ntpd[3608]: frequency initialized 0.000 PPM from /var/lib/ntp/ntp.drift
Feb 10 00:27:44 pays-dolmes1 /usr/sbin/cron[3624]: (CRON) INFO (pidfile fd = 3)
Feb 10 00:27:44 pays-dolmes1 /usr/sbin/cron[3625]: (CRON) STARTUP (fork ok)
Feb 10 00:27:44 pays-dolmes1 /usr/sbin/cron[3625]: (CRON) INFO (Running @reboot jobs)
Feb 10 00:27:45 pays-dolmes1 portsentry[3660]: adminalert: PortSentry 1.2 is starting. 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 1 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 11 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 15 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 79 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 111 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: ERROR: Socket 111 is in use and will not be monitored. Attempting to continue 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 119 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 143 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 540 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 635 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 1080 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 1524 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 2000 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 5742 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 6667 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 12345 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 12346 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 20034 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 27665 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 31337 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 32771 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 32772 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 32773 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 32774 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 40421 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 49724 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: Going into stealth listen mode on TCP port: 54320 
Feb 10 00:27:45 pays-dolmes1 portsentry[3661]: adminalert: PortSentry is now active and listening. 
Feb 10 00:27:45 pays-dolmes1 portsentry[3664]: adminalert: PortSentry 1.2 is starting. 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 1 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 7 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 9 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 69 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 161 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 162 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 513 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 635 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 640 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 641 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 700 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 37444 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 34555 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 31335 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 32770 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: ERROR: Socket 32770 is in use and will not be monitored. Attempting to continue 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 32771 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: ERROR: Socket 32771 is in use and will not be monitored. Attempting to continue 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 32772 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: ERROR: Socket 32772 is in use and will not be monitored. Attempting to continue 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 32773 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: ERROR: Socket 32773 is in use and will not be monitored. Attempting to continue 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 32774 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 31337 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: Going into stealth listen mode on UDP port: 54321 
Feb 10 00:27:45 pays-dolmes1 portsentry[3665]: adminalert: PortSentry is now active and listening. 
Feb 10 00:30:24 pays-dolmes1 ntpd[3845]: signal_no_reset: signal 17 had flags 4000000
Feb 10 00:31:06 pays-dolmes1 ntpd_initres[3845]: host name not found: 0.debian.pool.ntp.org
Feb 10 00:31:06 pays-dolmes1 ntpd_initres[3845]: couldn't resolve `0.debian.pool.ntp.org', giving up on it
Feb 10 00:31:46 pays-dolmes1 ntpd_initres[3845]: host name not found: 1.debian.pool.ntp.org
Feb 10 00:31:46 pays-dolmes1 ntpd_initres[3845]: couldn't resolve `1.debian.pool.ntp.org', giving up on it
Feb 10 00:32:26 pays-dolmes1 ntpd_initres[3845]: host name not found: 2.debian.pool.ntp.org
Feb 10 00:32:26 pays-dolmes1 ntpd_initres[3845]: couldn't resolve `2.debian.pool.ntp.org', giving up on it
Feb 10 00:33:06 pays-dolmes1 ntpd_initres[3845]: host name not found: 3.debian.pool.ntp.org
Feb 10 00:33:06 pays-dolmes1 ntpd_initres[3845]: couldn't resolve `3.debian.pool.ntp.org', giving up on it

--------------010803040504040203050400--
