Return-Path: <linux-kernel-owner+w=401wt.eu-S934047AbXHFXU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047AbXHFXU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 19:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762192AbXHFXUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 19:20:47 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:20250 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758755AbXHFXUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 19:20:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-x-sender:to:cc:subject:message-id:mime-version:content-type;
        b=otKAoQ4RkwPxM5vZarE/6aq5JxxC3yXD0/nwhW+r9NUnRzkYhcL+7tl+aEaHFcs/B8NExv67UbJvK+cRrqnRrvom6E+7KH8qJ7dYYTzxO+zmTIfPTnoCBg0HcD1KJvvSuOvlIqPLTIoRwBwgGdfXA3oTWQ+mZSxMZWFvOwUFDcI=
Date: Tue, 7 Aug 2007 07:20:36 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Indan Zupancic <indan@nul.nu>, Jan Engelhardt <jengelh@computergmbh.de>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.23-rc2
Message-ID: <Pine.LNX.4.64.0708070717450.3740@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Here's my dmesg ...


Thanks,
Jeff

Linux version 2.6.23-rc2 (root@boston.corp.fedex.com) (gcc version 3.4.5) #5 SMP PREEMPT Sat Aug 4 13:03:10 SGT 2007
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 00000000bf6d0000 (usable)
  BIOS-e820: 00000000bf6d0000 - 00000000bf6df000 (ACPI data)
  BIOS-e820: 00000000bf6df000 - 00000000bf700000 (ACPI NVS)
  BIOS-e820: 00000000bf700000 - 00000000c0000000 (reserved)
  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
2166MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f67f0
Entering add_active_range(0, 0, 784080) 0 entries of 256 used
Zone PFN ranges:
   DMA             0 ->     4096
   Normal       4096 ->   229376
   HighMem    229376 ->   784080
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
     0:        0 ->   784080
On node 0 totalpages: 784080
   DMA zone: 32 pages used for memmap
   DMA zone: 0 pages reserved
   DMA zone: 4064 pages, LIFO batch:0
   Normal zone: 1760 pages used for memmap
   Normal zone: 223520 pages, LIFO batch:31
   HighMem zone: 4333 pages used for memmap
   HighMem zone: 550371 pages, LIFO batch:31
   Movable zone: 0 pages used for memmap
DMI present.
ACPI: RSDP 000F67B0, 0024 (r2 LENOVO)
ACPI: XSDT BF6D1828, 008C (r1 LENOVO TP-7B        2110  LTP        0)
ACPI: FACP BF6D1900, 00F4 (r3 LENOVO TP-7B        2110 LNVO        1)
ACPI Warning (tbfadt-0442): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20070126]
ACPI: DSDT BF6D1C90, CF2F (r1 LENOVO TP-7B        2110 MSFT  100000E)
ACPI: FACS BF6F4000, 0040
ACPI: SSDT BF6D1AB4, 01DC (r1 LENOVO TP-7B        2110 MSFT  100000E)
ACPI: ECDT BF6DEBBF, 0052 (r1 LENOVO TP-7B        2110 LNVO        1)
ACPI: TCPA BF6DEC11, 0032 (r2 LENOVO TP-7B        2110 LNVO        1)
ACPI: APIC BF6DEC43, 0068 (r1 LENOVO TP-7B        2110 LNVO        1)
ACPI: MCFG BF6DECAB, 003C (r1 LENOVO TP-7B        2110 LNVO        1)
ACPI: HPET BF6DECE7, 0038 (r1 LENOVO TP-7B        2110 LNVO        1)
ACPI: SLIC BF6DEE62, 0176 (r1 LENOVO TP-7B        2110  LTP        0)
ACPI: BOOT BF6DEFD8, 0028 (r1 LENOVO TP-7B        2110  LTP        1)
ACPI: SSDT BF6F2645, 025F (r1 LENOVO TP-7B        2110 INTL 20050513)
ACPI: SSDT BF6F28A4, 00A6 (r1 LENOVO TP-7B        2110 INTL 20050513)
ACPI: SSDT BF6F294A, 04F7 (r1 LENOVO TP-7B        2110 INTL 20050513)
ACPI: SSDT BF6F2E41, 01D8 (r1 LENOVO TP-7B        2110 INTL 20050513)
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:14 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:14 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
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
Allocating PCI resources starting at c4000000 (gap: c0000000:30000000)
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000dc000
swsusp: Registered nosave memory region: 00000000000dc000 - 0000000000100000
Built 1 zonelists in Zone order.  Total pages: 777955
Kernel command line: BOOT_IMAGE=(hd0,14)/linux/bzc1 root=/dev/sda2 resume=/dev/sda3 reboot=bios testing_only="this is got to be good. Now I can send in a very long line just like 2.4 and need not worry about the line being too long. What a great way to start a great year!!! Cool!"
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1828.798 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3105480k/3136320k available (2531k kernel code, 29740k reserved, 1235k data, 224k init, 2218816k highmem)
virtual kernel memory layout:
     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
     vmalloc : 0xf8800000 - 0xffbfe000   ( 115 MB)
     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
       .init : 0xc04b4000 - 0xc04ec000   ( 224 kB)
       .data : 0xc0378cc2 - 0xc04ad8e0   (1235 kB)
       .text : 0xc0100000 - 0xc0378cc2   (2531 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3661.54 BogoMIPS (lpj=7323093)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfe9fbff 00000000 00000000 00000000 0000c1a9 00000000 00000000 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfe9fbff 00000000 00000000 00002940 0000c1a9 00000000 00000000 00000000
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
CPU0: Intel(R) Core(TM) Duo CPU      L2500  @ 1.83GHz stepping 0c
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3657.57 BogoMIPS (lpj=7315142)
CPU: After generic identify, caps: bfe9fbff 00000000 00000000 00000000 0000c1a9 00000000 00000000 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfe9fbff 00000000 00000000 00002940 0000c1a9 00000000 00000000 00000000
CPU1: Intel(R) Core(TM) Duo CPU      L2500  @ 1.83GHz stepping 0c
Total of 2 processors activated (7319.11 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 579667 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to: check_tsc_sync_source failed.
Brought up 2 CPUs
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: EC description table is found, configuring boot EC
ACPI: Interpreter enabled
ACPI: (supports S0 S3)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62<6>ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: Power Resource [PUBS] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NET: Registered protocol family 23
Time: hpet clocksource has been installed.
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xc0000-0xc3fff could not be reserved
pnp: 00:00: iomem range 0xc4000-0xc7fff could not be reserved
pnp: 00:00: iomem range 0xc8000-0xcbfff has been reserved
pnp: 00:02: iomem range 0xf0000000-0xf3ffffff could not be reserved
pnp: 00:02: iomem range 0xfed1c000-0xfed1ffff could not be reserved
pnp: 00:02: iomem range 0xfed14000-0xfed17fff could not be reserved
pnp: 00:02: iomem range 0xfed18000-0xfed18fff could not be reserved
PCI: Bridge: 0000:00:1c.0
   IO window: 2000-2fff
   MEM window: ee000000-ee0fffff
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
   IO window: 3000-4fff
   MEM window: ec000000-edffffff
   PREFETCH window: e4000000-e40fffff
PCI: Bridge: 0000:00:1c.2
   IO window: 5000-6fff
   MEM window: e8000000-e9ffffff
   PREFETCH window: e4100000-e41fffff
PCI: Bridge: 0000:00:1c.3
   IO window: 7000-8fff
   MEM window: ea000000-ebffffff
   PREFETCH window: e4200000-e42fffff
PCI: Bus 22, cardbus bridge: 0000:15:00.0
   IO window: 00009000-000090ff
   IO window: 00009400-000094ff
   PREFETCH window: e0000000-e3ffffff
   MEM window: c4000000-c7ffffff
PCI: Bridge: 0000:00:1e.0
   IO window: 9000-cfff
   MEM window: e4300000-e7ffffff
   PREFETCH window: e0000000-e3ffffff
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 20 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 21 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 22 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 23 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Enabling device 0000:00:1e.0 (0005 -> 0007)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:15:00.0[A] -> GSI 16 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:15:00.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag at 0x35 set to 0x1
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered (default)
Boot video device is 0000:00:02.0
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
Allocate Port Service[0000:00:1c.1:pcie02]
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
Allocate Port Service[0000:00:1c.2:pcie02]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
Allocate Port Service[0000:00:1c.3:pcie02]
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
input: Power Button (FF) as /devices/virtual/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /devices/virtual/input/input1
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /devices/virtual/input/input2
ACPI: Sleep Button (CM) [SLPB]
ACPI: SSDT BF6F1D26, 0240 (r1  PmRef  Cpu0Ist      100 INTL 20050513)
ACPI: SSDT BF6F1FEB, 065A (r1  PmRef  Cpu0Cst      100 INTL 20050513)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT BF6F1C5E, 00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
ACPI: SSDT BF6F1F66, 0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Thermal Zone [THM0] (55 C)
ACPI: Thermal Zone [THM1] (55 C)
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102
agpgart: Detected an Intel 945GM Chipset.
agpgart: Detected 7932K stolen memory.
agpgart: AGP aperture is 256M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 20
[drm] Initialized i915 1.6.0 20060119 on minor 0
RAMDISK driver initialized: 16 RAM disks of 20480K size 1024 blocksize
loop: module loaded
thinkpad_acpi: ThinkPad ACPI Extras v0.15
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 7BETD0WW (2.11 ), EC 7BHT40WW-1.13
thinkpad_acpi: Lenovo ThinkPad X60s
thinkpad_acpi: radio switch found; radios are enabled
input: ThinkPad Extra Buttons as /devices/virtual/input/input3
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH7: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 20
ICH7: chipset revision 2
ICH7: not 100% native mode: will probe irqs later
     ide0: BM-DMA at 0x1810-0x1817, BIOS settings: hda:pio, hdb:pio
Probing IDE interface ide0...
Clocksource tsc unstable (delta = -478084046 ns)
Probing IDE interface ide0...
Probing IDE interface ide1...
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.03.10-rc5 Thu May 17 10:09:32 PDT 2007
ahci 0000:00:1f.2: version 2.3
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 20
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 cmd 0xf8846500 ctl 0x00000000 bmdma 0x00000000 irq 20
ata2: SATA max UDMA/133 cmd 0xf8846580 ctl 0x00000000 bmdma 0x00000000 irq 20
ata3: SATA max UDMA/133 cmd 0xf8846600 ctl 0x00000000 bmdma 0x00000000 irq 20
ata4: SATA max UDMA/133 cmd 0xf8846680 ctl 0x00000000 bmdma 0x00000000 irq 20
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: Hitachi HTS541616J9SA00, SB4OC70P, max UDMA/100
ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (not used)
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 0)
ata3: SATA link down (SStatus 0 SControl 0)
ata4: SATA link down (SStatus 0 SControl 0)
scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS54161 SB4O PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 sda13 sda14 sda15 >
sd 0:0:0:0: [sda] Attached SCSI disk
usbmon: debugfs is not available
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 21, io mem 0xee444000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001820
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 22, io base 0x00001840
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 23, io base 0x00001860
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 21, io base 0x00001880
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
EDAC MC: Ver: 2.1.0 Aug  4 2007
usb 5-2: new full speed USB device using uhci_hcd and address 2
usb 5-2: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 2007 UTC).
ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1b.0 to 64
ALSA device list:
   #0: HDA Intel at 0xee240000 irq 22
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
arp_tables: (C) 2002 David S. Miller
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Starting balanced_irq
Using IPI No-Shortcut mode
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input5
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 224k freed
Adding 3719036k swap on /dev/sda3.  Priority:-1 extents:1 across:3719036k
