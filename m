Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbXLFQtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbXLFQtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbXLFQtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:49:11 -0500
Received: from osl1smout1.broadpark.no ([80.202.4.58]:57466 "EHLO
	osl1smout1.broadpark.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbXLFQtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:49:07 -0500
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_FM+W0pvuxJvB6lqm54L1lQ)"
Subject: Re: laptop reboots right after hibernation
From: Kjartan Maraas <kmaraas@broadpark.no>
To: Tejun Heo <htejun@gmail.com>
Cc: Tomas Carnecky <tom@dbservice.com>, Pavel Machek <pavel@ucw.cz>,
       linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
In-reply-to: <4757608D.8020005@gmail.com>
References: <473730F6.2010900@dbservice.com> <20071118105214.GB7299@ucw.cz>
 <4740692E.7010801@dbservice.com> <47409DA3.7070909@dbservice.com>
 <1195551141.2792.3.camel@localhost.localdomain> <474CBFB6.4020105@gmail.com>
 <1196253340.2884.1.camel@localhost.localdomain> <474FE862.4040700@gmail.com>
 <1196458627.4106.1.camel@localhost.localdomain> <47565738.1050003@gmail.com>
 <1196874547.3700.0.camel@localhost.localdomain> <4757608D.8020005@gmail.com>
Date: Thu, 06 Dec 2007 17:47:37 +0100
Message-id: <1196959657.2661.0.camel@localhost.localdomain>
X-Mailer: Evolution 2.21.2 (2.21.2-4.fc9)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Boundary_(ID_FM+W0pvuxJvB6lqm54L1lQ)
Content-type: text/plain
Content-transfer-encoding: 7BIT


to., 06.12.2007 kl. 11.38 +0900, skrev Tejun Heo:
> Thanks.  Almost there.  Can you please try the attached two patches and
> report the boot log?
> 
Here we go again.

Cheers
Kjartan


--Boundary_(ID_FM+W0pvuxJvB6lqm54L1lQ)
Content-type: text/plain; name=dmesg-no-filter; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=dmesg-no-filter

Initializing cgroup subsys cpuset
Linux version 2.6.24-rc4 (kmaraas@localhost) (gcc version 4.1.2 20071124 (Red Hat 4.1.2-35)) #3 SMP Thu Dec 6 13:29:39 CET 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bf7d0000 (usable)
 BIOS-e820: 00000000bf7d0000 - 00000000bf7e5600 (reserved)
 BIOS-e820: 00000000bf7e5600 - 00000000bf7f8000 (ACPI NVS)
 BIOS-e820: 00000000bf7f8000 - 00000000bf800000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed9b000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
2167MB HIGHMEM available.
896MB LOWMEM available.
Entering add_active_range(0, 0, 784336) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   784336
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   784336
On node 0 totalpages: 784336
  DMA zone: 56 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4040 pages, LIFO batch:0
  Normal zone: 3080 pages used for memmap
  Normal zone: 222200 pages, LIFO batch:31
  HighMem zone: 7587 pages used for memmap
  HighMem zone: 547373 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.4 present.
Using APIC driver default
ACPI: RSDP 000F78B0, 0024 (r2 HP    )
ACPI: XSDT BF7E57C8, 007C (r1 HPQOEM SLIC-MPC        1 HP          1)
ACPI: FACP BF7E5684, 00F4 (r4 HP     30AD            3 HP          1)
ACPI: DSDT BF7E5ACC, FE7B (r1 HP       nc6400    10000 MSFT  100000E)
ACPI: FACS BF7F7E80, 0040
ACPI: SLIC BF7E5844, 0176 (r1 HPQOEM SLIC-MPC        1 HP          1)
ACPI: HPET BF7E59BC, 0038 (r1 HP     30AD            1 HP          1)
ACPI: APIC BF7E59F4, 0068 (r1 HP     30AD            1 HP          1)
ACPI: MCFG BF7E5A5C, 003C (r1 HP     30AD            1 HP          1)
ACPI: TCPA BF7E5A98, 0032 (r2 HP     30AD            1 HP          1)
ACPI: SSDT BF7F5947, 0059 (r1 HP       HPQNLP        1 MSFT  100000E)
ACPI: SSDT BF7F59A0, 032D (r1 HP       HPQSAT        1 MSFT  100000E)
ACPI: SSDT BF7F64E0, 025F (r1 HP      Cpu0Tst     3000 INTL 20060317)
ACPI: SSDT BF7F673F, 00A6 (r1 HP      Cpu1Tst     3000 INTL 20060317)
ACPI: SSDT BF7F67E5, 04D7 (r1 HP        CpuPm     3000 INTL 20060317)
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 6:15 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at c0000000 (gap: bf800000:3f400000)
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 773613
Kernel command line: ro root=LABEL=/1 rhgb quiet pci=assign-busses selinux=off
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0820000 soft=c0800000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1828.814 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          30
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1024 kB
 per task-struct memory footprint: 1680 bytes
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3082056k/3137344k available (2305k kernel code, 53944k reserved, 1180k data, 576k init, 2219840k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc53000 - 0xfffff000   (3760 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc076d000 - 0xc07fd000   ( 576 kB)
      .data : 0xc06405ed - 0xc0767924   (1180 kB)
      .text : 0xc0400000 - 0xc06405ed   (2305 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay using timer specific routine.. 3662.13 BogoMIPS (lpj=1831067)
Security Framework initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
lockdep: not fixing up alternatives.
ACPI: Core revision 20070126
CPU0: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
lockdep: not fixing up alternatives.
Booting processor 1/1 eip 3000
CPU 1 irqstacks, hard=c0821000 soft=c0801000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3657.53 BogoMIPS (lpj=1828769)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
Total of 2 processors activated (7319.67 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
CPU0 attaching sched-domain:
 domain 0: span 00000003
  groups: 00000001 00000002
CPU1 attaching sched-domain:
 domain 0: span 00000003
  groups: 00000002 00000001
khelper used greatest stack depth: 3116 bytes left
net_namespace: 80 bytes
HP Compaq Laptop series board detected. Selecting BIOS-method for reboots.
Booting paravirtualized kernel on bare hardware
Time: 16:48:06  Date: 12/06/07
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at f8000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 2.10 entry at 0xf0322, last bus=32
PCI: Using configuration type 1
Setting up standard PCI resources
khelper used greatest stack depth: 3032 bytes left
khelper used greatest stack depth: 2884 bytes left
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [C002] (0000:00)
PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 1100-113f claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.C002._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C002.C098._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C002.C101._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C002.C111._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C002.C117._PRT]
ACPI: PCI Interrupt Link [C10D] (IRQs *10 11)
ACPI: PCI Interrupt Link [C10E] (IRQs *10 11)
ACPI: PCI Interrupt Link [C10F] (IRQs 10 *11)
ACPI: PCI Interrupt Link [C110] (IRQs 10 11) *5
ACPI: PCI Interrupt Link [C123] (IRQs *10 11)
ACPI: PCI Interrupt Link [C124] (IRQs *10 11)
ACPI: PCI Interrupt Link [C125] (IRQs 10 *11)
ACPI Exception (pci_link-0184): AE_NOT_FOUND, Evaluating _PRS [20070126]
ACPI: Power Resource [C1EF] (on)
ACPI: Power Resource [C1F6] (on)
ACPI: Power Resource [C220] (on)
ACPI: Power Resource [C228] (on)
ACPI: Power Resource [C32D] (off)
ACPI: Power Resource [C32E] (off)
ACPI: Power Resource [C32F] (off)
ACPI: Power Resource [C330] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
Time: tsc clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xe0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0xbf7fffff could not be reserved
system 00:0c: ioport range 0x500-0x55f has been reserved
system 00:0c: ioport range 0x800-0x80f has been reserved
system 00:0c: iomem range 0xffb00000-0xffbfffff could not be reserved
system 00:0c: iomem range 0xfff00000-0xffffffff could not be reserved
system 00:0e: ioport range 0x4d0-0x4d1 has been reserved
system 00:0e: ioport range 0x1000-0x107f has been reserved
system 00:0e: ioport range 0x1100-0x113f has been reserved
system 00:0e: ioport range 0x1200-0x121f has been reserved
system 00:0e: iomem range 0xf8000000-0xfbffffff has been reserved
system 00:0e: iomem range 0xfec00000-0xfec000ff could not be reserved
system 00:0e: iomem range 0xfed20000-0xfed3ffff could not be reserved
system 00:0e: iomem range 0xfed45000-0xfed8ffff could not be reserved
system 00:0e: iomem range 0xfed90000-0xfed9afff could not be reserved
system 00:0f: iomem range 0xfeda0000-0xfedbffff could not be reserved
system 00:0f: iomem range 0xfee00000-0xfee00fff could not be reserved
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: f4100000-f41fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: disabled.
  MEM window: f4000000-f40fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.3
  IO window: 2000-3fff
  MEM window: f0000000-f3ffffff
  PREFETCH window: disabled.
PCI: Bus 5, cardbus bridge: 0000:04:06.0
  IO window: 00001400-000014ff
  IO window: 00001800-000018ff
  PREFETCH window: c0000000-c3ffffff
  MEM window: c4000000-c7ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: f4200000-f45fffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:04:06.0[A] -> GSI 18 (level, low) -> IRQ 19
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2403k freed
khelper used greatest stack depth: 2800 bytes left
apm: BIOS not found.
audit: initializing netlink socket (disabled)
audit(1196959685.881:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:00:02.0
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
Allocate Port Service[0000:00:1c.1:pcie02]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
Allocate Port Service[0000:00:1c.3:pcie02]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
khelper used greatest stack depth: 2748 bytes left
ACPI: Fan [C331] (off)
ACPI: Fan [C332] (off)
ACPI: Fan [C333] (off)
ACPI: Fan [C334] (off)
ACPI: SSDT BF7F5D95, 01FB (r1 HP      Cpu0Ist     3000 INTL 20060317)
ACPI: SSDT BF7F6015, 04CB (r1 HP      Cpu0Cst     3001 INTL 20060317)
ACPI: EC: non-query interrupt received, switching to interrupt mode
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT BF7F5CCD, 00C8 (r1 HP      Cpu1Ist     3000 INTL 20060317)
ACPI: SSDT BF7F5F90, 0085 (r1 HP      Cpu1Cst     3000 INTL 20060317)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Thermal Zone [TZ0] (27 C)
ACPI: Thermal Zone [TZ1] (31 C)
ACPI: Thermal Zone [TZ2] (22 C)
ACPI: Thermal Zone [TZ3] (23 C)
ACPI: Thermal Zone [TZ4] (73 C)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.102
agpgart: Detected an Intel 945GM Chipset.
agpgart: Detected 7932K stolen memory.
agpgart: AGP aperture is 256M @ 0xe0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS2 at I/O 0x3e8 (irq = 7) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
input: Macintosh mouse button emulation as /class/input/input0
Yenta: CardBus bridge found at 0000:04:06.0 [103c:30ad]
Yenta: Enabling burst memory read transactions
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:04:06.0, mfunc 0x01aa1b22, devctl 0x64
Yenta: ISA IRQ mask 0x0cf8, PCI irq 19
Socket status: 30000006
pcmcia: parent PCI bridge Memory window: 0xf4200000 - 0xf45fffff
PNP: PS/2 Controller [PNP0303:C21D,PNP0f13:C21E] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
cpuidle: using governor ladder
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x2580b1, caps: 0xa04793/0x300000
serio: Synaptics pass-through port at isa0060/serio4/input0
input: SynPS/2 Synaptics TouchPad as /class/input/input2
cpuidle: using governor menu
Marking TSC unstable due to: TSC halts in idle.
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
Time: hpet clocksource has been installed.
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
registered taskstats version 1
  Magic number: 3:970:842
Freeing unused kernel memory: 576k freed
Write protecting the kernel read-only data: 915k
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xf4784000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
insmod used greatest stack depth: 1920 bytes left
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00004020
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 21, io base 0x00004040
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 19, io base 0x00004060
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 18, io base 0x00004080
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
SCSI subsystem initialized
libata version 3.00 loaded.
ahci 0000:00:1f.2: version 3.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 21 (level, low) -> IRQ 22
ahci 0000:00:1f.2: nr_ports (4) and implemented port map (0x1) don't match, using nr_ports
ahci 0000:00:1f.2: forcing PORTS_IMPL to 0xf
usb 2-1: new full speed USB device using uhci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
usb 3-1: new full speed USB device using uhci_hcd and address 2
usb 3-1: configuration #1 chosen from 1 choice
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pmp pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xf4785000 port 0xf4785100 irq 220
ata2: SATA max UDMA/133 abar m1024@0xf4785000 port 0xf4785180 irq 220
ata3: SATA max UDMA/133 abar m1024@0xf4785000 port 0xf4785200 irq 220
ata4: SATA max UDMA/133 abar m1024@0xf4785000 port 0xf4785280 irq 220
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 rejected by device (Stat=0x51 Err=0x04)
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
ata1: failed to recover some devices, retrying in 5 secs
input: PS/2 Generic Mouse as /class/input/input3
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 rejected by device (Stat=0x51 Err=0x04)
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
ata1.00: ACPI: failed the second time, disabled
ata1.00: revalidation failed (errno=1)
ata1: failed to recover some devices, retrying in 5 secs
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 0)
ata3: SATA link down (SStatus 0 SControl 0)
ata4: SATA link down (SStatus 0 SControl 0)
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHV2080B 892C PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
insmod used greatest stack depth: 604 bytes left
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
cs: IO port probe 0x100-0x3af: excluding 0x100-0x107 0x378-0x37f
cs: IO port probe 0x3e0-0x4ff: clean.
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
sd 0:0:0:0: Attached scsi generic sg0 type 0
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input5
ACPI: Sleep Button (CM) [C249]
input: Lid Switch as /class/input/input6
ACPI: Lid Switch [C241]
input: Video Bus as /class/input/input7
ACPI: Video Device [C085] (multi-head: yes  rom: no  post: no)
input: PC Speaker as /class/input/input8
rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci: SDHCI controller found at 0000:04:06.3 [104c:803c] (rev 0)
ACPI: PCI Interrupt 0000:04:06.3[C] -> GSI 22 (level, low) -> IRQ 21
mmc0: SDHCI at 0xf4202000 irq 21 PIO
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: Found a ICH7-M TCO device (Version=2, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
tg3.c:v3.86 (November 9, 2007)
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:01:00.0 to 64
eth0: Tigon3 [partno(BCM95751M) rev 4201 PHY(5750)] (PCI Express) 10/100/1000Base-T Ethernet 00:16:d4:a5:6d:f1
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
ACPI: PCI Interrupt 0000:04:06.2[A] -> GSI 18 (level, low) -> IRQ 19
NET: Registered protocol family 23
intel_rng: FWH not detected
parport_pc 00:03: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 0 [PCSPP,TRISTATE]
IRQ handler type mismatch for IRQ 0
current handler: timer
Pid: 1065, comm: modprobe Not tainted 2.6.24-rc4 #3
 [<c0406175>] show_trace_log_lvl+0x1a/0x2f
 [<c0406a1c>] show_trace+0x12/0x14
 [<c0406d2c>] dump_stack+0x6c/0x72
 [<c0469bf1>] setup_irq+0x196/0x1ae
 [<c0469dc8>] request_irq+0xf4/0x112
 [<f8a59f6d>] parport_pc_probe_port+0x73d/0x8bc [parport_pc]
 [<f8a5a1c6>] parport_pc_pnp_probe+0xda/0xf5 [parport_pc]
 [<c054d98f>] pnp_device_probe+0x66/0x87
 [<c0579ac8>] driver_probe_device+0xe9/0x16a
 [<c0579c72>] __driver_attach+0x76/0xaf
 [<c0578fa6>] bus_for_each_dev+0x3a/0x5f
 [<c0579913>] driver_attach+0x19/0x1b
 [<c05792c5>] bus_add_driver+0x73/0x1aa
 [<c0579e66>] driver_register+0x67/0x6c
 [<c054d781>] pnp_register_driver+0x17/0x19
 [<f8852342>] parport_pc_init+0x268/0x320 [parport_pc]
 [<c0455e51>] sys_init_module+0x1430/0x155c
 [<c040504e>] sysenter_past_esp+0x6b/0xc1
 =======================
parport0: irq 0 in use, resorting to polled operation
ACPI: AC Adapter [C1B2] (off-line)
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi4 : ata_piix
scsi5 : ata_piix
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40a0 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40a8 irq 15
found SMC SuperIO Chip (devid=0x7a rev=01 base=0x004e): LPC47N227
smsc_superio_flat(): fir: 0x100, sir: 0x3e8, dma: 03, irq: 7, mode: 0x0e
smsc_ircc_present: can't get sir_base of 0x3e8
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
tpm_inf_pnp 00:04: Found C205 with ID IFX0102
tpm_inf_pnp 00:04: TPM found: config base 0x560, data base 0x570, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
ata5.00: ATAPI: HL-DT-STCD-RW/DVD DRIVE GCC-4247N, 1.01, max MWDMA2
ACPI: Battery Slot [C1B4] (battery present)
ACPI: Battery Slot [C1B3] (battery absent)
Bluetooth: HCI USB driver ver 2.9
usbcore: registered new interface driver hci_usb
ata5.00: configured for MWDMA2
ata6: port disabled. ignoring.
scsi 4:0:0:0: CD-ROM            HL-DT-ST RW/DVD GCC-4247N 1.01 PQ: 0 ANSI: 5
scsi 4:0:0:0: Attached scsi generic sg1 type 5
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1b.0 to 64
Clocksource tsc unstable (delta = -100783695 ns)
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
EXT3 FS on sda3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1839432k swap on /dev/sda4.  Priority:-1 extents:1 across:1839432k
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
audit(1196956139.967:2): audit_pid=1686 old=0 by auid=4294967295
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
ADDRCONF(NETDEV_UP): eth0: link is not ready
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized i915 1.6.0 20060119 on minor 0

--Boundary_(ID_FM+W0pvuxJvB6lqm54L1lQ)
Content-type: text/plain; name=dmesg-no-filter; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=dmesg-no-filter

Initializing cgroup subsys cpuset
Linux version 2.6.24-rc4 (kmaraas@localhost) (gcc version 4.1.2 20071124 (Red Hat 4.1.2-35)) #3 SMP Thu Dec 6 13:29:39 CET 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bf7d0000 (usable)
 BIOS-e820: 00000000bf7d0000 - 00000000bf7e5600 (reserved)
 BIOS-e820: 00000000bf7e5600 - 00000000bf7f8000 (ACPI NVS)
 BIOS-e820: 00000000bf7f8000 - 00000000bf800000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed9b000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
2167MB HIGHMEM available.
896MB LOWMEM available.
Entering add_active_range(0, 0, 784336) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   784336
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   784336
On node 0 totalpages: 784336
  DMA zone: 56 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4040 pages, LIFO batch:0
  Normal zone: 3080 pages used for memmap
  Normal zone: 222200 pages, LIFO batch:31
  HighMem zone: 7587 pages used for memmap
  HighMem zone: 547373 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.4 present.
Using APIC driver default
ACPI: RSDP 000F78B0, 0024 (r2 HP    )
ACPI: XSDT BF7E57C8, 007C (r1 HPQOEM SLIC-MPC        1 HP          1)
ACPI: FACP BF7E5684, 00F4 (r4 HP     30AD            3 HP          1)
ACPI: DSDT BF7E5ACC, FE7B (r1 HP       nc6400    10000 MSFT  100000E)
ACPI: FACS BF7F7E80, 0040
ACPI: SLIC BF7E5844, 0176 (r1 HPQOEM SLIC-MPC        1 HP          1)
ACPI: HPET BF7E59BC, 0038 (r1 HP     30AD            1 HP          1)
ACPI: APIC BF7E59F4, 0068 (r1 HP     30AD            1 HP          1)
ACPI: MCFG BF7E5A5C, 003C (r1 HP     30AD            1 HP          1)
ACPI: TCPA BF7E5A98, 0032 (r2 HP     30AD            1 HP          1)
ACPI: SSDT BF7F5947, 0059 (r1 HP       HPQNLP        1 MSFT  100000E)
ACPI: SSDT BF7F59A0, 032D (r1 HP       HPQSAT        1 MSFT  100000E)
ACPI: SSDT BF7F64E0, 025F (r1 HP      Cpu0Tst     3000 INTL 20060317)
ACPI: SSDT BF7F673F, 00A6 (r1 HP      Cpu1Tst     3000 INTL 20060317)
ACPI: SSDT BF7F67E5, 04D7 (r1 HP        CpuPm     3000 INTL 20060317)
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 6:15 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at c0000000 (gap: bf800000:3f400000)
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 773613
Kernel command line: ro root=LABEL=/1 rhgb quiet pci=assign-busses selinux=off
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0820000 soft=c0800000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1828.814 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          30
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1024 kB
 per task-struct memory footprint: 1680 bytes
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3082056k/3137344k available (2305k kernel code, 53944k reserved, 1180k data, 576k init, 2219840k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc53000 - 0xfffff000   (3760 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc076d000 - 0xc07fd000   ( 576 kB)
      .data : 0xc06405ed - 0xc0767924   (1180 kB)
      .text : 0xc0400000 - 0xc06405ed   (2305 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay using timer specific routine.. 3662.13 BogoMIPS (lpj=1831067)
Security Framework initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
lockdep: not fixing up alternatives.
ACPI: Core revision 20070126
CPU0: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
lockdep: not fixing up alternatives.
Booting processor 1/1 eip 3000
CPU 1 irqstacks, hard=c0821000 soft=c0801000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3657.53 BogoMIPS (lpj=1828769)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
Total of 2 processors activated (7319.67 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
CPU0 attaching sched-domain:
 domain 0: span 00000003
  groups: 00000001 00000002
CPU1 attaching sched-domain:
 domain 0: span 00000003
  groups: 00000002 00000001
khelper used greatest stack depth: 3116 bytes left
net_namespace: 80 bytes
HP Compaq Laptop series board detected. Selecting BIOS-method for reboots.
Booting paravirtualized kernel on bare hardware
Time: 16:48:06  Date: 12/06/07
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at f8000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 2.10 entry at 0xf0322, last bus=32
PCI: Using configuration type 1
Setting up standard PCI resources
khelper used greatest stack depth: 3032 bytes left
khelper used greatest stack depth: 2884 bytes left
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [C002] (0000:00)
PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 1100-113f claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.C002._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C002.C098._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C002.C101._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C002.C111._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C002.C117._PRT]
ACPI: PCI Interrupt Link [C10D] (IRQs *10 11)
ACPI: PCI Interrupt Link [C10E] (IRQs *10 11)
ACPI: PCI Interrupt Link [C10F] (IRQs 10 *11)
ACPI: PCI Interrupt Link [C110] (IRQs 10 11) *5
ACPI: PCI Interrupt Link [C123] (IRQs *10 11)
ACPI: PCI Interrupt Link [C124] (IRQs *10 11)
ACPI: PCI Interrupt Link [C125] (IRQs 10 *11)
ACPI Exception (pci_link-0184): AE_NOT_FOUND, Evaluating _PRS [20070126]
ACPI: Power Resource [C1EF] (on)
ACPI: Power Resource [C1F6] (on)
ACPI: Power Resource [C220] (on)
ACPI: Power Resource [C228] (on)
ACPI: Power Resource [C32D] (off)
ACPI: Power Resource [C32E] (off)
ACPI: Power Resource [C32F] (off)
ACPI: Power Resource [C330] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
Time: tsc clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xe0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0xbf7fffff could not be reserved
system 00:0c: ioport range 0x500-0x55f has been reserved
system 00:0c: ioport range 0x800-0x80f has been reserved
system 00:0c: iomem range 0xffb00000-0xffbfffff could not be reserved
system 00:0c: iomem range 0xfff00000-0xffffffff could not be reserved
system 00:0e: ioport range 0x4d0-0x4d1 has been reserved
system 00:0e: ioport range 0x1000-0x107f has been reserved
system 00:0e: ioport range 0x1100-0x113f has been reserved
system 00:0e: ioport range 0x1200-0x121f has been reserved
system 00:0e: iomem range 0xf8000000-0xfbffffff has been reserved
system 00:0e: iomem range 0xfec00000-0xfec000ff could not be reserved
system 00:0e: iomem range 0xfed20000-0xfed3ffff could not be reserved
system 00:0e: iomem range 0xfed45000-0xfed8ffff could not be reserved
system 00:0e: iomem range 0xfed90000-0xfed9afff could not be reserved
system 00:0f: iomem range 0xfeda0000-0xfedbffff could not be reserved
system 00:0f: iomem range 0xfee00000-0xfee00fff could not be reserved
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: f4100000-f41fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: disabled.
  MEM window: f4000000-f40fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.3
  IO window: 2000-3fff
  MEM window: f0000000-f3ffffff
  PREFETCH window: disabled.
PCI: Bus 5, cardbus bridge: 0000:04:06.0
  IO window: 00001400-000014ff
  IO window: 00001800-000018ff
  PREFETCH window: c0000000-c3ffffff
  MEM window: c4000000-c7ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: f4200000-f45fffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:04:06.0[A] -> GSI 18 (level, low) -> IRQ 19
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2403k freed
khelper used greatest stack depth: 2800 bytes left
apm: BIOS not found.
audit: initializing netlink socket (disabled)
audit(1196959685.881:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:00:02.0
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
Allocate Port Service[0000:00:1c.1:pcie02]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
Allocate Port Service[0000:00:1c.3:pcie02]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
khelper used greatest stack depth: 2748 bytes left
ACPI: Fan [C331] (off)
ACPI: Fan [C332] (off)
ACPI: Fan [C333] (off)
ACPI: Fan [C334] (off)
ACPI: SSDT BF7F5D95, 01FB (r1 HP      Cpu0Ist     3000 INTL 20060317)
ACPI: SSDT BF7F6015, 04CB (r1 HP      Cpu0Cst     3001 INTL 20060317)
ACPI: EC: non-query interrupt received, switching to interrupt mode
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT BF7F5CCD, 00C8 (r1 HP      Cpu1Ist     3000 INTL 20060317)
ACPI: SSDT BF7F5F90, 0085 (r1 HP      Cpu1Cst     3000 INTL 20060317)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Thermal Zone [TZ0] (27 C)
ACPI: Thermal Zone [TZ1] (31 C)
ACPI: Thermal Zone [TZ2] (22 C)
ACPI: Thermal Zone [TZ3] (23 C)
ACPI: Thermal Zone [TZ4] (73 C)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.102
agpgart: Detected an Intel 945GM Chipset.
agpgart: Detected 7932K stolen memory.
agpgart: AGP aperture is 256M @ 0xe0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS2 at I/O 0x3e8 (irq = 7) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
input: Macintosh mouse button emulation as /class/input/input0
Yenta: CardBus bridge found at 0000:04:06.0 [103c:30ad]
Yenta: Enabling burst memory read transactions
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:04:06.0, mfunc 0x01aa1b22, devctl 0x64
Yenta: ISA IRQ mask 0x0cf8, PCI irq 19
Socket status: 30000006
pcmcia: parent PCI bridge Memory window: 0xf4200000 - 0xf45fffff
PNP: PS/2 Controller [PNP0303:C21D,PNP0f13:C21E] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
cpuidle: using governor ladder
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x2580b1, caps: 0xa04793/0x300000
serio: Synaptics pass-through port at isa0060/serio4/input0
input: SynPS/2 Synaptics TouchPad as /class/input/input2
cpuidle: using governor menu
Marking TSC unstable due to: TSC halts in idle.
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
Time: hpet clocksource has been installed.
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
registered taskstats version 1
  Magic number: 3:970:842
Freeing unused kernel memory: 576k freed
Write protecting the kernel read-only data: 915k
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xf4784000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
insmod used greatest stack depth: 1920 bytes left
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00004020
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 21, io base 0x00004040
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 19, io base 0x00004060
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 18, io base 0x00004080
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
SCSI subsystem initialized
libata version 3.00 loaded.
ahci 0000:00:1f.2: version 3.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 21 (level, low) -> IRQ 22
ahci 0000:00:1f.2: nr_ports (4) and implemented port map (0x1) don't match, using nr_ports
ahci 0000:00:1f.2: forcing PORTS_IMPL to 0xf
usb 2-1: new full speed USB device using uhci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
usb 3-1: new full speed USB device using uhci_hcd and address 2
usb 3-1: configuration #1 chosen from 1 choice
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pmp pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xf4785000 port 0xf4785100 irq 220
ata2: SATA max UDMA/133 abar m1024@0xf4785000 port 0xf4785180 irq 220
ata3: SATA max UDMA/133 abar m1024@0xf4785000 port 0xf4785200 irq 220
ata4: SATA max UDMA/133 abar m1024@0xf4785000 port 0xf4785280 irq 220
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 rejected by device (Stat=0x51 Err=0x04)
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
ata1: failed to recover some devices, retrying in 5 secs
input: PS/2 Generic Mouse as /class/input/input3
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 rejected by device (Stat=0x51 Err=0x04)
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
ata1.00: ACPI: failed the second time, disabled
ata1.00: revalidation failed (errno=1)
ata1: failed to recover some devices, retrying in 5 secs
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 0)
ata3: SATA link down (SStatus 0 SControl 0)
ata4: SATA link down (SStatus 0 SControl 0)
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHV2080B 892C PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
insmod used greatest stack depth: 604 bytes left
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
cs: IO port probe 0x100-0x3af: excluding 0x100-0x107 0x378-0x37f
cs: IO port probe 0x3e0-0x4ff: clean.
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
sd 0:0:0:0: Attached scsi generic sg0 type 0
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input5
ACPI: Sleep Button (CM) [C249]
input: Lid Switch as /class/input/input6
ACPI: Lid Switch [C241]
input: Video Bus as /class/input/input7
ACPI: Video Device [C085] (multi-head: yes  rom: no  post: no)
input: PC Speaker as /class/input/input8
rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci: SDHCI controller found at 0000:04:06.3 [104c:803c] (rev 0)
ACPI: PCI Interrupt 0000:04:06.3[C] -> GSI 22 (level, low) -> IRQ 21
mmc0: SDHCI at 0xf4202000 irq 21 PIO
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: Found a ICH7-M TCO device (Version=2, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
tg3.c:v3.86 (November 9, 2007)
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:01:00.0 to 64
eth0: Tigon3 [partno(BCM95751M) rev 4201 PHY(5750)] (PCI Express) 10/100/1000Base-T Ethernet 00:16:d4:a5:6d:f1
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
ACPI: PCI Interrupt 0000:04:06.2[A] -> GSI 18 (level, low) -> IRQ 19
NET: Registered protocol family 23
intel_rng: FWH not detected
parport_pc 00:03: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 0 [PCSPP,TRISTATE]
IRQ handler type mismatch for IRQ 0
current handler: timer
Pid: 1065, comm: modprobe Not tainted 2.6.24-rc4 #3
 [<c0406175>] show_trace_log_lvl+0x1a/0x2f
 [<c0406a1c>] show_trace+0x12/0x14
 [<c0406d2c>] dump_stack+0x6c/0x72
 [<c0469bf1>] setup_irq+0x196/0x1ae
 [<c0469dc8>] request_irq+0xf4/0x112
 [<f8a59f6d>] parport_pc_probe_port+0x73d/0x8bc [parport_pc]
 [<f8a5a1c6>] parport_pc_pnp_probe+0xda/0xf5 [parport_pc]
 [<c054d98f>] pnp_device_probe+0x66/0x87
 [<c0579ac8>] driver_probe_device+0xe9/0x16a
 [<c0579c72>] __driver_attach+0x76/0xaf
 [<c0578fa6>] bus_for_each_dev+0x3a/0x5f
 [<c0579913>] driver_attach+0x19/0x1b
 [<c05792c5>] bus_add_driver+0x73/0x1aa
 [<c0579e66>] driver_register+0x67/0x6c
 [<c054d781>] pnp_register_driver+0x17/0x19
 [<f8852342>] parport_pc_init+0x268/0x320 [parport_pc]
 [<c0455e51>] sys_init_module+0x1430/0x155c
 [<c040504e>] sysenter_past_esp+0x6b/0xc1
 =======================
parport0: irq 0 in use, resorting to polled operation
ACPI: AC Adapter [C1B2] (off-line)
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi4 : ata_piix
scsi5 : ata_piix
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40a0 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40a8 irq 15
found SMC SuperIO Chip (devid=0x7a rev=01 base=0x004e): LPC47N227
smsc_superio_flat(): fir: 0x100, sir: 0x3e8, dma: 03, irq: 7, mode: 0x0e
smsc_ircc_present: can't get sir_base of 0x3e8
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
tpm_inf_pnp 00:04: Found C205 with ID IFX0102
tpm_inf_pnp 00:04: TPM found: config base 0x560, data base 0x570, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
ata5.00: ATAPI: HL-DT-STCD-RW/DVD DRIVE GCC-4247N, 1.01, max MWDMA2
ACPI: Battery Slot [C1B4] (battery present)
ACPI: Battery Slot [C1B3] (battery absent)
Bluetooth: HCI USB driver ver 2.9
usbcore: registered new interface driver hci_usb
ata5.00: configured for MWDMA2
ata6: port disabled. ignoring.
scsi 4:0:0:0: CD-ROM            HL-DT-ST RW/DVD GCC-4247N 1.01 PQ: 0 ANSI: 5
scsi 4:0:0:0: Attached scsi generic sg1 type 5
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1b.0 to 64
Clocksource tsc unstable (delta = -100783695 ns)
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
EXT3 FS on sda3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1839432k swap on /dev/sda4.  Priority:-1 extents:1 across:1839432k
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
audit(1196956139.967:2): audit_pid=1686 old=0 by auid=4294967295
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
ADDRCONF(NETDEV_UP): eth0: link is not ready
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized i915 1.6.0 20060119 on minor 0

--Boundary_(ID_FM+W0pvuxJvB6lqm54L1lQ)--
