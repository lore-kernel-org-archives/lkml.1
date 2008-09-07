Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYIGTWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYIGTWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 15:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbYIGTWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 15:22:07 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:27694 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbYIGTWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 15:22:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:content-type:date:message-id:mime-version
         :x-mailer;
        b=j4xlgwRmZ/n1jBPT0Ep1Zyxkxagdo7e7gK1yWXamCYvwW/3SQLDnlXQDACLsDlnWZV
         5UTJBqp+VzJK26t2o1yw14A1Ge8EfkK8+DFtj4sFISUCwk9QMrX4BhyaQE6oMQ9bFNAf
         paBaz3EW9b1E6NhKOsN2NQdyVqO0WQkby7prU=
Subject: Various OOps with 2.6.27-rc5
From: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<alejandro.riveira@gmail.com>
Reply-To: alejandro.riveira@gmail.com
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZEpVGlq8ESsbL1/TKvEG"
Date: Sun, 07 Sep 2008 21:21:36 +0200
Message-Id: <1220815296.11776.4.camel@Varda>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZEpVGlq8ESsbL1/TKvEG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

My kernel is tainted so maybe you want to stop reading here.

Linux Varda 2.6.27-rc5 #89 SMP PREEMPT Fri Aug 29 12:43:32 CEST 2008 x86_64=
 GNU/Linux
=20
Gnu C                  4.2.3
Gnu make               3.81
binutils               2.18.0.20080103
util-linux             2.13.1
mount                  2.13.1
module-init-tools      3.3-pre11
e2fsprogs              1.40.8
jfsutils               1.1.11
reiserfsprogs          3.6.19
pcmciautils            014
PPP                    2.4.4
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Net-tools              1.60
Kbd                    [opcion...][archivo
Console-tools          0.2.3
Sh-utils               6.10
udev                   117
wireless-tools         29
Modules Loaded         binfmt_misc af_packet rfcomm l2cap bluetooth ipv6 pc=
i_slot container powernow_k8 cpufreq_userspace cpufreq_stats cpufreq_powers=
ave cpufreq_ondemand freq_table cpufreq_conservative nf_conntrack_ftp nf_co=
nntrack_irc xt_tcpudp ipt_ULOG xt_limit xt_state nf_conntrack_ipv4 nf_connt=
rack iptable_filter ip_tables x_tables kvm_amd kvm w83627ehf hwmon_vid lp a=
rc4 snd_hda_intel ecb crypto_blkcipher cryptomgr crypto_algapi snd_pcm_oss =
snd_mixer_oss snd_mpu401 snd_pcm rt2500pci rt2x00pci rt2x00lib snd_mpu401_u=
art snd_seq_dummy rfkill snd_seq_oss snd_seq_midi led_class snd_rawmidi snd=
_seq_midi_event mac80211 evdev cfg80211 k8temp pcspkr eeprom_93cx6 snd_seq =
usblp nvidia snd_timer snd_seq_device 8250_pnp parport_pc 8250 serial_core =
parport i2c_ali1535 i2c_ali15x3 snd i2c_core soundcore snd_page_alloc uli52=
6x button sr_mod usbhid ff_memless cdrom floppy sg ata_generic ehci_hcd r81=
69 ohci_hcd usbcore unix thermal processor fan fuse

00:00.0 Host bridge: ALi Corporation M1697 HTT Host Bridge
00:01.0 PCI bridge: ALi Corporation PCI Express Root Port
00:02.0 PCI bridge: ALi Corporation PCI Express Root Port
00:03.0 PCI bridge: ALi Corporation PCI Express Root Port
00:04.0 PCI bridge: ALi Corporation PCI Express Root Port
00:11.0 PCI bridge: ALi Corporation M5249 HTT to PCI Bridge
00:12.0 Ethernet controller: ALi Corporation ULi 1689,1573 integrated ether=
net. (rev 60)
00:13.0 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
00:13.1 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
00:13.2 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
00:13.3 USB Controller: ALi Corporation USB 2.0 Controller (rev 01)
00:14.0 Audio device: ALi Corporation High Definition Audio/AC'97 Host Cont=
roller (rev 01)
00:15.0 ISA bridge: ALi Corporation PCI to LPC Controller (rev 10)
00:15.1 Bridge: ALi Corporation M7101 Power Management Controller [PMU]
00:16.0 IDE interface: ALi Corporation M5229 IDE (rev c7)
00:16.1 SATA controller: ALi Corporation ULi M5288 SATA
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Hyp=
erTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Add=
ress Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRA=
M Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Mis=
cellaneous Control
01:00.0 VGA compatible controller: nVidia Corporation G70 [GeForce 7300 GT]=
 (rev a1)
05:0a.0 Network controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)
05:0b.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169 Gigab=
it Ethernet (rev 10)

The dmesg including oopses

[    0.000000] Linux version 2.6.27-rc5 (alex@Varda) (gcc version 4.2.3 (Ub=
untu 4.2.3-2ubuntu7)) #89 SMP PREEMPT Fri Aug 29 12:43:32 CEST 2008
[    0.000000] Command line: BOOT_IMAGE=3D(hd0,2)/vmlinuz-2.6.27-rc5 root=
=3DUUID=3Dee465ea1-394d-4dd2-a5f9-a35567176c40 ro quiet splash
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000bffb0000 - 00000000bffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bffc0000 - 00000000bfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfff0000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000] last_pfn =3D 0xbffb0 max_arch_pfn =3D 0x3ffffffff
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] init_memory_mapping
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bffb0000 page 4k
[    0.000000] kernel direct mapping tables up to bffb0000 @ 8000-d000
[    0.000000] last_map_addr: bffb0000 end: bffb0000
[    0.000000] RAMDISK: 37c5a000 - 37fef621
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F90F0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT BFFB0000, 0040 (r1 A M I  OEMRSDT   3000715 MSFT =
      97)
[    0.000000] ACPI: FACP BFFB0200, 0084 (r2 A M I  OEMFACP  12000601 MSFT =
      97)
[    0.000000] ACPI: DSDT BFFB0440, 4B5A (r1  AM2ES AM2ES136      136 INTL =
 2002026)
[    0.000000] ACPI: FACS BFFC0000, 0040
[    0.000000] ACPI: APIC BFFB0390, 0068 (r1 A M I  OEMAPIC   3000715 MSFT =
      97)
[    0.000000] ACPI: MCFG BFFB0400, 003C (r1 A M I  OEMMCFG   3000715 MSFT =
      97)
[    0.000000] ACPI: SSDT BFFB4FA0, 002B (r1 OEM_ID OEMTBLID        1 INTL =
 2002026)
[    0.000000] ACPI: OEMB BFFC0040, 0056 (r1 A M I  AMI_OEM   3000715 MSFT =
      97)
[    0.000000] ACPI: HPET BFFB4FD0, 0038 (r1 A M I  OEMHPET   3000715 MSFT =
      97)
[    0.000000] ACPI: SSDT BFFB5010, 01C4 (r1 A M I  POWERNOW        1 AMD  =
       1)
[    0.000000] (6 early reservations) =3D=3D> bootmem [0000000000 - 00bffb0=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [000=
0006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00005ac84c]    TEXT DATA BSS =3D=3D> [000=
0200000 - 00005ac84c]
[    0.000000]   #3 [0037c5a000 - 0037fef621]          RAMDISK =3D=3D> [003=
7c5a000 - 0037fef621]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved =3D=3D> [000=
009fc00 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000b000]          PGTABLE =3D=3D> [000=
0008000 - 000000b000]
[    0.000000]  [ffffe20000000000-ffffe200029fffff] PMD -> [ffff88000120000=
0-ffff880003bfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bffb0
[    0.000000] On node 0 totalpages: 786255
[    0.000000]   DMA zone: 2901 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 771561 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-2=
3
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec10000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 3, version 0, address 0xfec10000, GSI 24-=
44
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at c4000000 (gap: c0000000=
:3f380000)
[    0.000000] PERCPU: Allocating 44804 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 774462
[    0.000000] Kernel command line: BOOT_IMAGE=3D(hd0,2)/vmlinuz-2.6.27-rc5=
 root=3DUUID=3Dee465ea1-394d-4dd2-a5f9-a35567176c40 ro quiet splash
[    0.000000] Initializing CPU#0
[    0.000000] Preemptible RCU implementation.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Detected 1999.973 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.000999] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.000999] Checking aperture...
[    0.000999] No AGP bridge found
[    0.000999] Node 0: aperture @ b52a000000 size 32 MB
[    0.000999] Aperture beyond 4GB. Ignoring.
[    0.000999] Memory: 3087520k/3145408k available (2133k kernel code, 5688=
0k reserved, 950k data, 292k init)
[    0.000999] CPA: page pool initialized 1 of 1 pages preallocated
[    0.000999] SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.000999] hpet clockevent registered
[    0.001009] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 3999.94 BogoMIPS (lpj=3D1999973)
[    0.001036] Mount-cache hash table entries: 256
[    0.001180] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.001182] CPU: L2 Cache: 512K (64 bytes/line)
[    0.001184] tseg: 0000000000
[    0.001191] CPU: Physical Processor ID: 0
[    0.001193] CPU: Processor Core ID: 0
[    0.001202] using C1E aware idle routine
[    0.001217] ACPI: Core revision 20080609
[    0.007728] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.017987] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ steppin=
g 02
[    0.017991] Using local APIC timer interrupts.
[    0.017998] APIC timer calibration result 12499830
[    0.018998] Detected 12.499 MHz APIC timer.
[    0.019112] Booting processor 1/1 ip 6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 3999.78 Bog=
oMIPS (lpj=3D1999894)
[    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.000999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x701060007=
0106
[    0.090383] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ steppin=
g 02
[    0.090395] Brought up 2 CPUs
[    0.090398] Total of 2 processors activated (7999.73 BogoMIPS).
[    0.090518] CPU0 attaching sched-domain:
[    0.090520]  domain 0: span 0-1 level CPU
[    0.090523]   groups: 0 1
[    0.090528] CPU1 attaching sched-domain:
[    0.090529]  domain 0: span 0-1 level CPU
[    0.090532]   groups: 1 0
[    0.090827] net_namespace: 1440 bytes
[    0.090988] NET: Registered protocol family 16
[    0.091164] No dock devices found.
[    0.091256] node 0 link 0: io port [1000, ffffff]
[    0.091259] TOM: 00000000c0000000 aka 3072M
[    0.091262] node 0 link 0: mmio [e0000000, efffffff]
[    0.091265] node 0 link 0: mmio [a0000, bffff]
[    0.091268] node 0 link 0: mmio [c0000000, ffffffff]
[    0.091271] bus: [00,ff] on node 0 link 0
[    0.091273] bus: 00 index 0 io port: [0, ffff]
[    0.091275] bus: 00 index 1 mmio: [c0000000, fcffffffff]
[    0.091278] bus: 00 index 2 mmio: [a0000, bffff]
[    0.091284] ACPI: bus type pci registered
[    0.091380] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.091383] PCI: Not using MMCONFIG.
[    0.091385] PCI: Using configuration type 1 for base access
[    0.092855] ACPI: EC: Look up EC in DSDT
[    0.102013] ACPI: Interpreter enabled
[    0.102015] ACPI: (supports S0 S1 S3 S5)
[    0.102029] ACPI: Using IOAPIC for interrupt routing
[    0.102085] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.106893] PCI: MCFG area at e0000000 reserved in ACPI motherboard reso=
urces
[    0.112638] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.122003] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.122121] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.122125] pci 0000:00:01.0: PME# disabled
[    0.122151] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.122154] pci 0000:00:02.0: PME# disabled
[    0.122180] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.122183] pci 0000:00:03.0: PME# disabled
[    0.122209] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.122212] pci 0000:00:04.0: PME# disabled
[    0.122282] pci 0000:00:12.0: PME# supported from D3hot D3cold
[    0.122286] pci 0000:00:12.0: PME# disabled
[    0.122424] pci 0000:00:13.3: PME# supported from D0 D3hot D3cold
[    0.122428] pci 0000:00:13.3: PME# disabled
[    0.122475] pci 0000:00:14.0: PME# supported from D0 D3hot D3cold
[    0.122478] pci 0000:00:14.0: PME# disabled
[    0.122564] pci 0000:00:15.1: quirk: region 4000-403f claimed by ali7101=
 ACPI
[    0.122660] pci 0000:00:16.1: PME# supported from D3hot
[    0.122663] pci 0000:00:16.1: PME# disabled
[    0.122797] PCI: bridge 0000:00:01.0 io port: [d000, dfff]
[    0.122800] PCI: bridge 0000:00:01.0 32bit mmio: [dc000000, deefffff]
[    0.122803] PCI: bridge 0000:00:01.0 32bit mmio pref: [c0000000, cffffff=
f]
[    0.122826] PCI: bridge 0000:00:02.0 32bit mmio pref: [dad00000, dadffff=
f]
[    0.122849] PCI: bridge 0000:00:03.0 32bit mmio pref: [dae00000, daeffff=
f]
[    0.122871] PCI: bridge 0000:00:04.0 32bit mmio pref: [daf00000, dafffff=
f]
[    0.123006] pci 0000:05:0b.0: supports D1
[    0.123008] pci 0000:05:0b.0: supports D2
[    0.123010] pci 0000:05:0b.0: PME# supported from D1 D2 D3hot D3cold
[    0.123014] pci 0000:05:0b.0: PME# disabled
[    0.123039] PCI: bridge 0000:00:11.0 io port: [e000, efff]
[    0.123042] PCI: bridge 0000:00:11.0 32bit mmio: [def00000, deffffff]
[    0.123056] bus 00 -> node 0
[    0.123062] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.123233] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE2P._PRT]
[    0.123422] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB1._PRT]
[    0.123528] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB2._PRT]
[    0.123634] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB3._PRT]
[    0.123740] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB4._PRT]
[    0.136138] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14=
 15)
[    0.136322] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 10 11 12 14=
 15)
[    0.136505] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14=
 15)
[    0.136687] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14=
 15)
[    0.136871] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 *11 12 14=
 15)
[    0.137059] ACPI: PCI Interrupt Link [LNKF] (IRQs 5 6 *10 11 12 14 15)
[    0.137241] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 12 14=
 15)
[    0.137418] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14=
 15), disabled.
[    0.137601] ACPI: PCI Interrupt Link [LNKP] (IRQs 3 4 5 6 7 *10 11 12 14=
 15)
[    0.137791] ACPI Warning (tbutils-0217): Incorrect checksum in table [OE=
MB] - 52, should be 25 [20080609]
[    0.137808] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.137839] pnp: PnP ACPI init
[    0.137846] ACPI: bus type pnp registered
[    0.143268] pnp: PnP ACPI: found 16 devices
[    0.143270] ACPI: ACPI bus type pnp unregistered
[    0.143449] SCSI subsystem initialized
[    0.143521] libata version 3.00 loaded.
[    0.143717] PCI: Using ACPI for IRQ routing
[    0.151153] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.151158] hpet0: 3 64-bit timers, 14318180 Hz
[    0.152007] ACPI: RTC can wake from S4
[    0.152987] Switched to high resolution mode on CPU 0
[    0.153338] Switched to high resolution mode on CPU 1
[    0.162027] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.162030] system 00:08: ioport range 0x4000-0x40bf could not be reserv=
ed
[    0.162033] system 00:08: ioport range 0x40c0-0x40df has been reserved
[    0.162036] system 00:08: ioport range 0x400-0x40f has been reserved
[    0.162039] system 00:08: ioport range 0x480-0x48f has been reserved
[    0.162043] system 00:08: iomem range 0xfff80000-0xffffffff could not be=
 reserved
[    0.162046] system 00:08: iomem range 0xfec10000-0xfec10fff has been res=
erved
[    0.162049] system 00:08: iomem range 0xfe000000-0xfe0000ff has been res=
erved
[    0.162055] system 00:0a: iomem range 0xff380000-0xffffffff could not be=
 reserved
[    0.162058] system 00:0a: iomem range 0xfec00000-0xfec00fff has been res=
erved
[    0.162061] system 00:0a: iomem range 0xfee00000-0xfee00fff has been res=
erved
[    0.162068] system 00:0d: ioport range 0x290-0x29f has been reserved
[    0.162077] system 00:0e: iomem range 0xe0000000-0xefffffff has been res=
erved
[    0.162083] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
[    0.162086] system 00:0f: iomem range 0xc0000-0xcffff has been reserved
[    0.162089] system 00:0f: iomem range 0xe0000-0xfffff could not be reser=
ved
[    0.162092] system 00:0f: iomem range 0x100000-0xbfffffff could not be r=
eserved
[    0.162732] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.162735] pci 0000:00:01.0:   IO window: 0xd000-0xdfff
[    0.162739] pci 0000:00:01.0:   MEM window: 0xdc000000-0xdeefffff
[    0.162743] pci 0000:00:01.0:   PREFETCH window: 0x000000c0000000-0x0000=
00cfffffff
[    0.162747] pci 0000:00:02.0: PCI bridge, secondary bus 0000:02
[    0.162749] pci 0000:00:02.0:   IO window: disabled
[    0.162752] pci 0000:00:02.0:   MEM window: disabled
[    0.162755] pci 0000:00:02.0:   PREFETCH window: 0x000000dad00000-0x0000=
00dadfffff
[    0.162760] pci 0000:00:03.0: PCI bridge, secondary bus 0000:03
[    0.162762] pci 0000:00:03.0:   IO window: disabled
[    0.162765] pci 0000:00:03.0:   MEM window: disabled
[    0.162768] pci 0000:00:03.0:   PREFETCH window: 0x000000dae00000-0x0000=
00daefffff
[    0.162772] pci 0000:00:04.0: PCI bridge, secondary bus 0000:04
[    0.162774] pci 0000:00:04.0:   IO window: disabled
[    0.162777] pci 0000:00:04.0:   MEM window: disabled
[    0.162780] pci 0000:00:04.0:   PREFETCH window: 0x000000daf00000-0x0000=
00daffffff
[    0.162785] pci 0000:00:11.0: PCI bridge, secondary bus 0000:05
[    0.162788] pci 0000:00:11.0:   IO window: 0xe000-0xefff
[    0.162792] pci 0000:00:11.0:   MEM window: 0xdef00000-0xdeffffff
[    0.162795] pci 0000:00:11.0:   PREFETCH window: disabled
[    0.162809] pci 0000:00:01.0: PCI INT A -> GSI 29 (level, low) -> IRQ 29
[    0.162813] pci 0000:00:01.0: setting latency timer to 64
[    0.162819] pci 0000:00:02.0: PCI INT A -> GSI 34 (level, low) -> IRQ 34
[    0.162822] pci 0000:00:02.0: setting latency timer to 64
[    0.162828] pci 0000:00:03.0: PCI INT A -> GSI 39 (level, low) -> IRQ 39
[    0.162831] pci 0000:00:03.0: setting latency timer to 64
[    0.162836] pci 0000:00:04.0: PCI INT A -> GSI 44 (level, low) -> IRQ 44
[    0.162840] pci 0000:00:04.0: setting latency timer to 64
[    0.162845] pci 0000:00:11.0: setting latency timer to 64
[    0.162848] bus: 00 index 0 io port: [0, ffff]
[    0.162850] bus: 00 index 1 mmio: [0, ffffffffffffffff]
[    0.162853] bus: 01 index 0 io port: [d000, dfff]
[    0.162855] bus: 01 index 1 mmio: [dc000000, deefffff]
[    0.162858] bus: 01 index 2 mmio: [c0000000, cfffffff]
[    0.162860] bus: 01 index 3 mmio: [0, 0]
[    0.162862] bus: 02 index 0 mmio: [0, 0]
[    0.162864] bus: 02 index 1 mmio: [0, 0]
[    0.162866] bus: 02 index 2 mmio: [dad00000, dadfffff]
[    0.162869] bus: 02 index 3 mmio: [0, 0]
[    0.162871] bus: 03 index 0 mmio: [0, 0]
[    0.162873] bus: 03 index 1 mmio: [0, 0]
[    0.162875] bus: 03 index 2 mmio: [dae00000, daefffff]
[    0.162877] bus: 03 index 3 mmio: [0, 0]
[    0.162880] bus: 04 index 0 mmio: [0, 0]
[    0.162882] bus: 04 index 1 mmio: [0, 0]
[    0.162884] bus: 04 index 2 mmio: [daf00000, daffffff]
[    0.162886] bus: 04 index 3 mmio: [0, 0]
[    0.162888] bus: 05 index 0 io port: [e000, efff]
[    0.162891] bus: 05 index 1 mmio: [def00000, deffffff]
[    0.162893] bus: 05 index 2 mmio: [0, 0]
[    0.162895] bus: 05 index 3 mmio: [0, 0]
[    0.162905] NET: Registered protocol family 2
[    0.198065] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    0.199129] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    0.201731] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.202377] TCP: Hash tables configured (established 262144 bind 65536)
[    0.202381] TCP reno registered
[    0.214180] checking if image is initramfs... it is
[    0.494761] Freeing initrd memory: 3669k freed
[    0.501564] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[    0.505032] msgmni has been set to 6038
[    0.505326] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    0.505329] io scheduler noop registered
[    0.505331] io scheduler anticipatory registered (default)
[    0.505346] pci 0000:00:00.0: Enabling HT MSI Mapping
[    0.505362] pci 0000:00:01.0: Enabling HT MSI Mapping
[    0.505374] pci 0000:00:02.0: Enabling HT MSI Mapping
[    0.505386] pci 0000:00:03.0: Enabling HT MSI Mapping
[    0.505398] pci 0000:00:04.0: Enabling HT MSI Mapping
[    0.538070] pci 0000:01:00.0: Boot video device
[    0.538191] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    0.538214] pcieport-driver 0000:00:01.0: found MSI capability
[    0.538235] pci_express 0000:00:01.0:pcie00: allocate port service
[    0.538295] pci_express 0000:00:01.0:pcie01: allocate port service
[    0.538344] pci_express 0000:00:01.0:pcie03: allocate port service
[    0.538423] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    0.538445] pcieport-driver 0000:00:02.0: found MSI capability
[    0.538463] pci_express 0000:00:02.0:pcie00: allocate port service
[    0.538512] pci_express 0000:00:02.0:pcie01: allocate port service
[    0.538561] pci_express 0000:00:02.0:pcie03: allocate port service
[    0.538639] pcieport-driver 0000:00:03.0: setting latency timer to 64
[    0.538661] pcieport-driver 0000:00:03.0: found MSI capability
[    0.538678] pci_express 0000:00:03.0:pcie00: allocate port service
[    0.538727] pci_express 0000:00:03.0:pcie01: allocate port service
[    0.538777] pci_express 0000:00:03.0:pcie03: allocate port service
[    0.538859] pcieport-driver 0000:00:04.0: setting latency timer to 64
[    0.538881] pcieport-driver 0000:00:04.0: found MSI capability
[    0.538898] pci_express 0000:00:04.0:pcie00: allocate port service
[    0.538947] pci_express 0000:00:04.0:pcie01: allocate port service
[    0.538996] pci_express 0000:00:04.0:pcie03: allocate port service
[    0.541723] aer 0000:00:01.0:pcie01: service driver aer loaded
[    0.544282] aer 0000:00:02.0:pcie01: service driver aer loaded
[    0.546825] aer 0000:00:03.0:pcie01: service driver aer loaded
[    0.549387] aer 0000:00:04.0:pcie01: service driver aer loaded
[    0.552998] hpet_resources: 0xfed00000 is busy
[    0.553087] Linux agpgart interface v0.103
[    0.554841] brd: module loaded
[    0.554892] Driver 'sd' needs updating - please use bus_type methods
[    0.554963] ahci 0000:00:16.1: version 3.0
[    0.554978] ahci 0000:00:16.1: PCI INT A -> GSI 21 (level, low) -> IRQ 2=
1
[    0.555069] ahci 0000:00:16.1: AHCI 0001.0000 32 slots 4 ports 3 Gbps 0x=
f impl SATA mode
[    0.555073] ahci 0000:00:16.1: flags: ncq sntf ilck pm led clo pmp pio s=
lum part=20
[    0.555487] scsi0 : ahci
[    0.555662] scsi1 : ahci
[    0.555782] scsi2 : ahci
[    0.555906] scsi3 : ahci
[    0.556072] ata1: SATA max UDMA/133 abar m1024@0xdbfef400 port 0xdbfef50=
0 irq 21
[    0.556075] ata2: SATA max UDMA/133 abar m1024@0xdbfef400 port 0xdbfef58=
0 irq 21
[    0.556078] ata3: SATA max UDMA/133 abar m1024@0xdbfef400 port 0xdbfef60=
0 irq 21
[    0.556081] ata4: SATA max UDMA/133 irq_stat 0x00400040, connection stat=
us changed irq 21
[    0.860020] ata1: SATA link down (SStatus 0 SControl 300)
[    1.176018] ata2: SATA link down (SStatus 0 SControl 300)
[    1.492018] ata3: SATA link down (SStatus 0 SControl 300)
[    2.379017] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.380005] ata4.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
[    2.380005] ata4.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32=
)
[    2.380005] ata4.00: configured for UDMA/133
[    1.501006] isa bounce pool size: 16 pages
[    1.501006] scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      3.=
AA PQ: 0 ANSI: 5
[    1.501006] sd 3:0:0:0: [sda] 625142448 512-byte hardware sectors (32007=
3 MB)
[    1.501006] sd 3:0:0:0: [sda] Write Protect is off
[    1.501006] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.501006] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.501006] sd 3:0:0:0: [sda] 625142448 512-byte hardware sectors (32007=
3 MB)
[    1.501006] sd 3:0:0:0: [sda] Write Protect is off
[    1.501006] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.501006] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.501006]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    2.551503] sd 3:0:0:0: [sda] Attached SCSI disk
[    2.551701] pata_ali 0000:00:16.0: PCI INT A -> GSI 21 (level, low) -> I=
RQ 21
[    2.551826] scsi4 : pata_ali
[    2.551953] scsi5 : pata_ali
[    2.554157] ata5: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq=
 14
[    2.554160] ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xff08 irq=
 15
[    2.561255] ata5.00: ATA-6: ST3160021A, 8.01, max UDMA/100
[    2.561255] ata5.00: 312581808 sectors, multi 16: LBA48=20
[    2.561255] ata5.01: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
[    2.561255] ata5.01: 160086528 sectors, multi 16: LBA=20
[    2.886500] ata5.00: configured for UDMA/100
[    2.892444] ata5.01: configured for UDMA/133
[    3.046366] ata6.00: ATAPI: _NEC DVD_RW ND-3540A, 1.01, max UDMA/33
[    3.046375] ata6.00: WARNING: ATAPI DMA disabled for reliablity issues. =
 It can be enabled
[    3.046378] ata6.00: WARNING: via pata_ali.atapi_dma modparam or corresp=
onding sysfs node.
[    3.052305] ata6.00: configured for UDMA/33
[    3.001006] scsi 4:0:0:0: Direct-Access     ATA      ST3160021A       8.=
01 PQ: 0 ANSI: 5
[    3.001006] sd 4:0:0:0: [sdb] 312581808 512-byte hardware sectors (16004=
2 MB)
[    3.001006] sd 4:0:0:0: [sdb] Write Protect is off
[    3.001006] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.001006] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.001006] sd 4:0:0:0: [sdb] 312581808 512-byte hardware sectors (16004=
2 MB)
[    3.001006] sd 4:0:0:0: [sdb] Write Protect is off
[    3.001006] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.001006] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.001006]  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 >
[    3.100274] sd 4:0:0:0: [sdb] Attached SCSI disk
[    3.100434] scsi 4:0:1:0: Direct-Access     ATA      Maxtor 6Y080L0   YA=
R4 PQ: 0 ANSI: 5
[    3.100613] sd 4:0:1:0: [sdc] 160086528 512-byte hardware sectors (81964=
 MB)
[    3.100631] sd 4:0:1:0: [sdc] Write Protect is off
[    3.100634] sd 4:0:1:0: [sdc] Mode Sense: 00 3a 00 00
[    3.100665] sd 4:0:1:0: [sdc] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.100720] sd 4:0:1:0: [sdc] 160086528 512-byte hardware sectors (81964=
 MB)
[    3.100737] sd 4:0:1:0: [sdc] Write Protect is off
[    3.100740] sd 4:0:1:0: [sdc] Mode Sense: 00 3a 00 00
[    3.100771] sd 4:0:1:0: [sdc] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.100774]  sdc: sdc1 sdc2 sdc3
[    3.108271] sd 4:0:1:0: [sdc] Attached SCSI disk
[    3.109254] scsi 5:0:0:0: CD-ROM            _NEC     DVD_RW ND-3540A  1.=
01 PQ: 0 ANSI: 5
[    3.109254] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    3.109254] PNP: PS/2 appears to have AUX port disabled, if this is inco=
rrect please boot with i8042.nopnp
[    3.110529] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.110676] mice: PS/2 mouse device common for all mice
[    3.118255] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    3.145390] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    3.145419] rtc0: alarms up to one month, hpet irqs
[    3.145462] cpuidle: using governor ladder
[    3.145464] cpuidle: using governor menu
[    3.145883] TCP cubic registered
[    3.145885] ieee80211: 802.11 data/management/control stack, git-1.1.13
[    3.145888] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketre=
no@linux.intel.com>
[    3.145891] ieee80211_crypt: registered algorithm 'NULL'
[    3.146043] registered taskstats version 1
[    3.146204] rtc_cmos 00:02: setting system clock to 2008-09-07 09:58:14 =
UTC (1220781494)
[    3.146239] Freeing unused kernel memory: 292k freed
[    3.146376] Write protecting the kernel read-only data: 2876k
[    4.309420] fuse init (API version 7.9)
[    4.321946] ACPI: duty_cycle spans bit 4
[    4.322030] processor ACPI0007:00: registered as cooling_device0
[    4.322099] processor ACPI0007:01: registered as cooling_device1
[    4.329614] NET: Registered protocol family 1
[    4.464932] usbcore: registered new interface driver usbfs
[    4.464969] usbcore: registered new interface driver hub
[    4.468626] usbcore: registered new device driver usb
[    4.470328] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHC=
I) Driver
[    4.470360] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 17 (level, low) -> I=
RQ 17
[    4.470376] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    4.470424] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus =
number 1
[    4.470458] ohci_hcd 0000:00:13.0: irq 17, io mem 0xdbfee000
[    4.500100] sd 3:0:0:0: Attached scsi generic sg0 type 0
[    4.500131] sd 4:0:0:0: Attached scsi generic sg1 type 0
[    4.500157] sd 4:0:1:0: Attached scsi generic sg2 type 0
[    4.500188] scsi 5:0:0:0: Attached scsi generic sg3 type 5
[    4.524137] usb usb1: configuration #1 chosen from 1 choice
[    4.524167] hub 1-0:1.0: USB hub found
[    4.524178] hub 1-0:1.0: 3 ports detected
[    4.556420] Floppy drive(s): fd0 is 1.44M
[    4.571138] FDC 0 is a post-1991 82077
[    4.726213] ohci_hcd 0000:00:13.1: PCI INT B -> GSI 18 (level, low) -> I=
RQ 18
[    4.726231] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    4.726259] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus =
number 2
[    4.726292] ohci_hcd 0000:00:13.1: irq 18, io mem 0xdbfed000
[    4.779101] usb usb2: configuration #1 chosen from 1 choice
[    4.779130] hub 2-0:1.0: USB hub found
[    4.779141] hub 2-0:1.0: 3 ports detected
[    4.838271] usb 1-2: new low speed USB device using ohci_hcd and address=
 2
[    4.880204] ohci_hcd 0000:00:13.2: PCI INT C -> GSI 19 (level, low) -> I=
RQ 19
[    4.880219] ohci_hcd 0000:00:13.2: OHCI Host Controller
[    4.880248] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus =
number 3
[    4.880280] ohci_hcd 0000:00:13.2: irq 19, io mem 0xdbfec000
[    4.933094] usb usb3: configuration #1 chosen from 1 choice
[    4.933126] hub 3-0:1.0: USB hub found
[    4.933136] hub 3-0:1.0: 3 ports detected
[    4.993255] usb 1-2: configuration #1 chosen from 1 choice
[    5.135309] ehci_hcd 0000:00:13.3: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[    5.135322] ehci_hcd 0000:00:13.3: EHCI Host Controller
[    5.135349] ehci_hcd 0000:00:13.3: new USB bus registered, assigned bus =
number 4
[    5.156019] ehci_hcd 0000:00:13.3: debug port 1
[    5.156043] ehci_hcd 0000:00:13.3: irq 23, io mem 0xdbfef800
[    5.248018] usb 3-2: new full speed USB device using ohci_hcd and addres=
s 2
[    5.254014] ehci_hcd 0000:00:13.3: USB 2.0 started, EHCI 1.00, driver 10=
 Dec 2004
[    5.254082] usb usb4: configuration #1 chosen from 1 choice
[    5.254113] hub 4-0:1.0: USB hub found
[    5.254120] hub 4-0:1.0: 8 ports detected
[    5.307020] hub 3-0:1.0: unable to enumerate USB device on port 2
[    5.457581] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.457601] r8169 0000:05:0b.0: PCI INT A -> GSI 19 (level, low) -> IRQ =
19
[    5.457894] eth0: RTL8110s at 0xffffc2000003ac00, 00:4f:63:00:a4:73, XID=
 04000000 IRQ 19
[    5.511322] Driver 'sr' needs updating - please use bus_type methods
[    5.515307] usb 1-2: USB disconnect, address 2
[    5.516150] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tra=
y
[    5.516155] Uniform CD-ROM driver Revision: 3.20
[    5.516279] sr 5:0:0:0: Attached scsi CD-ROM sr0
[    5.634006] usbcore: registered new interface driver hiddev
[    5.885272] usb 1-2: new low speed USB device using ohci_hcd and address=
 3
[    6.019256] usb 1-2: configuration #1 chosen from 1 choice
[    6.257272] usb 3-2: new full speed USB device using ohci_hcd and addres=
s 3
[    6.431377] usb 3-2: configuration #1 chosen from 1 choice
[    6.440398] input: KYE NetScroll+ Traveler as /devices/pci0000:00/0000:0=
0:13.0/usb1/1-2/1-2:1.0/input/input1
[    6.448066] input,hidraw0: USB HID v1.10 Mouse [KYE NetScroll+ Traveler]=
 on usb-0000:00:13.0-2
[    6.448090] usbcore: registered new interface driver usbhid
[    6.448094] usbhid: v2.6:USB HID core driver
[   13.958683] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00=
/input/input2
[   13.967736] ACPI: Power Button (FF) [PWRF]
[   13.967925] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/P=
NP0C0C:00/input/input3
[   13.975270] ACPI: Power Button (CM) [PWRB]
[   13.978874] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-2=
9)
[   13.985771] uli526x 0000:00:12.0: PCI INT A -> GSI 20 (level, low) -> IR=
Q 20
[   14.040316] eth1: ULi M5263 at pci0000:00:12.0, 00:13:8f:b3:14:a4, irq 2=
0.
[   14.116119] ali15x3_smbus 0000:00:15.1: ALI15X3_smb region uninitialized=
 - upgrade BIOS or use force_addr=3D0xaddr
[   14.116125] ali15x3_smbus 0000:00:15.1: ALI15X3 not detected, module not=
 inserted.
[   14.119669] ali1535_smbus 0000:00:15.1: ALI1535_smb region uninitialized=
 - upgrade BIOS?
[   14.119673] ali1535_smbus 0000:00:15.1: ALI1535 not detected, module not=
 inserted.
[   14.141705] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[   14.141824] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   14.149286] parport_pc 00:06: reported by Plug and Play ACPI
[   14.149343] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRI=
STATE,COMPAT,ECP,DMA]
[   14.232336] 00:0c: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   14.366644] nvidia: module license 'NVIDIA' taints kernel.
[   14.399129] usblp0: USB Bidirectional printer dev 3 if 0 alt 0 proto 2 v=
id 0x03F0 pid 0x1904
[   14.399161] usbcore: registered new interface driver usblp
[   14.459044] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   14.712101] nvidia 0000:01:00.0: PCI INT A -> GSI 25 (level, low) -> IRQ=
 25
[   14.712109] nvidia 0000:01:00.0: setting latency timer to 64
[   14.712323] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  177.67  Mon =
Aug 11 12:04:28 PDT 2008
[   14.886166] udev: renamed network interface eth1 to eth0
[   14.931021] rt2500pci 0000:05:0a.0: PCI INT A -> GSI 18 (level, low) -> =
IRQ 18
[   14.935258] udev: renamed network interface eth0_rename to eth1
[   14.946997] phy0: Selected rate control algorithm 'pid'
[   15.340055] Registered led device: rt2500pci-phy0:radio
[   15.340106] HDA Intel 0000:00:14.0: PCI INT C -> GSI 22 (level, low) -> =
IRQ 22
[   15.349245] hda_codec: Unknown model for ALC883, trying auto-probe from =
BIOS...
[   16.577947] lp0: using parport0 (interrupt-driven).
[   16.594512] w83627ehf: Found W83627EHG chip at 0x290
[   16.726676] Adding 1992020k swap on /dev/sdb7.  Priority:1 extents:1 acr=
oss:1992020k
[   16.738255] Adding 1020116k swap on /dev/sdc2.  Priority:1 extents:1 acr=
oss:1020116k
[   19.115787] ip_tables: (C) 2000-2006 Netfilter Core Team
[   20.386888] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   20.388141] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Pl=
ase use
[   20.388145] nf_conntrack.acct=3D1 kernel paramater, acct=3D1 nf_conntrac=
k module option or
[   20.388147] sysctl net.netfilter.nf_conntrack_acct=3D1 to enable it.
[   21.675227] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processo=
r 3800+ processors (2 cpu cores) (version 2.20.00)
[   21.675858] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0xa
[   21.675862] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xc
[   21.675865] powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
[   23.709091] NET: Registered protocol family 10
[   23.710385] lo: Disabled Privacy Extensions
[   23.933841] warning: `avahi-daemon' uses 32-bit capabilities (legacy sup=
port in use)
[   26.000025] Clocksource tsc unstable (delta =3D -208039769 ns)
[   30.968234] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   30.991926] r8169: eth1: link down
[   30.991974] r8169: eth1: link down
[   30.993666] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   31.036163] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   31.103350] Bluetooth: Core ver 2.12
[   31.105980] NET: Registered protocol family 31
[   31.107044] Bluetooth: HCI device and connection manager initialized
[   31.108379] Bluetooth: HCI socket layer initialized
[   31.142564] Bluetooth: L2CAP ver 2.10
[   31.143526] Bluetooth: L2CAP socket layer initialized
[   31.156615] Bluetooth: RFCOMM socket layer initialized
[   31.156653] Bluetooth: RFCOMM TTY layer initialized
[   31.156658] Bluetooth: RFCOMM ver 1.10
[   33.328478] NET: Registered protocol family 17
[   33.966851] uli526x: eth0 NIC Link is Down
[  188.248690] wlan0: authenticate with AP 00:80:5a:31:90:db
[  188.250531] wlan0: authenticated
[  188.250919] wlan0: associate with AP 00:80:5a:31:90:db
[  188.254192] wlan0: RX AssocResp from 00:80:5a:31:90:db (capab=3D0x471 st=
atus=3D0 aid=3D2)
[  188.255053] wlan0: associated
[  188.256657] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  205.915260] wlan0: no IPv6 routers present
[20979.842035] INFO: task pdflush:198 blocked for more than 120 seconds.
[20979.842048] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[20979.842053] pdflush       D ffffffff8025b1b7     0   198      2
[20979.842065]  ffff8800be06dab0 0000000000000046 0000000000000000 00000010=
bdeff780
[20979.842074]  ffff880041c788c0 ffff8800be06da60 ffffffff805635c0 ffffffff=
805635c0
[20979.842081]  ffffffff8055d000 ffffffff8055d000 ffffffff805635c0 ffffffff=
805635c0
[20979.842088] Call Trace:
[20979.842102]  [<ffffffff80246f9e>] getnstimeofday+0x38/0x95
[20979.842111]  [<ffffffff8025b1b7>] sync_page+0x0/0x41
[20979.842119]  [<ffffffff80410ce4>] io_schedule+0x5d/0x9f
[20979.842126]  [<ffffffff8025b1f3>] sync_page+0x3c/0x41
[20979.842131]  [<ffffffff80410f4b>] __wait_on_bit+0x40/0x6e
[20979.842137]  [<ffffffff8025b405>] wait_on_page_bit+0x6c/0x72
[20979.842145]  [<ffffffff8024269e>] wake_bit_function+0x0/0x23
[20979.842152]  [<ffffffff802e49d4>] txLock+0x23d/0x5e5
[20979.842161]  [<ffffffff802faa9c>] attempt_merge+0x380/0x3c2
[20979.842168]  [<ffffffff802d482a>] diWrite+0x13a/0x43a
[20979.842175]  [<ffffffff802e2d7f>] txCommit+0x1cf/0xeb5
[20979.842182]  [<ffffffff802cbc6e>] jfs_commit_inode+0xa9/0xef
[20979.842189]  [<ffffffff802cbee4>] jfs_write_inode+0x31/0x41
[20979.842197]  [<ffffffff80299e89>] __writeback_single_inode+0x186/0x2a0
[20979.842207]  [<ffffffff8022770f>] pick_next_task_fair+0x90/0x9f
[20979.842213]  [<ffffffff8029a376>] generic_sync_sb_inodes+0x1cf/0x2d8
[20979.842221]  [<ffffffff8029a649>] writeback_inodes+0x5c/0xa8
[20979.842229]  [<ffffffff80261916>] wb_kupdate+0xa0/0x113
[20979.842236]  [<ffffffff80261cb2>] pdflush+0x0/0x204
[20979.842242]  [<ffffffff80261e05>] pdflush+0x153/0x204
[20979.842249]  [<ffffffff80261876>] wb_kupdate+0x0/0x113
[20979.842256]  [<ffffffff80242553>] kthread+0x47/0x74
[20979.842263]  [<ffffffff8022cc6f>] schedule_tail+0x28/0x61
[20979.842270]  [<ffffffff8020c2f9>] child_rip+0xa/0x11
[20979.842276]  [<ffffffff8024250c>] kthread+0x0/0x74
[20979.842281]  [<ffffffff8020c2ef>] child_rip+0x0/0x11
[20979.842284]=20
[20979.842333] INFO: task deluge:8943 blocked for more than 120 seconds.
[20979.842338] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[20979.842342] deluge        D ffff88003668d000     0  8943      1
[20979.842351]  ffff880051cc9898 0000000000000082 0000000000000200 ffff8800=
51cc9828
[20979.842358]  ffff8800bf844540 ffff880051cc9848 ffffffff805635c0 ffffffff=
805635c0
[20979.842366]  ffffffff8055d000 ffffffff8055d000 ffffffff805635c0 ffffffff=
805635c0
[20979.842372] Call Trace:
[20979.842380]  [<ffffffff80246f9e>] getnstimeofday+0x38/0x95
[20979.842386]  [<ffffffff80410ce4>] io_schedule+0x5d/0x9f
[20979.842392]  [<ffffffff802e1b55>] lmGroupCommit+0x113/0x15f
[20979.842399]  [<ffffffff8022a3ee>] default_wake_function+0x0/0xe
[20979.842406]  [<ffffffff802e38c0>] txCommit+0xd10/0xeb5
[20979.842413]  [<ffffffff80306711>] __up_read+0x13/0x8a
[20979.842420]  [<ffffffff802cbc6e>] jfs_commit_inode+0xa9/0xef
[20979.842427]  [<ffffffff802decd1>] extAlloc+0x374/0x3c1
[20979.842435]  [<ffffffff802cc13f>] jfs_get_block+0x162/0x22f
[20979.842442]  [<ffffffff802a0820>] nobh_write_begin+0x214/0x421
[20979.842449]  [<ffffffff802cbfdd>] jfs_get_block+0x0/0x22f
[20979.842455]  [<ffffffff802cbb80>] jfs_write_begin+0x1b/0x20
[20979.842462]  [<ffffffff802cbfdd>] jfs_get_block+0x0/0x22f
[20979.842467]  [<ffffffff8025bcc8>] generic_file_buffered_write+0x147/0x68=
6
[20979.842474]  [<ffffffff802e64a4>] jfs_getxattr+0xd/0x12
[20979.842482]  [<ffffffff80234fcd>] current_fs_time+0x1e/0x24
[20979.842489]  [<ffffffff8029a774>] __mark_inode_dirty+0xdf/0x187
[20979.842496]  [<ffffffff8025c6ef>] __generic_file_aio_write_nolock+0x342/=
0x376
[20979.842504]  [<ffffffff8025c787>] generic_file_aio_write+0x64/0xc4
[20979.842513]  [<ffffffff8027e982>] do_sync_write+0xd1/0x118
[20979.842520]  [<ffffffff80242670>] autoremove_wake_function+0x0/0x2e
[20979.842526]  [<ffffffff80410a2a>] thread_return+0x6a/0xbd
[20979.842535]  [<ffffffff8027f0fb>] vfs_write+0xad/0x143
[20979.842541]  [<ffffffff8027f5c0>] sys_write+0x45/0x6e
[20979.842549]  [<ffffffff8020b3db>] system_call_fastpath+0x16/0x1b
[20979.842553]=20
[21112.986033] INFO: task pdflush:198 blocked for more than 120 seconds.
[21112.986046] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[21112.986052] pdflush       D ffffffff8025b1b7     0   198      2
[21112.986063]  ffff8800be06dab0 0000000000000046 0000000000000000 00000010=
bdeff780
[21112.986072]  ffff880041c788c0 ffff8800be06da60 ffffffff805635c0 ffffffff=
805635c0
[21112.986082]  ffffffff8055d000 ffffffff8055d000 ffffffff805635c0 ffffffff=
805635c0
[21112.986092] Call Trace:
[21112.986107]  [<ffffffff80246f9e>] getnstimeofday+0x38/0x95
[21112.986116]  [<ffffffff8025b1b7>] sync_page+0x0/0x41
[21112.986125]  [<ffffffff80410ce4>] io_schedule+0x5d/0x9f
[21112.986132]  [<ffffffff8025b1f3>] sync_page+0x3c/0x41
[21112.986138]  [<ffffffff80410f4b>] __wait_on_bit+0x40/0x6e
[21112.986146]  [<ffffffff8025b405>] wait_on_page_bit+0x6c/0x72
[21112.986154]  [<ffffffff8024269e>] wake_bit_function+0x0/0x23
[21112.986162]  [<ffffffff802e49d4>] txLock+0x23d/0x5e5
[21112.986171]  [<ffffffff802faa9c>] attempt_merge+0x380/0x3c2
[21112.986179]  [<ffffffff802d482a>] diWrite+0x13a/0x43a
[21112.986186]  [<ffffffff802e2d7f>] txCommit+0x1cf/0xeb5
[21112.986194]  [<ffffffff802cbc6e>] jfs_commit_inode+0xa9/0xef
[21112.986201]  [<ffffffff802cbee4>] jfs_write_inode+0x31/0x41
[21112.986210]  [<ffffffff80299e89>] __writeback_single_inode+0x186/0x2a0
[21112.986220]  [<ffffffff8022770f>] pick_next_task_fair+0x90/0x9f
[21112.986228]  [<ffffffff8029a376>] generic_sync_sb_inodes+0x1cf/0x2d8
[21112.986236]  [<ffffffff8029a649>] writeback_inodes+0x5c/0xa8
[21112.986244]  [<ffffffff80261916>] wb_kupdate+0xa0/0x113
[21112.986252]  [<ffffffff80261cb2>] pdflush+0x0/0x204
[21112.986258]  [<ffffffff80261e05>] pdflush+0x153/0x204
[21112.986265]  [<ffffffff80261876>] wb_kupdate+0x0/0x113
[21112.986272]  [<ffffffff80242553>] kthread+0x47/0x74
[21112.986281]  [<ffffffff8022cc6f>] schedule_tail+0x28/0x61
[21112.986289]  [<ffffffff8020c2f9>] child_rip+0xa/0x11
[21112.986296]  [<ffffffff8024250c>] kthread+0x0/0x74
[21112.986303]  [<ffffffff8020c2ef>] child_rip+0x0/0x11
[21112.986307]=20
[21112.986355] INFO: task deluge:8943 blocked for more than 120 seconds.
[21112.986361] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[21112.986366] deluge        D ffff88003668d000     0  8943      1
[21112.986378]  ffff880051cc9898 0000000000000082 0000000000000200 ffff8800=
51cc9828
[21112.986390]  ffff8800bf844540 ffff880051cc9848 ffffffff805635c0 ffffffff=
805635c0
[21112.986402]  ffffffff8055d000 ffffffff8055d000 ffffffff805635c0 ffffffff=
805635c0
[21112.986413] Call Trace:
[21112.986421]  [<ffffffff80246f9e>] getnstimeofday+0x38/0x95
[21112.986428]  [<ffffffff80410ce4>] io_schedule+0x5d/0x9f
[21112.986435]  [<ffffffff802e1b55>] lmGroupCommit+0x113/0x15f
[21112.986443]  [<ffffffff8022a3ee>] default_wake_function+0x0/0xe
[21112.986450]  [<ffffffff802e38c0>] txCommit+0xd10/0xeb5
[21112.986459]  [<ffffffff80306711>] __up_read+0x13/0x8a
[21112.986467]  [<ffffffff802cbc6e>] jfs_commit_inode+0xa9/0xef
[21112.986475]  [<ffffffff802decd1>] extAlloc+0x374/0x3c1
[21112.986483]  [<ffffffff802cc13f>] jfs_get_block+0x162/0x22f
[21112.986491]  [<ffffffff802a0820>] nobh_write_begin+0x214/0x421
[21112.986498]  [<ffffffff802cbfdd>] jfs_get_block+0x0/0x22f
[21112.986506]  [<ffffffff802cbb80>] jfs_write_begin+0x1b/0x20
[21112.986513]  [<ffffffff802cbfdd>] jfs_get_block+0x0/0x22f
[21112.986521]  [<ffffffff8025bcc8>] generic_file_buffered_write+0x147/0x68=
6
[21112.986529]  [<ffffffff802e64a4>] jfs_getxattr+0xd/0x12
[21112.986537]  [<ffffffff80234fcd>] current_fs_time+0x1e/0x24
[21112.986545]  [<ffffffff8029a774>] __mark_inode_dirty+0xdf/0x187
[21112.986553]  [<ffffffff8025c6ef>] __generic_file_aio_write_nolock+0x342/=
0x376
[21112.986561]  [<ffffffff8025c787>] generic_file_aio_write+0x64/0xc4
[21112.986571]  [<ffffffff8027e982>] do_sync_write+0xd1/0x118
[21112.986579]  [<ffffffff80242670>] autoremove_wake_function+0x0/0x2e
[21112.986586]  [<ffffffff80410a2a>] thread_return+0x6a/0xbd
[21112.986595]  [<ffffffff8027f0fb>] vfs_write+0xad/0x143
[21112.986603]  [<ffffffff8027f5c0>] sys_write+0x45/0x6e
[21112.986611]  [<ffffffff8020b3db>] system_call_fastpath+0x16/0x1b
[21112.986616]=20
[21146.272045] INFO: task syslogd:3966 blocked for more than 120 seconds.
[21146.272057] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[21146.272063] syslogd       D ffffffff8029e5d9     0  3966      1
[21146.272074]  ffff8800bae43978 0000000000000082 ffff8800bfa3f400 ffffffff=
803006f0
[21146.272083]  ffff8800bd9deab0 ffff8800bae43928 ffffffff805635c0 ffffffff=
805635c0
[21146.272091]  ffffffff8055d000 ffffffff8055d000 ffffffff805635c0 ffffffff=
805635c0
[21146.272102] Call Trace:
[21146.272117]  [<ffffffff803006f0>] as_add_request+0xc4/0x100
[21146.272128]  [<ffffffff80246f9e>] getnstimeofday+0x38/0x95
[21146.272138]  [<ffffffff8029e5d9>] sync_buffer+0x0/0x3f
[21146.272147]  [<ffffffff80410ce4>] io_schedule+0x5d/0x9f
[21146.272155]  [<ffffffff8029e614>] sync_buffer+0x3b/0x3f
[21146.272162]  [<ffffffff80410f4b>] __wait_on_bit+0x40/0x6e
[21146.272170]  [<ffffffff8029e5d9>] sync_buffer+0x0/0x3f
[21146.272177]  [<ffffffff80410fe5>] out_of_line_wait_on_bit+0x6c/0x78
[21146.272185]  [<ffffffff8024269e>] wake_bit_function+0x0/0x23
[21146.272193]  [<ffffffff802a0982>] nobh_write_begin+0x376/0x421
[21146.272201]  [<ffffffff802cbfdd>] jfs_get_block+0x0/0x22f
[21146.272209]  [<ffffffff802cbb80>] jfs_write_begin+0x1b/0x20
[21146.272216]  [<ffffffff802cbfdd>] jfs_get_block+0x0/0x22f
[21146.272224]  [<ffffffff8025bcc8>] generic_file_buffered_write+0x147/0x68=
6
[21146.272233]  [<ffffffff802e64a4>] jfs_getxattr+0xd/0x12
[21146.272242]  [<ffffffff80234fcd>] current_fs_time+0x1e/0x24
[21146.272250]  [<ffffffff8029a774>] __mark_inode_dirty+0xdf/0x187
[21146.272258]  [<ffffffff8025c6ef>] __generic_file_aio_write_nolock+0x342/=
0x376
[21146.272264]  [<ffffffff8028e72b>] __d_lookup+0x110/0x122
[21146.272272]  [<ffffffff80285cb8>] do_lookup+0x63/0x1c1
[21146.272280]  [<ffffffff8025c787>] generic_file_aio_write+0x64/0xc4
[21146.272287]  [<ffffffff8025c723>] generic_file_aio_write+0x0/0xc4
[21146.272297]  [<ffffffff8027e868>] do_sync_readv_writev+0xc2/0x10b
[21146.272306]  [<ffffffff802932df>] mntput_no_expire+0x21/0x119
[21146.272314]  [<ffffffff80242670>] autoremove_wake_function+0x0/0x2e
[21146.272322]  [<ffffffff80286c9e>] getname+0x140/0x181
[21146.272330]  [<ffffffff802884de>] user_path_at+0x59/0x7f
[21146.272338]  [<ffffffff8027ef10>] do_readv_writev+0xb2/0x16f
[21146.272346]  [<ffffffff80281c14>] sys_newstat+0x28/0x31
[21146.272354]  [<ffffffff8027f3c7>] sys_writev+0x45/0x93
[21146.272362]  [<ffffffff8020b3db>] system_call_fastpath+0x16/0x1b
[21146.272367]=20
[21179.558077] INFO: task deluge:8940 blocked for more than 120 seconds.
[21179.558089] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[21179.558096] deluge        D 00000001013c6cd6     0  8940      1
[21179.558107]  ffff880095801b28 0000000000000082 0000000000000000 00000000=
00792c32
[21179.558115]  0000000300000000 ffff880095801ad8 ffffffff805635c0 ffffffff=
805635c0
[21179.558126]  ffffffff8055d000 ffffffff8055d000 ffffffff805635c0 ffffffff=
805635c0
[21179.558137] Call Trace:
[21179.558155]  [<ffffffff802df240>] release_metapage+0x124/0x130
[21179.558164]  [<ffffffff8025b1b7>] sync_page+0x0/0x41
[21179.558173]  [<ffffffff80410ce4>] io_schedule+0x5d/0x9f
[21179.558180]  [<ffffffff8025b1f3>] sync_page+0x3c/0x41
[21179.558187]  [<ffffffff80410f4b>] __wait_on_bit+0x40/0x6e
[21179.558194]  [<ffffffff8025b405>] wait_on_page_bit+0x6c/0x72
[21179.558202]  [<ffffffff8024269e>] wake_bit_function+0x0/0x23
[21179.558210]  [<ffffffff802e49d4>] txLock+0x23d/0x5e5
[21179.558218]  [<ffffffff802d95ff>] read_index_page+0x4b/0x55
[21179.558226]  [<ffffffff802ddfa6>] dtDelete+0x20a/0x8d4
[21179.558235]  [<ffffffff80285cb8>] do_lookup+0x63/0x1c1
[21179.558243]  [<ffffffff802857a2>] inode_permission+0x66/0xa9
[21179.558250]  [<ffffffff802e2b9e>] txBegin+0x2ac/0x2be
[21179.558257]  [<ffffffff80411e35>] __down_write_nested+0x34/0x9e
[21179.558264]  [<ffffffff802cc807>] jfs_unlink+0xbf/0x317
[21179.558271]  [<ffffffff8028654d>] vfs_unlink+0x5e/0xa3
[21179.558279]  [<ffffffff80288007>] do_unlinkat+0xa8/0x135
[21179.558288]  [<ffffffff8028a514>] sys_poll+0x35/0x86
[21179.558296]  [<ffffffff8020b3db>] system_call_fastpath+0x16/0x1b
[21179.558301]=20
[21212.844070] INFO: task gtk-window-deco:5253 blocked for more than 120 se=
conds.
[21212.844083] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[21212.844088] gtk-window-de D ffffffff8025b1b7     0  5253   5250
[21212.844099]  ffff8800a448bca8 0000000000000086 0000000000000000 ffff8800=
a448bd48
[21212.844108]  ffff88009cb0c080 ffff8800a448bc58 ffffffff805635c0 ffffffff=
805635c0
[21212.844119]  ffffffff8055d000 ffffffff8055d000 ffffffff805635c0 ffffffff=
805635c0
[21212.844129] Call Trace:
[21212.844144]  [<ffffffff802cbfdd>] jfs_get_block+0x0/0x22f
[21212.844154]  [<ffffffff80246f9e>] getnstimeofday+0x38/0x95
[21212.844162]  [<ffffffff8025b1b7>] sync_page+0x0/0x41
[21212.844171]  [<ffffffff80410ce4>] io_schedule+0x5d/0x9f
[21212.844178]  [<ffffffff8025b1f3>] sync_page+0x3c/0x41
[21212.844185]  [<ffffffff80410e60>] __wait_on_bit_lock+0x3f/0x72
[21212.844192]  [<ffffffff8025b1a3>] __lock_page+0x5e/0x64
[21212.844200]  [<ffffffff8024269e>] wake_bit_function+0x0/0x23
[21212.844207]  [<ffffffff8025b33c>] find_lock_page+0x30/0x50
[21212.844215]  [<ffffffff8025d29d>] filemap_fault+0x1a2/0x3a5
[21212.844224]  [<ffffffff802679c8>] __do_fault+0x54/0x387
[21212.844231]  [<ffffffff80269543>] handle_mm_fault+0x373/0x6dd
[21212.844238]  [<ffffffff80410a2a>] thread_return+0x6a/0xbd
[21212.844248]  [<ffffffff8022038c>] do_page_fault+0x381/0x741
[21212.844258]  [<ffffffff8027f24e>] vfs_read+0xbd/0x140
[21212.844265]  [<ffffffff80412659>] error_exit+0x0/0x51
[21212.844270]=20
[21246.130033] INFO: task pdflush:198 blocked for more than 120 seconds.
[21246.130046] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[21246.130052] pdflush       D ffffffff8025b1b7     0   198      2
[21246.130063]  ffff8800be06dab0 0000000000000046 0000000000000000 00000010=
bdeff780
[21246.130072]  ffff880041c788c0 ffff8800be06da60 ffffffff805635c0 ffffffff=
805635c0
[21246.130083]  ffffffff8055d000 ffffffff8055d000 ffffffff805635c0 ffffffff=
805635c0
[21246.130092] Call Trace:
[21246.130107]  [<ffffffff80246f9e>] getnstimeofday+0x38/0x95
[21246.130116]  [<ffffffff8025b1b7>] sync_page+0x0/0x41
[21246.130125]  [<ffffffff80410ce4>] io_schedule+0x5d/0x9f
[21246.130132]  [<ffffffff8025b1f3>] sync_page+0x3c/0x41
[21246.130139]  [<ffffffff80410f4b>] __wait_on_bit+0x40/0x6e
[21246.130146]  [<ffffffff8025b405>] wait_on_page_bit+0x6c/0x72
[21246.130154]  [<ffffffff8024269e>] wake_bit_function+0x0/0x23
[21246.130162]  [<ffffffff802e49d4>] txLock+0x23d/0x5e5
[21246.130171]  [<ffffffff802faa9c>] attempt_merge+0x380/0x3c2
[21246.130180]  [<ffffffff802d482a>] diWrite+0x13a/0x43a
[21246.130186]  [<ffffffff802e2d7f>] txCommit+0x1cf/0xeb5
[21246.130195]  [<ffffffff802cbc6e>] jfs_commit_inode+0xa9/0xef
[21246.130202]  [<ffffffff802cbee4>] jfs_write_inode+0x31/0x41
[21246.130211]  [<ffffffff80299e89>] __writeback_single_inode+0x186/0x2a0
[21246.130221]  [<ffffffff8022770f>] pick_next_task_fair+0x90/0x9f
[21246.130229]  [<ffffffff8029a376>] generic_sync_sb_inodes+0x1cf/0x2d8
[21246.130237]  [<ffffffff8029a649>] writeback_inodes+0x5c/0xa8
[21246.130245]  [<ffffffff80261916>] wb_kupdate+0xa0/0x113
[21246.130253]  [<ffffffff80261cb2>] pdflush+0x0/0x204
[21246.130259]  [<ffffffff80261e05>] pdflush+0x153/0x204
[21246.130266]  [<ffffffff80261876>] wb_kupdate+0x0/0x113
[21246.130273]  [<ffffffff80242553>] kthread+0x47/0x74
[21246.130282]  [<ffffffff8022cc6f>] schedule_tail+0x28/0x61
[21246.130291]  [<ffffffff8020c2f9>] child_rip+0xa/0x11
[21246.130298]  [<ffffffff8024250c>] kthread+0x0/0x74
[21246.130305]  [<ffffffff8020c2ef>] child_rip+0x0/0x11
[21246.130309]=20
[21246.130358] INFO: task deluge:8943 blocked for more than 120 seconds.
[21246.130364] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[21246.130369] deluge        D ffff88003668d000     0  8943      1
[21246.130380]  ffff880051cc9898 0000000000000082 0000000000000200 ffff8800=
51cc9828
[21246.130392]  ffff8800bf844540 ffff880051cc9848 ffffffff805635c0 ffffffff=
805635c0
[21246.130404]  ffffffff8055d000 ffffffff8055d000 ffffffff805635c0 ffffffff=
805635c0
[21246.130414] Call Trace:
[21246.130422]  [<ffffffff80246f9e>] getnstimeofday+0x38/0x95
[21246.130429]  [<ffffffff80410ce4>] io_schedule+0x5d/0x9f
[21246.130436]  [<ffffffff802e1b55>] lmGroupCommit+0x113/0x15f
[21246.130444]  [<ffffffff8022a3ee>] default_wake_function+0x0/0xe
[21246.130451]  [<ffffffff802e38c0>] txCommit+0xd10/0xeb5
[21246.130459]  [<ffffffff80306711>] __up_read+0x13/0x8a
[21246.130467]  [<ffffffff802cbc6e>] jfs_commit_inode+0xa9/0xef
[21246.130475]  [<ffffffff802decd1>] extAlloc+0x374/0x3c1
[21246.130483]  [<ffffffff802cc13f>] jfs_get_block+0x162/0x22f
[21246.130491]  [<ffffffff802a0820>] nobh_write_begin+0x214/0x421
[21246.130498]  [<ffffffff802cbfdd>] jfs_get_block+0x0/0x22f
[21246.130506]  [<ffffffff802cbb80>] jfs_write_begin+0x1b/0x20
[21246.130513]  [<ffffffff802cbfdd>] jfs_get_block+0x0/0x22f
[21246.130520]  [<ffffffff8025bcc8>] generic_file_buffered_write+0x147/0x68=
6
[21246.130527]  [<ffffffff802e64a4>] jfs_getxattr+0xd/0x12
[21246.130536]  [<ffffffff80234fcd>] current_fs_time+0x1e/0x24
[21246.130544]  [<ffffffff8029a774>] __mark_inode_dirty+0xdf/0x187
[21246.130551]  [<ffffffff8025c6ef>] __generic_file_aio_write_nolock+0x342/=
0x376
[21246.130559]  [<ffffffff8025c787>] generic_file_aio_write+0x64/0xc4
[21246.130569]  [<ffffffff8027e982>] do_sync_write+0xd1/0x118
[21246.130577]  [<ffffffff80242670>] autoremove_wake_function+0x0/0x2e
[21246.130584]  [<ffffffff80410a2a>] thread_return+0x6a/0xbd
[21246.130592]  [<ffffffff8027f0fb>] vfs_write+0xad/0x143
[21246.130601]  [<ffffffff8027f5c0>] sys_write+0x45/0x6e
[21246.130608]  [<ffffffff8020b3db>] system_call_fastpath+0x16/0x1b
[21246.130613]=20

--=20
OOP to me means only messaging, local retention and protection and
hiding of state-process, and extreme late-binding of all things. It can
be done in Smalltalk and in LISP. There are possibly other systems in
which this is possible, but I'm not aware of them.
                                                      -- Alan Kay --

--=-ZEpVGlq8ESsbL1/TKvEG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Esta parte del mensaje =?ISO-8859-1?Q?est=E1?= firmada
	digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEABECAAYFAkjEKcAACgkQ3GEkiSnUSOHaWACeKzSAwkhxorFUPc0lYH9bWgEB
Q2sAnR35p+Kds4TcCv7/pjyyH7JaiJeg
=zM3l
-----END PGP SIGNATURE-----

--=-ZEpVGlq8ESsbL1/TKvEG--

