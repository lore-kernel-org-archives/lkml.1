Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbZCLHVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbZCLHVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 03:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbZCLHVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 03:21:15 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:62141 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750943AbZCLHVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 03:21:12 -0400
Date: Thu, 12 Mar 2009 08:21:09 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: dmesg of yesterday released Mac Mini
Message-ID: <20090312072109.GA18065@cip.informatik.uni-erlangen.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	LKML <linux-kernel@vger.kernel.org>
References: <20090304151721.GA14591@cip.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304151721.GA14591@cip.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.15 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
here is the output of (dmesg; lspci; lspci -n)

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.26-1-686 (Debian 2.6.26-13) (waldi@debian.org) (gcc version 4.1.3 20080704 (prerelease) (Debian 4.1.2-24)) #1 SMP Sat Jan 10 18:29:31 UTC 2009
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000080000000 (usable)
[    0.000000]  BIOS-e820: 0000000080000000 - 0000000090000000 (reserved)
[    0.000000]  BIOS-e820: 0000000090000000 - 00000000be4b7000 (usable)
[    0.000000]  BIOS-e820: 00000000be4b7000 - 00000000be6b8000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000be6b8000 - 00000000be86b000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000be86b000 - 00000000be86d000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000be86d000 - 00000000be86e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000be86e000 - 00000000be870000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000be870000 - 00000000bfec6000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfec6000 - 00000000bfec8000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfec8000 - 00000000bfec9000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfec9000 - 00000000bfecb000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfecb000 - 00000000bfecd000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfecd000 - 00000000bfedf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfedf000 - 00000000bfef9000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfef9000 - 00000000bfeff000 (reserved)
[    0.000000]  BIOS-e820: 00000000bfeff000 - 00000000bff00000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000d3400000 - 00000000d3401000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] Warning only 4GB will be used.
[    0.000000] Use a HIGHMEM64G enabled kernel.
[    0.000000] 3200MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Entering add_active_range(0, 0, 1048576) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->  1048576
[    0.000000] On node 0 totalpages: 1048576
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 6400 pages used for memmap
[    0.000000]   HighMem zone: 812800 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FE020, 0024 (r2 APPLE )
[    0.000000] ACPI: XSDT BFEEE1C0, 0074 (r1 APPLE   Apple00       81       1000013)
[    0.000000] ACPI: FACP BFEEC000, 00F4 (r3 APPLE   Apple00       81 Loki       5F)
[    0.000000] ACPI: DSDT BFEE0000, 50B8 (r1 APPLE   Macmini    30001 INTL 20061109)
[    0.000000] ACPI: FACS BFECD000, 0040
[    0.000000] ACPI: HPET BFEEB000, 0038 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: APIC BFEEA000, 0068 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: MCFG BFEE9000, 003C (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: ASF! BFEE8000, 00A5 (r32 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: SBST BFEE7000, 0030 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: ECDT BFEE6000, 0053 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: SSDT BFEC8000, 04DC (r1  APPLE    CpuPm     3000 INTL 20061109)
[    0.000000] ACPI: SSDT BFEDF000, 00A5 (r1 SataRe  SataPri     1000 INTL 20061109)
[    0.000000] ACPI: SSDT BFECC000, 009F (r1 SataRe  SataSec     1000 INTL 20061109)
[    0.000000] ACPI: DMI detected: Apple
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at d4000000 (gap: d3401000:1cbff000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 37960 bytes of per cpu data
[    0.000000] NR_CPUS: 8, nr_cpu_ids: 2
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1040384
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.26-1-686 root=/dev/sda3 ro
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Detected 2255.324 MHz processor.
[    0.004000] spurious 8259A interrupt: IRQ7.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] Memory: 2811424k/4194304k available (1769k kernel code, 42976k reserved, 752k data, 244k init, 1938140k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
[    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.004000]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.004000]       .init : 0xc037f000 - 0xc03bc000   ( 244 kB)
[    0.004000]       .data : 0xc02ba4ab - 0xc0376620   ( 752 kB)
[    0.004000]       .text : 0xc0100000 - 0xc02ba4ab   (1769 kB)
[    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.004000] hpet clockevent registered
[    0.083985] Calibrating delay using timer specific routine.. 4516.14 BogoMIPS (lpj=9032298)
[    0.084005] Security Framework initialized
[    0.084005] SELinux:  Disabled at boot.
[    0.084005] Capability LSM initialized
[    0.084005] Mount-cache hash table entries: 512
[    0.084005] Initializing cgroup subsys ns
[    0.084005] Initializing cgroup subsys cpuacct
[    0.084005] Initializing cgroup subsys devices
[    0.084005] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.084005] CPU: L2 cache: 3072K
[    0.084005] CPU: Physical Processor ID: 0
[    0.084005] CPU: Processor Core ID: 0
[    0.084005] Intel machine check architecture supported.
[    0.084005] Intel machine check reporting enabled on CPU#0.
[    0.084005] using mwait in idle threads.
[    0.084005] Checking 'hlt' instruction... OK.
[    0.100006] ACPI: Core revision 20080321
[    0.108214] ENABLING IO-APIC IRQs
[    0.108481] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.148271] CPU0: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz stepping 0a
[    0.152009] Booting processor 1/1 ip 6000
[    0.160010] Initializing CPU#1
[    0.160010] Calibrating delay using timer specific routine.. 4510.62 BogoMIPS (lpj=9021257)
[    0.160010] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.160010] CPU: L2 cache: 3072K
[    0.160010] CPU: Physical Processor ID: 0
[    0.160010] CPU: Processor Core ID: 1
[    0.160010] Intel machine check architecture supported.
[    0.160010] Intel machine check reporting enabled on CPU#1.
[    0.240015] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz stepping 0a
[    0.240015] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.244015] Brought up 2 CPUs
[    0.244015] Total of 2 processors activated (9026.77 BogoMIPS).
[    0.244015] CPU0 attaching sched-domain:
[    0.244015]  domain 0: span 0-1
[    0.244015]   groups: 0 1
[    0.244015] CPU1 attaching sched-domain:
[    0.244015]  domain 0: span 0-1
[    0.244015]   groups: 1 0
[    0.244015] net_namespace: 660 bytes
[    0.244015] Booting paravirtualized kernel on bare hardware
[    0.244015] NET: Registered protocol family 16
[    0.244015] ACPI: bus type pci registered
[    0.244015] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
[    0.244015] PCI: Not using MMCONFIG.
[    0.245738] PCI: Using configuration type 1 for base access
[    0.245812] Setting up standard PCI resources
[    0.253200] ACPI: EC: EC description table is found, configuring boot EC
[    0.253460] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.270548] ACPI: BIOS _OSI(Linux) query ignored via DMI
[    0.271323] ACPI: Interpreter enabled
[    0.271384] ACPI: (supports S0 S3 S4 S5)
[    0.271636] ACPI: Using IOAPIC for interrupt routing
[    0.271774] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
[    0.279389] PCI: BIOS Bug: MCFG area at f0000000 is not reserved in ACPI motherboard resources
[    0.279465] PCI: Not using MMCONFIG.
[    0.292018] ACPI: EC: GPE = 0x3f, I/O: command/status = 0x66, data = 0x62
[    0.292018] ACPI: EC: driver started in interrupt mode
[    0.292018] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.296018] PCI: Transparent bridge - 0000:00:09.0
[    0.296018] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.296018] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IXVE._PRT]
[    0.373485] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 10 11 14 15) *0, disabled.
[    0.373485] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 10 11 14 15) *0, disabled.
[    0.373485] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 10 11 14 15) *0, disabled.
[    0.373485] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 10 11 14 15) *0, disabled.
[    0.373485] ACPI: PCI Interrupt Link [Z003] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.374421] ACPI: PCI Interrupt Link [Z004] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.377485] ACPI: PCI Interrupt Link [Z005] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.378418] ACPI: PCI Interrupt Link [Z006] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.379348] ACPI: PCI Interrupt Link [Z007] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.380283] ACPI: PCI Interrupt Link [Z008] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.381213] ACPI: PCI Interrupt Link [Z009] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.382142] ACPI: PCI Interrupt Link [Z00A] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.383071] ACPI: PCI Interrupt Link [Z00B] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.385919] ACPI: PCI Interrupt Link [Z00C] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.386849] ACPI: PCI Interrupt Link [Z00D] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.387781] ACPI: PCI Interrupt Link [Z00E] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.388711] ACPI: PCI Interrupt Link [Z00F] (IRQs 16 17 18 19 20 21 22 23) *10
[    0.389594] ACPI: PCI Interrupt Link [Z00G] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.390525] ACPI: PCI Interrupt Link [Z00H] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.391455] ACPI: PCI Interrupt Link [Z00I] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.392389] ACPI: PCI Interrupt Link [Z00J] (IRQs 16 17 18 19 20 21 22 23) *7
[    0.393267] ACPI: PCI Interrupt Link [Z00K] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.394197] ACPI: PCI Interrupt Link [Z00L] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.395129] ACPI: PCI Interrupt Link [Z00M] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.396064] ACPI: PCI Interrupt Link [Z00N] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.396994] ACPI: PCI Interrupt Link [Z00O] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.397922] ACPI: PCI Interrupt Link [Z00P] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.398852] ACPI: PCI Interrupt Link [Z00Q] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.399785] ACPI: PCI Interrupt Link [Z00R] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.400716] ACPI: PCI Interrupt Link [Z00S] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.401644] ACPI: PCI Interrupt Link [Z00T] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.402572] ACPI: PCI Interrupt Link [Z00U] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.403500] ACPI: PCI Interrupt Link [LSMB] (IRQs 16 17 18 19 20 21 22 23) *15
[    0.404387] ACPI: PCI Interrupt Link [LUS0] (IRQs 16 17 18 19 20 21 22 23) *11
[    0.405271] ACPI: PCI Interrupt Link [LUS2] (IRQs 16 17 18 19 20 21 22 23) *10
[    0.406155] ACPI: PCI Interrupt Link [LMAC] (IRQs 16 17 18 19 20 21 22 23) *14
[    0.407040] ACPI: PCI Interrupt Link [LAZA] (IRQs 16 17 18 19 20 21 22 23) *15
[    0.407929] ACPI: PCI Interrupt Link [LGPU] (IRQs 16 17 18 19 20 21 22 23) *11
[    0.408813] ACPI: PCI Interrupt Link [LPID] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.409746] ACPI: PCI Interrupt Link [LSI0] (IRQs 16 17 18 19 20 21 22 23) *11
[    0.410633] ACPI: PCI Interrupt Link [LSI1] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.411565] ACPI: PCI Interrupt Link [Z000] (IRQs 16 17 18 19 20 21 22 23) *7
[    0.412447] ACPI: PCI Interrupt Link [Z001] (IRQs 16 17 18 19 20 21 22 23) *5
[    0.413324] ACPI: PCI Interrupt Link [LPMU] (IRQs 16 17 18 19 20 21 22 23) *14
[    0.415619] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.415619] pnp: PnP ACPI init
[    0.415619] ACPI: bus type pnp registered
[    0.419214] pnp: PnP ACPI: found 8 devices
[    0.419275] ACPI: ACPI bus type pnp unregistered
[    0.419337] PnPBIOS: Disabled by ACPI PNP
[    0.420022] PCI: Using ACPI for IRQ routing
[    0.420022] PCI: Cannot allocate resource region 0 of device 0000:00:03.5
[    0.427828] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31, 31
[    0.428022] hpet0: 4 64-bit timers, 25000000 Hz
[    0.430619] system 00:01: iomem range 0xf0000000-0xf3ffffff could not be reserved
[    0.430699] system 00:04: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.430767] system 00:06: ioport range 0x400-0x47f has been reserved
[    0.430830] system 00:06: ioport range 0x480-0x4ff has been reserved
[    0.430894] system 00:06: ioport range 0x500-0x57f has been reserved
[    0.430957] system 00:06: ioport range 0x580-0x5ff has been reserved
[    0.431020] system 00:06: ioport range 0x800-0x87f has been reserved
[    0.431079] system 00:06: ioport range 0x880-0x8ff has been reserved
[    0.431143] system 00:06: ioport range 0x2140-0x217f has been reserved
[    0.431206] system 00:06: ioport range 0x2100-0x213f has been reserved
[    0.431269] system 00:06: ioport range 0x4d0-0x4d1 has been reserved
[    0.431332] system 00:06: ioport range 0x295-0x296 has been reserved
[    0.461639] PCI: Bridge: 0000:00:09.0
[    0.461639]   IO window: disabled.
[    0.461639]   MEM window: 0xd3300000-0xd33fffff
[    0.461639]   PREFETCH window: disabled.
[    0.461639] PCI: Bridge: 0000:00:10.0
[    0.461639]   IO window: 1000-1fff
[    0.461639]   MEM window: 0xd2000000-0xd30fffff
[    0.461639]   PREFETCH window: 0x00000000c0000000-0x00000000d1ffffff
[    0.461639] PCI: Bridge: 0000:00:15.0
[    0.461639]   IO window: disabled.
[    0.461639]   MEM window: 0xd3200000-0xd32fffff
[    0.461639]   PREFETCH window: disabled.
[    0.461639] PCI: Bridge: 0000:00:16.0
[    0.461700]   IO window: disabled.
[    0.461768]   MEM window: 0xd3100000-0xd31fffff
[    0.461833]   PREFETCH window: disabled.
[    0.461910] pci 0000:00:09.0: enabling device (0000 -> 0002)
[    0.461975] PCI: Setting latency timer of device 0000:00:09.0 to 64
[    0.461988] PCI: Setting latency timer of device 0000:00:10.0 to 64
[    0.462478] ACPI: PCI Interrupt Link [Z00F] enabled at IRQ 23
[    0.462542] ACPI: PCI Interrupt 0000:00:15.0[A] -> Link [Z00F] -> GSI 23 (level, low) -> IRQ 23
[    0.462714] PCI: Setting latency timer of device 0000:00:15.0 to 64
[    0.463198] ACPI: PCI Interrupt Link [Z00J] enabled at IRQ 22
[    0.463261] ACPI: PCI Interrupt 0000:00:16.0[A] -> Link [Z00J] -> GSI 22 (level, low) -> IRQ 22
[    0.465639] PCI: Setting latency timer of device 0000:00:16.0 to 64
[    0.465668] NET: Registered protocol family 2
[    0.479940] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.480233] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.480681] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.480935] TCP: Hash tables configured (established 131072 bind 65536)
[    0.480998] TCP reno registered
[    0.483947] NET: Registered protocol family 1
[    0.484114] checking if image is initramfs...<7>Switched to high resolution mode on CPU 1
[    0.511884] Switched to high resolution mode on CPU 0
[    0.763822]  it is
[    1.060918] Freeing initrd memory: 6018k freed
[    1.060998] audit: initializing netlink socket (disabled)
[    1.060998] type=2000 audit(1236841380.048:1): initialized
[    1.060999] highmem bounce pool size: 64 pages
[    1.060999] Total HugeTLB memory allocated, 0
[    1.060999] VFS: Disk quotas dquot_6.5.1
[    1.060999] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.060999] msgmni has been set to 1719
[    1.060999] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.060999] io scheduler noop registered
[    1.060999] io scheduler anticipatory registered
[    1.060999] io scheduler deadline registered
[    1.061073] io scheduler cfq registered (default)
[    1.077599] pci 0000:02:00.0: Boot video device
[    1.079998] PCI: Setting latency timer of device 0000:00:15.0 to 64
[    1.079998] assign_interrupt_mode Found MSI capability
[    1.079998] Allocate Port Service[0000:00:15.0:pcie00]
[    1.079998] PCI: Setting latency timer of device 0000:00:16.0 to 64
[    1.080062] assign_interrupt_mode Found MSI capability
[    1.080239] Allocate Port Service[0000:00:16.0:pcie00]
[    1.080999] isapnp: Scanning for PnP cards...
[    1.434561] isapnp: No Plug & Play device found
[    1.440994] hpet_resources: 0xfed00000 is busy
[    1.440994] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    1.440994] brd: module loaded
[    1.440994] PNP: No PS/2 controller found. Probing ports directly.
[    1.440994] i8042.c: No controller found.
[    1.440994] mice: PS/2 mouse device common for all mice
[    1.440994] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    1.440994] rtc0: alarms up to one year, y3k
[    1.440994] cpuidle: using governor ladder
[    1.440994] cpuidle: using governor menu
[    1.440994] No iBFT detected.
[    1.441486] TCP cubic registered
[    1.441547] NET: Registered protocol family 17
[    1.441613] Using IPI No-Shortcut mode
[    1.444993] registered taskstats version 1
[    1.444993] rtc_cmos 00:07: setting system clock to 2009-03-12 07:03:01 UTC (1236841381)
[    1.444993] Freeing unused kernel memory: 244k freed
[    1.533501] ACPI: SSDT BFECAC98, 0238 (r1  APPLE  Cpu0Ist     3000 INTL 20061109)
[    1.533501] ACPI: SSDT BFEC9C18, 02AD (r1  APPLE  Cpu0Cst     3001 INTL 20061109)
[    1.533501] Monitor-Mwait will be used to enter C-1 state
[    1.533501] Monitor-Mwait will be used to enter C-2 state
[    1.533501] Monitor-Mwait will be used to enter C-3 state
[    1.537501] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.537501] ACPI: ACPI0007:00 is registered as cooling_device0
[    1.537501] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.537501] ACPI: SSDT BFECAF18, 00C8 (r1  APPLE  Cpu1Ist     3000 INTL 20061109)
[    1.537501] ACPI: SSDT BFEC9F18, 0085 (r1  APPLE  Cpu1Cst     3000 INTL 20061109)
[    1.537501] Marking TSC unstable due to: TSC halts in idle.
[    1.537501] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    1.537501] ACPI: ACPI0007:01 is registered as cooling_device1
[    1.537501] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.770566] usbcore: registered new interface driver usbfs
[    1.770566] usbcore: registered new interface driver hub
[    1.770566] usbcore: registered new device driver usb
[    1.771610] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.772141] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 21
[    1.772207] ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [LUS0] -> GSI 21 (level, low) -> IRQ 21
[    1.773236] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    1.773239] ohci_hcd 0000:00:04.0: OHCI Host Controller
[    1.773420] ohci_hcd 0000:00:04.0: new USB bus registered, assigned bus number 1
[    1.773506] ohci_hcd 0000:00:04.0: irq 21, io mem 0xd3488000
[    1.822537] Uniform Multi-Platform E-IDE driver
[    1.825717] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    1.830818] usb usb1: configuration #1 chosen from 1 choice
[    1.830912] hub 1-0:1.0: USB hub found
[    1.830978] hub 1-0:1.0: 7 ports detected
[    1.934701] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    1.934768] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.934842] usb usb1: Product: OHCI Host Controller
[    1.934901] usb usb1: Manufacturer: Linux 2.6.26-1-686 ohci_hcd
[    1.934963] usb usb1: SerialNumber: 0000:00:04.0
[    1.936747] ACPI: PCI Interrupt Link [Z000] enabled at IRQ 20
[    1.936747] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [Z000] -> GSI 20 (level, low) -> IRQ 20
[    1.936747] PCI: Setting latency timer of device 0000:00:06.0 to 64
[    1.936747] ohci_hcd 0000:00:06.0: OHCI Host Controller
[    1.936747] ohci_hcd 0000:00:06.0: new USB bus registered, assigned bus number 2
[    1.936747] ohci_hcd 0000:00:06.0: irq 20, io mem 0xd3487000
[    1.992745] usb usb2: configuration #1 chosen from 1 choice
[    1.992745] hub 2-0:1.0: USB hub found
[    1.992745] hub 2-0:1.0: 5 ports detected
[    2.093998] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.094063] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.094136] usb usb2: Product: OHCI Host Controller
[    2.094196] usb usb2: Manufacturer: Linux 2.6.26-1-686 ohci_hcd
[    2.094259] usb usb2: SerialNumber: 0000:00:06.0
[    2.096745] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 19
[    2.096745] ACPI: PCI Interrupt 0000:00:04.1[B] -> Link [LUS2] -> GSI 19 (level, low) -> IRQ 19
[    2.096745] PCI: Setting latency timer of device 0000:00:04.1 to 64
[    2.096745] ehci_hcd 0000:00:04.1: EHCI Host Controller
[    2.096745] ehci_hcd 0000:00:04.1: new USB bus registered, assigned bus number 3
[    2.096745] ehci_hcd 0000:00:04.1: debug port 1
[    2.096745] PCI: cache line size of 32 is not supported by device 0000:00:04.1
[    2.096745] ehci_hcd 0000:00:04.1: irq 19, io mem 0xd3489200
[    2.238383] usb 1-3: new low speed USB device using ohci_hcd and address 2
[    2.250231] ehci_hcd 0000:00:04.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    2.250367] usb usb3: configuration #1 chosen from 1 choice
[    2.250457] hub 3-0:1.0: USB hub found
[    2.250520] hub 3-0:1.0: 7 ports detected
[    2.306042] hub 1-0:1.0: unable to enumerate USB device on port 3
[    2.354007] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    2.354071] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.354144] usb usb3: Product: EHCI Host Controller
[    2.354205] usb usb3: Manufacturer: Linux 2.6.26-1-686 ehci_hcd
[    2.354264] usb usb3: SerialNumber: 0000:00:04.1
[    2.356747] ACPI: PCI Interrupt Link [Z001] enabled at IRQ 18
[    2.356747] ACPI: PCI Interrupt 0000:00:06.1[B] -> Link [Z001] -> GSI 18 (level, low) -> IRQ 18
[    2.356747] PCI: Setting latency timer of device 0000:00:06.1 to 64
[    2.356747] ehci_hcd 0000:00:06.1: EHCI Host Controller
[    2.356747] ehci_hcd 0000:00:06.1: new USB bus registered, assigned bus number 4
[    2.356747] ehci_hcd 0000:00:06.1: debug port 1
[    2.356747] PCI: cache line size of 32 is not supported by device 0000:00:06.1
[    2.356747] ehci_hcd 0000:00:06.1: irq 18, io mem 0xd3489100
[    2.365646] ehci_hcd 0000:00:06.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    2.365787] usb usb4: configuration #1 chosen from 1 choice
[    2.365877] hub 4-0:1.0: USB hub found
[    2.365941] hub 4-0:1.0: 5 ports detected
[    2.470453] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    2.470518] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.470589] usb usb4: Product: EHCI Host Controller
[    2.470648] usb usb4: Manufacturer: Linux 2.6.26-1-686 ehci_hcd
[    2.470710] usb usb4: SerialNumber: 0000:00:06.1
[    2.473460] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[    2.473460] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 17
[    2.473460] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LMAC] -> GSI 17 (level, low) -> IRQ 17
[    2.473460] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    2.990624] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:23:df:7e:d4:46
[    2.990698] forcedeth 0000:00:0a.0: highdma csum pwrctl mgmt timirq gbit lnktim msi desc-v3
[    2.993461] ACPI: PCI Interrupt 0000:04:00.0[A] -> Link [Z00J] -> GSI 22 (level, low) -> IRQ 22
[    2.993461] PCI: Setting latency timer of device 0000:04:00.0 to 64
[    3.045435] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]  MMIO=[d3100000-d31007ff]  Max Packet=[4096]  IR/IT contexts=[8/8]
[    3.057284] No dock devices found.
[    3.063051] ACPI: PCI Interrupt 0000:03:00.0[A] -> Link [Z00F] -> GSI 23 (level, low) -> IRQ 23
[    3.063412] PCI: Setting latency timer of device 0000:03:00.0 to 64
[    3.065434] SCSI subsystem initialized
[    3.088950] libata version 3.00 loaded.
[    3.103443] ssb: WARNING: Invalid SPROM CRC (corrupt SPROM)
[    3.121544] ssb: Sonics Silicon Backplane found on PCI device 0000:03:00.0
[    3.125615] ahci 0000:00:0b.0: version 3.0
[    3.126124] ACPI: PCI Interrupt Link [LSI0] enabled at IRQ 16
[    3.126124] ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LSI0] -> GSI 16 (level, low) -> IRQ 16
[    4.131548] ahci 0000:00:0b.0: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3 impl IDE mode
[    4.131624] ahci 0000:00:0b.0: flags: 64bit ncq sntf pm led pmp pio slum part 
[    4.131698] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    4.135528] scsi0 : ahci
[    4.135621] scsi1 : ahci
[    4.135698] scsi2 : ahci
[    4.135698] scsi3 : ahci
[    4.136585] scsi4 : ahci
[    4.136585] scsi5 : ahci
[    4.136585] ata1: SATA max UDMA/133 abar m8192@0xd3484000 port 0xd3484100 irq 221
[    4.136585] ata2: SATA max UDMA/133 abar m8192@0xd3484000 port 0xd3484180 irq 221
[    4.136585] ata3: DUMMY
[    4.136585] ata4: DUMMY
[    4.136585] ata5: DUMMY
[    4.136585] ata6: DUMMY
[    4.332044] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0023dffffe7ed446]
[    4.388185] usb 2-1: new full speed USB device using ohci_hcd and address 2
[    4.608044] usb 2-1: configuration #1 chosen from 1 choice
[    4.610612] hub 2-1:1.0: USB hub found
[    4.615838] hub 2-1:1.0: 3 ports detected
[    4.620739] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.624720] ata1.00: ATA-8: Hitachi HTS543232L9SA02, FB4AC50F, max UDMA/133
[    4.624720] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    4.624720] ata1.00: configured for UDMA/133
[    4.733242] usb 2-1: New USB device found, idVendor=0a5c, idProduct=4500
[    4.733305] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.733369] usb 2-1: Product: BCM2045B2
[    4.733429] usb 2-1: Manufacturer: Broadcom
[    5.034280] usb 2-4: new full speed USB device using ohci_hcd and address 3
[    5.121273] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.121259] ata2.00: ATAPI: PIONEER DVD-RW  DVRTS08, Q81B, max UDMA/33, ATAPI AN
[    5.123477] ata2.00: configured for UDMA/33
[    5.141156] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS54323 FB4A PQ: 0 ANSI: 5
[    5.144194] scsi 1:0:0:0: CD-ROM            PIONEER  DVD-RW  DVRTS08  Q81B PQ: 0 ANSI: 5
[    5.158966] Driver 'sd' needs updating - please use bus_type methods
[    5.158966] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[    5.158966] sd 0:0:0:0: [sda] Write Protect is off
[    5.158966] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.158966] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.158966] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[    5.158966] sd 0:0:0:0: [sda] Write Protect is off
[    5.158966] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.158966] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.158966]  sda:<4>Driver 'sr' needs updating - please use bus_type methods
[    5.211193]  sda1 sda2 sda3 sda4
[    5.211193] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.211193] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda caddy
[    5.211193] Uniform CD-ROM driver Revision: 3.20
[    5.211193] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    5.224555] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.224555] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    5.268674] usb 2-4: configuration #1 chosen from 1 choice
[    5.281684] usb 2-4: New USB device found, idVendor=04e6, idProduct=5116
[    5.281684] usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=5
[    5.281684] usb 2-4: Product: SCR3310 USB Smart Card Reader
[    5.281684] usb 2-4: Manufacturer: SCM Microsystems Inc.
[    5.281684] usb 2-4: SerialNumber: 21120703393088
[    5.584620] usb 1-3: new low speed USB device using ohci_hcd and address 3
[    5.794785] usb 1-3: configuration #1 chosen from 1 choice
[    5.797505] usb 1-3: New USB device found, idVendor=0566, idProduct=4006
[    5.797569] usb 1-3: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    5.797633] usb 1-3: Product: USB Mouse
[    6.100353] usb 1-5: new low speed USB device using ohci_hcd and address 4
[    6.314314] usb 1-5: configuration #1 chosen from 1 choice
[    6.321006] usb 1-5: New USB device found, idVendor=05ac, idProduct=8242
[    6.321006] usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.321006] usb 1-5: Product: IR Receiver
[    6.321006] usb 1-5: Manufacturer: Apple Computer, Inc.
[    6.623007] usb 1-7: new full speed USB device using ohci_hcd and address 5
[    6.835497] usb 1-7: configuration #1 chosen from 1 choice
[    6.837972] hub 1-7:1.0: USB hub found
[    6.842870] hub 1-7:1.0: 4 ports detected
[    6.968751] usb 1-7: New USB device found, idVendor=0430, idProduct=100e
[    6.968815] usb 1-7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    7.181119] usb 2-1.1: new full speed USB device using ohci_hcd and address 4
[    7.303119] usb 2-1.1: configuration #1 chosen from 1 choice
[    7.305599] usb 2-1.1: New USB device found, idVendor=05ac, idProduct=8216
[    7.305599] usb 2-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    7.305599] usb 2-1.1: Product: Bluetooth USB Host Controller
[    7.305599] usb 2-1.1: Manufacturer: Apple, Inc.
[    7.305599] usb 2-1.1: SerialNumber: 002436EB7CF7
[    7.518353] usb 2-1.2: new full speed USB device using ohci_hcd and address 5
[    7.627571] usb 2-1.2: configuration #1 chosen from 1 choice
[    7.630061] usb 2-1.2: New USB device found, idVendor=05ac, idProduct=820a
[    7.630061] usb 2-1.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    7.845670] usb 2-1.3: new full speed USB device using ohci_hcd and address 6
[    7.955920] usb 2-1.3: configuration #1 chosen from 1 choice
[    7.957938] usb 2-1.3: New USB device found, idVendor=05ac, idProduct=820b
[    7.957938] usb 2-1.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    8.180911] usb 1-7.4: new full speed USB device using ohci_hcd and address 6
[    8.301216] usb 1-7.4: configuration #1 chosen from 1 choice
[    8.304193] usb 1-7.4: New USB device found, idVendor=0430, idProduct=00a2
[    8.304258] usb 1-7.4: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    8.304331] usb 1-7.4: Product: Sun USB Keyboard
[    8.309034] usbcore: registered new interface driver hiddev
[    8.315259] input: USB Mouse as /class/input/input0
[    8.319046] input,hidraw0: USB HID v1.11 Mouse [USB Mouse] on usb-0000:00:04.0-3
[    8.329698] hiddev96hidraw1: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:04.0-5
[    8.338620] input: HID 05ac:820a as /class/input/input1
[    8.339085] input,hidraw2: USB HID v1.11 Keyboard [HID 05ac:820a] on usb-0000:00:06.0-1.2
[    8.342882] input: HID 05ac:820b as /class/input/input2
[    8.342882] input,hidraw3: USB HID v1.11 Mouse [HID 05ac:820b] on usb-0000:00:06.0-1.3
[    8.347998] input: Sun USB Keyboard as /class/input/input3
[    8.348156] input,hidraw4: USB HID v1.10 Keyboard [Sun USB Keyboard] on usb-0000:00:04.0-7.4
[    8.348156] usbcore: registered new interface driver usbhid
[    8.348156] usbhid: v2.6:USB HID core driver
[    8.445003] PM: Starting manual resume from disk
[    8.506041] kjournald starting.  Commit interval 5 seconds
[    8.506041] EXT3-fs: mounted filesystem with ordered data mode.
[   10.244500] udevd version 125 started
[   10.995314] input: Power Button (FF) as /class/input/input4
[   11.050580] ACPI: Power Button (FF) [PWRF]
[   11.050700] input: Power Button (CM) as /class/input/input5
[   11.090137] ACPI: Power Button (CM) [PWRB]
[   11.090264] input: Sleep Button (CM) as /class/input/input6
[   11.154178] ACPI: Sleep Button (CM) [SLPB]
[   11.386649] Bluetooth: Core ver 2.11
[   11.401169] NET: Registered protocol family 31
[   11.401169] Bluetooth: HCI device and connection manager initialized
[   11.401169] Bluetooth: HCI socket layer initialized
[   11.440143] Bluetooth: HCI USB driver ver 2.9
[   11.442413] usbcore: registered new interface driver hci_usb
[   11.448571] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   11.460065] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   11.579307] input: PC Speaker as /class/input/input7
[   11.610642] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 23
[   11.610708] ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LAZA] -> GSI 23 (level, low) -> IRQ 23
[   11.610895] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   11.646898] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[   11.660741] Error: Driver 'pcspkr' is already registered, aborting...
[   12.685669] Adding 2654852k swap on /dev/sda4.  Priority:-1 extents:1 across:2654852k
[   13.299232] EXT3 FS on sda3, internal journal
[   13.567540] loop: module loaded
[   30.591819] Clocksource tsc unstable (delta = -97407605 ns)
[   59.628638] NET: Registered protocol family 10
[   59.629100] lo: Disabled Privacy Extensions
00:00.0 Host bridge: nVidia Corporation Device 0a82 (rev b1)
00:00.1 RAM memory: nVidia Corporation Device 0a88 (rev b1)
00:03.0 ISA bridge: nVidia Corporation Device 0aae (rev b2)
00:03.1 RAM memory: nVidia Corporation Device 0aa4 (rev b1)
00:03.2 SMBus: nVidia Corporation Device 0aa2 (rev b1)
00:03.3 RAM memory: nVidia Corporation Device 0a89 (rev b1)
00:03.4 RAM memory: nVidia Corporation Device 0a98 (rev b1)
00:03.5 Co-processor: nVidia Corporation Device 0aa3 (rev b1)
00:04.0 USB Controller: nVidia Corporation Device 0aa5 (rev b1)
00:04.1 USB Controller: nVidia Corporation Device 0aa6 (rev b1)
00:06.0 USB Controller: nVidia Corporation Device 0aa7 (rev b1)
00:06.1 USB Controller: nVidia Corporation Device 0aa9 (rev b1)
00:08.0 Audio device: nVidia Corporation Device 0ac0 (rev b1)
00:09.0 PCI bridge: nVidia Corporation Device 0aab (rev b1)
00:0a.0 Ethernet controller: nVidia Corporation MCP79 Ethernet (rev b1)
00:0b.0 IDE interface: nVidia Corporation Device 0ab5 (rev b1)
00:10.0 PCI bridge: nVidia Corporation Device 0aa0 (rev b1)
00:15.0 PCI bridge: nVidia Corporation Device 0ac6 (rev b1)
00:16.0 PCI bridge: nVidia Corporation Device 0ac7 (rev b1)
02:00.0 VGA compatible controller: nVidia Corporation Device 0861 (rev b1)
03:00.0 Network controller: Broadcom Corporation BCM4328 802.11a/b/g/n (rev 05)
04:00.0 FireWire (IEEE 1394): Agere Systems Device 5901 (rev 07)
00:00.0 0600: 10de:0a82 (rev b1)
00:00.1 0500: 10de:0a88 (rev b1)
00:03.0 0601: 10de:0aae (rev b2)
00:03.1 0500: 10de:0aa4 (rev b1)
00:03.2 0c05: 10de:0aa2 (rev b1)
00:03.3 0500: 10de:0a89 (rev b1)
00:03.4 0500: 10de:0a98 (rev b1)
00:03.5 0b40: 10de:0aa3 (rev b1)
00:04.0 0c03: 10de:0aa5 (rev b1)
00:04.1 0c03: 10de:0aa6 (rev b1)
00:06.0 0c03: 10de:0aa7 (rev b1)
00:06.1 0c03: 10de:0aa9 (rev b1)
00:08.0 0403: 10de:0ac0 (rev b1)
00:09.0 0604: 10de:0aab (rev b1)
00:0a.0 0200: 10de:0ab0 (rev b1)
00:0b.0 0101: 10de:0ab5 (rev b1)
00:10.0 0604: 10de:0aa0 (rev b1)
00:15.0 0604: 10de:0ac6 (rev b1)
00:16.0 0604: 10de:0ac7 (rev b1)
02:00.0 0300: 10de:0861 (rev b1)
03:00.0 0280: 14e4:4328 (rev 05)
04:00.0 0c00: 11c1:5901 (rev 07)

Debian Lenny installed on this one out of the box, but you have to keep
the following in mind to install:

        - Don't delete the EFI partition (obvious)
        - If you use the Lenny installer, the EFI and MSDOS Partition
          Table are out of sync (Lenny seems only to update the EFI).
          However that doesnn't allow you to boot from it using the
          legacy efi bios. However if you install refit (google for it)
          and enable it, you can sync the partitions using the
          partitioner in the refit menu using boot time. Simply say
          ,,yes'' after calling it.
        - To avoid the above hassle, use the MAC OS X (if you want to
          keep it around for firmware updates) partitioner during
          installation to create the partitions for Linux and just use
          the partitions in the debian isntaller (without
          repartitioning). Network card works, graphic card works
          (however I look if the rotation for 1920x1200 works as well,
          will report back). The sound card doesn't seem to recognize.
          Compared to the last time I installed Linux on the mac mini
          this is a walk in the park.

        Thomas
