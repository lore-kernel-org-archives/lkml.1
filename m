Return-Path: <linux-kernel-owner+w=401wt.eu-S932568AbYCFHHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbYCFHHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 02:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758057AbYCFHHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 02:07:25 -0500
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:50131 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028AbYCFHHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 02:07:21 -0500
Message-ID: <47CF96E2.9020302@freemail.hu>
Date: Thu, 06 Mar 2008 08:01:54 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: AE_ERROR, ACPI thermal trip point state changed
References: <47B328AA.1000800@freemail.hu> <47B3F147.7000704@freemail.hu>
In-Reply-To: <47B3F147.7000704@freemail.hu>
Content-Type: multipart/mixed;
 boundary="------------050505090308030708020909"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050505090308030708020909
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit

Hi,

in my dmesg the following lines appear with linux-2.6.25-rc4 on Clevo D410J laptop:

ACPI Exception (thermal-0514): AE_ERROR, ACPI thermal trip point state changed
Please send acpidump to linux-acpi@vger.kernel.org
 [20070126]

Should I do something else than sending the acpidump?

	Márton Németh


Németh Márton wrote:
> Hi,
> 
> I get the following message from the kernel 2.6.25-rc1 on Clevo D410J laptop:
> 
> ACPI Exception (thermal-0514): AE_ERROR, ACPI thermal trip point state changed
> Please send acpidump to linux-acpi@vger.kernel.org
>  [20070126]
> 
> So I am writing this email to you.
> 
> 	Márton Németh


--------------050505090308030708020909
Content-Type: text/plain;
 name="dmesg-2.6.25-rc4.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg-2.6.25-rc4.txt"

Linux version 2.6.25-rc4 (nmarci@europa) (gcc version 4.2.3 20080114 (prerelease) (Debian 4.2.2-7)) #1 PREEMPT Wed Mar 5 21:34:08 CET 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003bf70000 (usable)
 BIOS-e820: 000000003bf70000 - 000000003bf7a000 (ACPI data)
 BIOS-e820: 000000003bf7a000 - 000000003bf80000 (ACPI NVS)
 BIOS-e820: 000000003bf80000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
63MB HIGHMEM available.
896MB LOWMEM available.
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00f6870] 000f6870
Entering add_active_range(0, 0, 245616) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   245616
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   245616
On node 0 totalpages: 245616
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 126 pages used for memmap
  HighMem zone: 16114 pages, LIFO batch:3
  Movable zone: 0 pages used for memmap
DMI present.
ACPI: RSDP 000F68D0, 0014 (r0 PTLTD )
ACPI: RSDT 3BF7600B, 0030 (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 3BF79E87, 0074 (r1 AMDK8  PTLTW     6040000 PTL_    F4240)
ACPI: DSDT 3BF7603B, 3E4C (r1  VIA   PTL_ACPI  6040000 MSFT  100000E)
ACPI: FACS 3BF7AFC0, 0040
ACPI: SSDT 3BF79EFB, 00B5 (r1 PTLTD  POWERNOW  6040000  LTP        1)
ACPI: APIC 3BF79FB0, 0050 (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:12 APIC version 16
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 3, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ10 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:bffe0000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000d8000
PM: Registered nosave memory: 00000000000d8000 - 0000000000100000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 243698
Kernel command line: root=/dev/hda3 ro log_buf_len=1M resume=/dev/hda2
log_buf_len: 1048576
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1603.695 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 992 kB
 per task-struct memory footprint: 1920 bytes
------------------------
| Locking API testsuite:
----------------------------------------------------------------------------
                                 | spin |wlock |rlock |mutex | wsem | rsem |
  --------------------------------------------------------------------------
                     A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                    double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                  initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
  --------------------------------------------------------------------------
              recursive read-lock:             |  ok  |             |  ok  |
           recursive read-lock #2:             |  ok  |             |  ok  |
            mixed read-write-lock:             |  ok  |             |  ok  |
            mixed write-read-lock:             |  ok  |             |  ok  |
  --------------------------------------------------------------------------
     hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
      hard-irq read-recursion/123:  ok  |
      soft-irq read-recursion/123:  ok  |
      hard-irq read-recursion/132:  ok  |
      soft-irq read-recursion/132:  ok  |
      hard-irq read-recursion/213:  ok  |
      soft-irq read-recursion/213:  ok  |
      hard-irq read-recursion/231:  ok  |
      soft-irq read-recursion/231:  ok  |
      hard-irq read-recursion/312:  ok  |
      soft-irq read-recursion/312:  ok  |
      hard-irq read-recursion/321:  ok  |
      soft-irq read-recursion/321:  ok  |
-------------------------------------------------------
Good, all 218 testcases passed! |
---------------------------------
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 966876k/982464k available (2071k kernel code, 15072k reserved, 891k data, 272k init, 64960k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffa8000 - 0xfffff000   ( 348 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc03e8000 - 0xc042c000   ( 272 kB)
      .data : 0xc0305c2b - 0xc03e4c18   ( 891 kB)
      .text : 0xc0100000 - 0xc0305c2b   (2071 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay using timer specific routine.. 3210.53 BogoMIPS (lpj=1605269)
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 128K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: AMD Mobile AMD Sempron(tm) Processor 2600+ stepping 00
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 480 Objects with 49 Devices 147 Methods 13 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 3 Objects with 0 Devices 0 Methods 0 Regions
 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
net_namespace: 604 bytes
NET: Registered protocol family 16
EISA bus registered
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd88c, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 0F [_GPE] 2 regs on int 0xA
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 4 Wake, Enabled 0 Runtime GPEs in this block
ACPI: EC: Look up EC in DSDT
Completing Region/Field/Buffer/Package initialization:.....................................................
Initialized 11/13 Regions 1/1 Fields 23/24 Buffers 18/26 Packages (492 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:.
Executed 1 _INI methods requiring 1 _STA executions (examined 53 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: EC: missing write data confirmation, don't expect it any longer.
ACPI: EC: GPE = 0xb, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:11.0: quirk: region 4000-407f claimed by vt8235 PM
pci 0000:00:11.0: quirk: region 8100-810f claimed by vt8235 SMB
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [ALKA] (IRQs 16 17 18 19 20 21 22 23) *9, disabled.
ACPI: PCI Interrupt Link [ALKB] (IRQs 16 17 18 19 20 21 22 23) *11, disabled.
ACPI: PCI Interrupt Link [ALKC] (IRQs 22) *10, disabled.
ACPI: PCI Interrupt Link [ALKD] (IRQs 21) *5, disabled.
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 *9 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 7 9 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
 00:05: calling quirk 0xc025ae70: quirk_supermicro_h8dce_system+0x0/0x110()
pnp 00:05: Plug and Play ACPI device, IDs PNP0c01 (active)
 00:06: calling quirk 0xc025ae70: quirk_supermicro_h8dce_system+0x0/0x110()
pnp 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:07: Plug and Play ACPI device, IDs PNP0f13 (active)
pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:0a: Plug and Play ACPI device, IDs PNP0401 (active)
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: the driver 'system' has been registered
system 00:05: iomem range 0x0-0x9ffff could not be reserved
system 00:05: iomem range 0xe0000-0xfffff could not be reserved
system 00:05: iomem range 0xfff00000-0xffffffff could not be reserved
system 00:05: iomem range 0xffee0000-0xffefffff has been reserved
system 00:05: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:05: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:05: driver attached
system 00:06: ioport range 0x4d0-0x4d1 has been reserved
system 00:06: ioport range 0xfe10-0xfe11 has been reserved
system 00:06: ioport range 0xfe00-0xfe00 has been reserved
system 00:06: ioport range 0x4000-0x407f has been reserved
system 00:06: ioport range 0x8100-0x811f could not be reserved
Time: tsc clocksource has been installed.
system 00:06: driver attached
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: 0xd1000000-0xd1ffffff
  PREFETCH window: 0x00000000f0000000-0x00000000f3ffffff
PCI: Bus 2, cardbus bridge: 0000:00:0c.0
  IO window: 0x00002000-0x000020ff
  IO window: 0x00002400-0x000024ff
  PREFETCH window: 0x50000000-0x53ffffff
  MEM window: 0x54000000-0x57ffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
PCI: Enabling device 0000:00:0c.0 (0000 -> 0003)
ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:0c.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
audit: initializing netlink socket (disabled)
type=2000 audit(1204788516.711:1): initialized
highmem bounce pool size: 64 pages
io scheduler noop registered
io scheduler cfq registered (default)
PCI: VIA PCI bridge detected. Disabling DAC.
pci 0000:01:00.0: Boot video device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
VP_IDE: IDE controller (0x1106:0x0571 rev 0x06) at  PCI slot 0000:00:11.1
ACPI: PCI Interrupt Link [ALKA] disabled and referenced, BIOS bug
ACPI: PCI Interrupt Link [ALKA] BIOS reported IRQ 0, using IRQ 23
ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:11.1[A] -> Link [ALKA] -> GSI 23 (level, low) -> IRQ 23
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt8235 (rev 00) IDE UDMA133 controller on pci0000:00:11.1
    ide0: BM-DMA at 0x1c60-0x1c67, BIOS settings: hda:DMA, hdb:PIO
    ide1: BM-DMA at 0x1c68-0x1c6f, BIOS settings: hdc:DMA, hdd:PIO
Probing IDE interface ide0...
Switched to high resolution mode on CPU 0
hdb: IRQ probe failed (0xfffffbfe)
hdb: IRQ probe failed (0xfffffbfe)
hda: SAMSUNG MP0804H, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
Probing IDE interface ide1...
hdc: Optiarc DVD RW AD-7543A, ATAPI CD/DVD-ROM drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
pnp: the driver 'ide' has been registered
hda: max request size: 512KiB
hda: 156368016 sectors (80060 MB) w/8192KiB Cache, CHS=16383/255/63
hda: cache flushes supported
 hda: hda1 hda2 hda3
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
ReiserFS: hda3: found reiserfs format "3.6" with standard journal
ReiserFS: hda3: using ordered data mode
ReiserFS: hda3: journal params: device hda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: hda3: checking transaction log (hda3)
ReiserFS: hda3: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 272k freed
Write protecting the kernel read-only data: 732k
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: ACPI0007:00 is registered as cooling_device0
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWB]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
input: Lid Switch as /class/input/input3
ACPI: Lid Switch [LID]
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [THRM] (14 C)
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
Yenta: CardBus bridge found at 0000:00:0c.0 [1558:4702]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:0c.0, mfunc 0x00001002, devctl 0x44
8139too Fast Ethernet driver 0.9.28
hdc: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
Yenta: ISA IRQ mask 0x0840, PCI irq 16
Socket status: 30000006
ACPI: PCI Interrupt 0000:00:08.0[A] -> GSI 19 (level, low) -> IRQ 19
eth0: RealTek RTL8139 at 0xf88fa000, 00:90:f5:3e:5a:ca, IRQ 19
eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
Marking TSC unstable due to: possible TSC halt in C2.
Time: acpi_pm clocksource has been installed.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
input: PC Speaker as /class/input/input4
pnp: the driver 'parport_pc' has been registered
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 1 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Real Time Clock Driver v1.12ac
parport_pc 00:0a: driver attached
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [ALKD] disabled and referenced, BIOS bug
ACPI: PCI Interrupt Link [ALKD] BIOS reported IRQ 0, using IRQ 21
ACPI: PCI Interrupt Link [ALKD] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [ALKD] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:10.0: irq 21, io base 0x00001c00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [ALKD] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.1: irq 21, io base 0x00001c20
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.2[C] -> Link [ALKD] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.2: irq 21, io base 0x00001c40
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
pnp: the driver 'serial' has been registered
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial 00:09: driver attached
ACPI: PCI Interrupt 0000:00:10.3[D] -> Link [ALKD] -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:10.3: EHCI Host Controller
ehci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:10.3: irq 21, io mem 0xd0004400
ehci_hcd 0000:00:10.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
cs: IO port probe 0x100-0x4ff: clean.
cs: IO port probe 0x800-0x8ff: clean.
cs: IO port probe 0xc00-0xcff: clean.
cs: IO port probe 0xa00-0xaff: clean.
ACPI: PCI Interrupt Link [ALKC] disabled and referenced, BIOS bug
ACPI: PCI Interrupt Link [ALKC] BIOS reported IRQ 0, using IRQ 22
ACPI: PCI Interrupt Link [ALKC] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:11.6[C] -> Link [ALKC] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:11.6 to 64
ACPI: PCI Interrupt 0000:00:11.5[C] -> Link [ALKC] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:11.5 to 64
Adding 1951888k swap on /dev/hda2.  Priority:-1 extents:1 across:1951888k
pnp: the driver 'i8042 kbd' has been registered
i8042 kbd 00:08: driver attached
pnp: the driver 'i8042 aux' has been registered
i8042 aux 00:07: driver attached
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
input: AT Translated Set 2 keyboard as /class/input/input5
powernow-k8: Found 1 Mobile AMD Sempron(tm) Processor 2600+ processors (1 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x8 (1600 MHz), vid 0x6
powernow-k8:    1 : fid 0x0 (800 MHz), vid 0x18
powernow-k8: ph2 null fid transition 0x8
input: PS/2 Mouse as /class/input/input6
input: AlpsPS/2 ALPS GlidePoint as /class/input/input7
mice: PS/2 mouse device common for all mice
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized via 2.11.1 20070202 on minor 0
leds_clevo_mail: 'Clevo D410J' found
Registered led device: clevo::mail
ACPI Exception (thermal-0514): AE_ERROR, ACPI thermal trip point state changed
Please send acpidump to linux-acpi@vger.kernel.org
 [20070126]
ReiserFS: hda1: found reiserfs format "3.6" with standard journal
ReiserFS: hda1: using ordered data mode
ReiserFS: hda1: journal params: device hda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: hda1: checking transaction log (hda1)
ReiserFS: hda1: Using r5 hash to sort names
ip_tables: (C) 2000-2006 Netfilter Core Team
eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
NET: Registered protocol family 10
lp0: using parport0 (interrupt-driven).
ppdev: user-space parallel port driver
Clocksource tsc unstable (delta = -282353088 ns)
eth0: no IPv6 routers present
warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
irq 16: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Not tainted 2.6.25-rc4 #1
 [<c0157227>] __report_bad_irq+0x27/0x90
 [<c01574c6>] note_interrupt+0x236/0x270
 [<c01568d3>] ? handle_IRQ_event+0x53/0x60
 [<c0157b6a>] handle_fasteoi_irq+0x7a/0xd0
 [<c0106174>] do_IRQ+0x44/0xa0
 [<c0104c66>] common_interrupt+0x2e/0x34
 [<c0301ac8>] ? _spin_unlock_irq+0x28/0x50
 [<c0118974>] finish_task_switch+0x54/0xc0
 [<c0118920>] ? finish_task_switch+0x0/0xc0
 [<c02ff326>] schedule+0x2b6/0x470
 [<f892fdae>] ? acpi_processor_idle+0x0/0x436 [processor]
 [<c0102b65>] cpu_idle+0xb5/0xd0
 [<c02fa66c>] rest_init+0x5c/0x60
 =======================
handlers:
[<f8915830>] (yenta_interrupt+0x0/0xe0 [yenta_socket])
[<f8aee3f0>] (via_driver_irq_handler+0x0/0x1c0 [via])
Disabling IRQ #16

--------------050505090308030708020909
Content-Type: application/gzip;
 name="acpidump-Clevo-D410J.txt.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="acpidump-Clevo-D410J.txt.gz"

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
--------------050505090308030708020909--
