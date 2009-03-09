Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbZCIQdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbZCIQdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 12:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZCIQdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 12:33:14 -0400
Received: from mail.x-privat.org ([194.177.97.109]:2667 "EHLO
	mail.x-privat.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbZCIQdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:33:04 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2009 12:32:58 EDT
Message-ID: <49B54125.6090300@fr3ddie.it>
Date: Mon, 09 Mar 2009 17:17:41 +0100
From: Fr3ddie <fr3ddie@fr3ddie.it>
Reply-To: fr3ddie@fr3ddie.it
Organization: http://www.fr3ddie.it
User-Agent: Fr3ddie's Thunderbird on Linux
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Kernel HANGED (don't know if a kernel panic)
X-Priority: 1 (Highest)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ArGoMail-Authenticated: fr3ddie@x-privat.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wasn't there.... but it seems the kernel hanged (I think it not
paniced) and it needed a hard-reboot (via Magic SYS-RQ), here's the
informations I can catch (sorry if are incomplete, I'm not a Linux
hacker, but I try :) )

[1.] One line summary of the problem:
Kernel hanged, needed hard-reboot

[2.] Full description of the problem/report:
Don't know what to say

[3.] Keywords (i.e., modules, networking, kernel):
Standard Ubuntu-server Kernel from updated Hardy (Ubuntu v8.04.2)

[4.] Kernel version (from /proc/version):
Linux version 2.6.24-23-server (buildd@vernadsky) (gcc version 4.2.3
(Ubuntu 4.2.3-2ubuntu7)) #1 SMP Mon Jan 26 00:55:21 UTC 2009

[5.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)
No Oops

[6.] A small shell script or example program which triggers the
     problem (if possible)
No, I'm not able to :)

[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)
<user>@<server>$ sudo sh ver_linux
[sudo] password for root:
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux Aula2Server 2.6.24-23-server #1 SMP Mon Jan 26 00:55:21 UTC 2009
i686 GNU/Linux

Gnu C                  4.2.4
Gnu make               3.81
binutils               2.18.0.20080103
util-linux             2.13.1
mount                  2.13.1
module-init-tools      3.3-pre11
e2fsprogs              1.40.8
jfsutils               1.1.11
reiserfsprogs          3.6.19
reiser4progs           1.0.6
xfsprogs               2.9.4
pcmciautils            014
PPP                    2.4.4
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Net-tools              1.60
Kbd                    [opzione...]
Console-tools          0.2.3
Sh-utils               6.10
udev                   117
wireless-tools         29
Modules Loaded         xt_multiport video output sbs sbshc container
dock battery w83627ehf hwmon_vid iptable_filter ip_tables x_tables ext3
jbd mbcache ac lp loop ipv6 sn9c102 compat_ioctl32 gspca videodev
snd_hda_intel v4l2_common v4l1_compat snd_hwdep snd_pcm_oss snd_pcm
snd_page_alloc snd_mixer_oss sky2 snd_seq_dummy snd_seq_oss psmouse
snd_seq_midi serio_raw snd_rawmidi snd_seq_midi_event snd_seq snd_timer
intel_agp snd_seq_device agpgart button parport_pc shpchp pci_hotplug
evdev pcspkr parport snd soundcore jfs sr_mod cdrom pata_acpi usbhid hid
usb_storage libusual sg sd_mod ata_piix floppy ahci ata_generic
pata_it821x libata ehci_hcd scsi_mod uhci_hcd usbcore raid10 raid456
async_xor async_memcpy async_tx xor raid1 raid0 multipath linear md_mod
thermal processor fan fuse vesafb fbcon tileblit font bitblit softcursor

[7.2.] Processor information (from /proc/cpuinfo):
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	: Intel(R) Pentium(R) D CPU 3.40GHz
stepping	: 5
cpu MHz		: 3412.175
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm
constant_tsc pebs bts pni monitor ds_cpl est cid cx16 xtpr lahf_lm
bogomips	: 6829.07
clflush size	: 64

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	: Intel(R) Pentium(R) D CPU 3.40GHz
stepping	: 5
cpu MHz		: 3412.175
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm
constant_tsc pebs bts pni monitor ds_cpl est cid cx16 xtpr lahf_lm
bogomips	: 6824.41
clflush size	: 64

[7.3.] Module information (from /proc/modules):
xt_multiport 4224 5 - Live 0xf9224000
video 19856 0 - Live 0xf92cc000
output 4736 1 video, Live 0xf9221000
sbs 15112 0 - Live 0xf92bf000
sbshc 7680 1 sbs, Live 0xf91be000
container 5632 0 - Live 0xf91e0000
dock 11280 0 - Live 0xf91c4000
battery 14212 0 - Live 0xf921c000
w83627ehf 22020 0 - Live 0xf91f3000
hwmon_vid 4352 1 w83627ehf, Live 0xf91c1000
iptable_filter 3840 1 - Live 0xf887c000
ip_tables 14820 1 iptable_filter, Live 0xf91db000
x_tables 16132 2 xt_multiport,ip_tables, Live 0xf91d6000
ext3 136584 2 - Live 0xf93de000
jbd 48404 1 ext3, Live 0xf91e6000
mbcache 9600 1 ext3, Live 0xf9184000
ac 6916 0 - Live 0xf9188000
lp 12324 0 - Live 0xf91b9000
loop 19076 0 - Live 0xf9191000
ipv6 272932 24 - Live 0xf9372000
sn9c102 127236 0 - Live 0xf91fb000
compat_ioctl32 2304 1 sn9c102, Live 0xf8bd6000
gspca 643280 1 - Live 0xf92d3000
videodev 29312 3 sn9c102,gspca, Live 0xf91cd000
snd_hda_intel 346008 0 - Live 0xf9229000
v4l2_common 18304 2 sn9c102,videodev, Live 0xf918b000
v4l1_compat 15492 1 videodev, Live 0xf9163000
snd_hwdep 10500 1 snd_hda_intel, Live 0xf9180000
snd_pcm_oss 42016 0 - Live 0xf91ad000
snd_pcm 78596 2 snd_hda_intel,snd_pcm_oss, Live 0xf9198000
snd_page_alloc 11528 2 snd_hda_intel,snd_pcm, Live 0xf8859000
snd_mixer_oss 17792 1 snd_pcm_oss, Live 0xf916d000
sky2 48260 0 - Live 0xf9173000
snd_seq_dummy 4868 0 - Live 0xf9160000
snd_seq_oss 35456 0 - Live 0xf9147000
psmouse 40208 0 - Live 0xf9119000
snd_seq_midi 9248 0 - Live 0xf8bd2000
serio_raw 7940 0 - Live 0xf8bb6000
snd_rawmidi 25632 1 snd_seq_midi, Live 0xf913f000
snd_seq_midi_event 8320 2 snd_seq_oss,snd_seq_midi, Live 0xf8bf1000
snd_seq 54096 6
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, Live 0xf9151000
snd_timer 24836 2 snd_pcm,snd_seq, Live 0xf9137000
intel_agp 25620 0 - Live 0xf912f000
snd_seq_device 9612 5
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq, Live 0xf8bed000
agpgart 34760 1 intel_agp, Live 0xf9125000
button 9232 0 - Live 0xf8be9000
parport_pc 36644 1 - Live 0xf910f000
shpchp 34452 0 - Live 0xf9105000
pci_hotplug 30880 1 shpchp, Live 0xf8c10000
evdev 12928 3 - Live 0xf8be4000
pcspkr 4224 0 - Live 0xf8baa000
parport 37704 2 lp,parport_pc, Live 0xf8c05000
snd 56868 11
snd_hda_intel,snd_hwdep,snd_pcm_oss,snd_pcm,snd_mixer_oss,snd_seq_dummy,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device,
Live 0xf8bf6000
soundcore 8800 1 snd, Live 0xf8ba6000
jfs 188772 2 - Live 0xf8c1b000
sr_mod 17828 0 - Live 0xf8bcc000
cdrom 37280 1 sr_mod, Live 0xf8bd9000
pata_acpi 8320 0 - Live 0xf8ba2000
usbhid 32384 0 - Live 0xf8bad000
hid 38784 1 usbhid, Live 0xf8b69000
usb_storage 73536 1 - Live 0xf8bb9000
libusual 19108 1 usb_storage, Live 0xf8b9c000
sg 36496 0 - Live 0xf8b45000
sd_mod 30720 12 - Live 0xf8b50000
ata_piix 19588 0 - Live 0xf8b1a000
floppy 59332 0 - Live 0xf8b59000
ahci 28548 4 - Live 0xf8acb000
ata_generic 8324 0 - Live 0xf8a8e000
pata_it821x 12292 4 - Live 0xf8a93000
libata 159600 5 pata_acpi,ata_piix,ahci,ata_generic,pata_it821x, Live
0xf8b74000
ehci_hcd 38412 0 - Live 0xf8ac0000
scsi_mod 151180 5 sr_mod,usb_storage,sg,sd_mod,libata, Live 0xf8af4000
uhci_hcd 27152 0 - Live 0xf8ab8000
usbcore 146284 8
sn9c102,gspca,usbhid,usb_storage,libusual,ehci_hcd,uhci_hcd, Live 0xf8b20000
raid10 25856 0 - Live 0xf8ab0000
raid456 129040 0 - Live 0xf8ad3000
async_xor 4992 1 raid456, Live 0xf8877000
async_memcpy 3840 1 raid456, Live 0xf8875000
async_tx 9292 3 raid456,async_xor,async_memcpy, Live 0xf884d000
xor 16136 2 raid456,async_xor, Live 0xf8a89000
raid1 25728 4 - Live 0xf8a81000
raid0 9344 0 - Live 0xf8855000
multipath 9600 0 - Live 0xf8851000
linear 7296 0 - Live 0xf8835000
md_mod 81940 10 raid10,raid456,raid1,raid0,multipath,linear, Live 0xf8a9a000
thermal 16796 0 - Live 0xf883b000
processor 36616 1 thermal, Live 0xf886b000
fan 5636 0 - Live 0xf8838000
fuse 50580 1 - Live 0xf885d000
vesafb 8964 1 - Live 0xf882b000
fbcon 42656 127 - Live 0xf8841000
tileblit 3456 1 fbcon, Live 0xf8833000
font 9472 1 fbcon, Live 0xf882f000
bitblit 6784 1 fbcon, Live 0xf8826000
softcursor 3072 1 bitblit, Live 0xf8829000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
####### /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.1
  0170-0177 : libata
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : libata
0290-0297 : pnp 00:08
  0295-0296 : w83627ehf
    0295-0296 : w83627ehf
0376-0376 : 0000:00:1f.1
  0376-0376 : libata
0378-037a : parport0
03c0-03df : vesafb
03f2-03f5 : floppy
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : libata
03f7-03f7 : floppy DIR
03f8-03ff : serial
0400-041f : 0000:00:1f.3
0480-04bf : pnp 00:09
04d0-04d1 : pnp 00:09
0800-087f : pnp 00:09
  0800-0803 : ACPI PM1a_EVT_BLK
  0804-0805 : ACPI PM1a_CNT_BLK
  0808-080b : ACPI PM_TMR
  0810-0815 : ACPI CPU throttle
  0820-0820 : ACPI PM2_CNT_BLK
  0828-082f : ACPI GPE0_BLK
0900-090f : pnp 00:09
0cf8-0cff : PCI conf1
7000-701f : 0000:00:1d.0
  7000-701f : uhci_hcd
7400-741f : 0000:00:1d.1
  7400-741f : uhci_hcd
7800-781f : 0000:00:1d.2
  7800-781f : uhci_hcd
8000-801f : 0000:00:1d.3
  8000-801f : uhci_hcd
8400-840f : 0000:00:1f.2
8800-8803 : 0000:00:1f.2
9000-9007 : 0000:00:1f.2
9400-9403 : 0000:00:1f.2
9800-9807 : 0000:00:1f.2
a000-cfff : PCI Bus #01
  a000-a0ff : 0000:01:01.0
  b400-b40f : 0000:01:03.0
    b400-b40f : libata
  b800-b803 : 0000:01:03.0
    b800-b803 : libata
  c000-c007 : 0000:01:03.0
    c000-c007 : libata
  c400-c403 : 0000:01:03.0
    c400-c403 : libata
  c800-c807 : 0000:01:03.0
    c800-c807 : libata
d000-dfff : PCI Bus #02
  d800-d8ff : 0000:02:00.0
    d800-d8ff : sky2
e000-efff : PCI Bus #03
ffa0-ffaf : 0000:00:1f.1
  ffa0-ffaf : libata

####### /proc/iomem
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000f0000-000fffff : System ROM
00100000-7ff9ffff : System RAM
  00100000-003349d8 : Kernel code
  003349d9-00437fe3 : Kernel data
  0049e000-005174af : Kernel bss
7ffa0000-7ffadfff : ACPI Tables
7ffae000-7ffdffff : ACPI Non-volatile Storage
7ffe0000-7fffffff : reserved
ddff8000-ddffbfff : 0000:00:1b.0
  ddff8000-ddffbfff : ICH HD audio
ddfff800-ddfffbff : 0000:00:1d.7
  ddfff800-ddfffbff : ehci_hcd
ddfffc00-ddffffff : 0000:00:1f.2
  ddfffc00-ddffffff : ahci
de000000-dfefffff : PCI Bus #01
  de000000-deffffff : 0000:01:01.0
    de000000-de1fffff : vesafb
  df000000-df01ffff : 0000:01:03.0
  df020000-df02ffff : 0000:01:01.0
dff00000-dfffffff : PCI Bus #02
  dffc0000-dffdffff : 0000:02:00.0
  dfffc000-dfffffff : 0000:02:00.0
    dfffc000-dfffffff : sky2
f0000000-f3ffffff : pnp 00:0e
fec00000-fec00fff : pnp 00:0c
fed13000-fed19fff : pnp 00:01
fed1c000-fed1ffff : pnp 00:09
fed20000-fed8ffff : pnp 00:09
fee00000-fee00fff : pnp 00:0c
ffb80000-ffffffff : reserved

[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: Intel Corporation 82945G/GZ/P/PL Memory Controller
Hub (rev 81)
	Subsystem: Intel Corporation Unknown device 2580
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort+ >SERR- <PERR-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 01)
	Subsystem: ASUSTeK Computer Inc. Unknown device 817f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 16 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at ddff8000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express Unknown type IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed unknown, Width x0, ASPM unknown, Port 0
		Link: Latency L0s <64ns, L1 <1us
		Link: ASPM Disabled CommClk- ExtSynch-
		Link: Speed unknown, Width x0

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 1 (rev 01) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 16 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1
		Link: Latency L0s <256ns, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x0
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 1, PowerLimit 10.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
Enable+
		Address: fee0300c  Data: 41b9
	Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Unknown device 8179
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 4 (rev 01) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 16 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: dff00000-dfffffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot-) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 4
		Link: Latency L0s <256ns, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x1
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
Enable+
		Address: fee0300c  Data: 41c1
	Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Unknown device 8179
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
Controller #1 (rev 01) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device 8179
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 18
	Region 4: I/O ports at 7000 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
Controller #2 (rev 01) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device 8179
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at 7400 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
Controller #3 (rev 01) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device 8179
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 20
	Region 4: I/O ports at 7800 [size=32]

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
Controller #4 (rev 01) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device 8179
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin D routed to IRQ 17
	Region 4: I/O ports at 8000 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI
Controller (rev 01) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device 8179
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at ddfff800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1) (prog-if
01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000a000-0000cfff
	Memory behind bridge: de000000-dfefffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
	Capabilities: [50] Subsystem: ASUSTeK Computer Inc. Unknown device 8179

00:1f.0 ISA bridge: Intel Corporation 82801GH (ICH7DH) LPC Interface
Bridge (rev 01)
	Subsystem: ASUSTeK Computer Inc. Unknown device 8179
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 01) (prog-if 8a [Master SecP PriP])
	Subsystem: ASUSTeK Computer Inc. Unknown device 8179
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 22
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at ffa0 [size=16]

00:1f.2 SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) SATA
AHCI Controller (rev 01) (prog-if 01 [AHCI 1.0])
	Subsystem: ASUSTeK Computer Inc. Unknown device 2606
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 221
	Region 0: I/O ports at 9800 [size=8]
	Region 1: I/O ports at 9400 [size=4]
	Region 2: I/O ports at 9000 [size=8]
	Region 3: I/O ports at 8800 [size=4]
	Region 4: I/O ports at 8400 [size=16]
	Region 5: Memory at ddfffc00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
Enable+
		Address: fee0300c  Data: 41e9
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller
(rev 01)
	Subsystem: ASUSTeK Computer Inc. Unknown device 8179
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 11
	Region 4: I/O ports at 0400 [size=32]

01:01.0 VGA compatible controller: ATI Technologies Inc 264VT [Mach64
VT] (rev 48) (prog-if 00 [VGA controller])
	Subsystem: ATI Technologies Inc Mach64VT Reference
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop+ ParErr-
Stepping+ SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Region 0: Memory at de000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: I/O ports at a000 [size=256]
	Expansion ROM at df020000 [disabled] [size=64K]

01:03.0 Mass storage controller: Integrated Technology Express, Inc. ITE
8211F Single Channel UDMA 133 (rev 11)
	Subsystem: ASUSTeK Computer Inc. P5GD1-VW Mainboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (2000ns min, 2000ns max)
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at c800 [size=8]
	Region 1: I/O ports at c400 [size=4]
	Region 2: I/O ports at c000 [size=8]
	Region 3: I/O ports at b800 [size=4]
	Region 4: I/O ports at b400 [size=16]
	Expansion ROM at df000000 [disabled] [size=128K]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E
Gigabit Ethernet Controller (rev 19)
	Subsystem: ASUSTeK Computer Inc. Marvell 88E8053 Gigabit Ethernet
controller PCIe (Asus)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 16 bytes
	Interrupt: pin A routed to IRQ 220
	Region 0: Memory at dfffc000 (64-bit, non-prefetchable) [size=16K]
	Region 2: I/O ports at d800 [size=256]
	Expansion ROM at dffc0000 [disabled] [size=128K]
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data
	Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1
Enable+
		Address: 00000000fee0300c  Data: 413a
	Capabilities: [e0] Express Legacy Endpoint IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0
		Link: Latency L0s <256ns, L1 unlimited
		Link: ASPM Disabled RCB 128 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x1

[7.6.] SCSI information (from /proc/scsi/scsi)
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: MAXTOR STM316021 Rev: 3.AA
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Hitachi HDS72161 Rev: P22O
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: DVD-ROM GDR8161B Rev: 0100
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 00
  Vendor:          Model: USB Flash Memory Rev: 1.04
  Type:   Direct-Access                    ANSI  SCSI revision: 00

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
Here's the log pages, sent me by logcheck, that I think could be relevant:

Mar  9 03:00:59 Aula2Server kernel: [117722.497458] Eeek!
page_mapcount(page) went negative! (-1)
Mar  9 03:00:59 Aula2Server kernel: [117722.497814]   page pfn = 44700
Mar  9 03:00:59 Aula2Server kernel: [117722.498014]   page->flags = 80000060
Mar  9 03:00:59 Aula2Server kernel: [117722.498250]   page->count = 1
Mar  9 03:00:59 Aula2Server kernel: [117722.498442]   page->mapping =
f4c0c681
Mar  9 03:00:59 Aula2Server kernel: [117722.498706]   vma->vm_ops = 0x0
Mar  9 03:00:59 Aula2Server kernel: [117722.498940] ------------[ cut
here ]------------
Mar  9 03:00:59 Aula2Server kernel: [117722.499243] kernel BUG at
/build/buildd/linux-2.6.24/mm/rmap.c:631!
Mar  9 03:00:59 Aula2Server kernel: [117722.499666] invalid opcode: 0000
[#1] SMP
Mar  9 03:00:59 Aula2Server kernel: [117722.499940] Modules linked in:
xt_multiport video output sbs sbshc container dock battery w83627ehf
hwmon_vid iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop
ipv6 sn9c102 compat_ioctl32 gspca videodev v4l2_common v4l1_compat
snd_hda_intel snd_hwdep snd_pcm_oss snd_pcm snd_page_alloc snd_mixer_oss
sky2 snd_seq_dummy snd_seq_oss psmouse snd_seq_midi serio_raw
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device shpchp
button evdev pci_hotplug snd pcspkr parport_pc parport soundcore
intel_agp agpgart jfs sr_mod cdrom pata_acpi ata_piix usbhid hid
usb_storage libusual sg sd_mod ahci ata_generic pata_it821x libata
floppy scsi_mod ehci_hcd uhci_hcd usbcore raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
processor fan fuse vesafb fbcon tileblit font bitblit softcursor
Mar  9 03:00:59 Aula2Server kernel: [117722.505128]
Mar  9 03:00:59 Aula2Server kernel: [117722.505224] Pid: 29294, comm:
hadcm3trans_um_ Not tainted (2.6.24-23-server #1)
Mar  9 03:00:59 Aula2Server kernel: [117722.505693] EIP:
0060:[page_remove_rmap+0xf9/0x110] EFLAGS: 00010246 CPU: 0
Mar  9 03:00:59 Aula2Server kernel: [117722.506049] EIP is at
page_remove_rmap+0xf9/0x110
Mar  9 03:00:59 Aula2Server kernel: [117722.506351] EAX: 00000000 EBX:
c188e000 ECX: 00000092 EDX: 00000000
Mar  9 03:00:59 Aula2Server kernel: [117722.506752] ESI: f508dd68 EDI:
c188e000 EBP: 00100100 ESP: f3807da0
Mar  9 03:00:59 Aula2Server kernel: [117722.507155]  DS: 007b ES: 007b
FS: 00d8 GS: 0000 SS: 0068
Mar  9 03:00:59 Aula2Server kernel: [117722.507502] Process
hadcm3trans_um_ (pid: 29294, ti=f3806000 task=f39565c0 task.ti=f3806000)
Mar  9 03:00:59 Aula2Server kernel: [117722.508042] Stack: c03ccd53
f4c0c681 fffb3140 44700067 c0181afc 44700067 00000000 c1fa3f8c
Mar  9 03:00:59 Aula2Server kernel: [117722.508621]        c04992a0
c200f2b0 00000000 f508dd68 f3807e4c 00000000 00000000 44700067
Mar  9 03:00:59 Aula2Server kernel: [117722.509199]        00000000
00000001 00229000 00000000 bfc78000 f402c010 f4124f70 f44a21c0
Mar  9 03:00:59 Aula2Server kernel: [117722.509778] Call Trace:
Mar  9 03:00:59 Aula2Server kernel: [117722.509949]
[unmap_vmas+0x46c/0x740] unmap_vmas+0x46c/0x740
Mar  9 03:00:59 Aula2Server kernel: [117722.510320]
[exit_mmap+0x79/0xf0] exit_mmap+0x79/0xf0
Mar  9 03:00:59 Aula2Server kernel: [117722.510623]  [mmput+0x1e/0x80]
mmput+0x1e/0x80
Mar  9 03:00:59 Aula2Server kernel: [117722.510889]
[do_exit+0x165/0x860] do_exit+0x165/0x860
Mar  9 03:00:59 Aula2Server kernel: [117722.511189]
[recalc_sigpending+0xb/0x40] recalc_sigpending+0xb/0x40
Mar  9 03:00:59 Aula2Server kernel: [117722.511515]
[dequeue_signal+0x6b/0x150] dequeue_signal+0x6b/0x150
Mar  9 03:00:59 Aula2Server kernel: [117722.511844]
[do_group_exit+0x26/0x80] do_group_exit+0x26/0x80
Mar  9 03:00:59 Aula2Server kernel: [117722.512157]
[get_signal_to_deliver+0x2c7/0x4c0] get_signal_to_deliver+0x2c7/0x4c0
Mar  9 03:00:59 Aula2Server kernel: [117722.512484]
[finish_task_switch+0x70/0x90] finish_task_switch+0x70/0x90
Mar  9 03:00:59 Aula2Server kernel: [117722.512793]
[do_notify_resume+0x93/0x720] do_notify_resume+0x93/0x720
Mar  9 03:00:59 Aula2Server kernel: [117722.513096]
[__remove_hrtimer+0x4f/0x80] __remove_hrtimer+0x4f/0x80
Mar  9 03:00:59 Aula2Server kernel: [117722.513387]
[hrtimer_try_to_cancel+0x3c/0x80] hrtimer_try_to_cancel+0x3c/0x80
Mar  9 03:00:59 Aula2Server kernel: [117722.513746]
[hrtimer_cancel+0xe/0x20] hrtimer_cancel+0xe/0x20
Mar  9 03:00:59 Aula2Server kernel: [117722.514054]
[do_nanosleep+0x59/0x70] do_nanosleep+0x59/0x70
Mar  9 03:00:59 Aula2Server kernel: [117722.514364]
[hrtimer_nanosleep+0x5c/0xd0] hrtimer_nanosleep+0x5c/0xd0
Mar  9 03:00:59 Aula2Server kernel: [117722.514707]
[hrtimer_wakeup+0x0/0x20] hrtimer_wakeup+0x0/0x20
Mar  9 03:00:59 Aula2Server kernel: [117722.515045]
[sys_nanosleep+0x58/0x60] sys_nanosleep+0x58/0x60
Mar  9 03:00:59 Aula2Server kernel: [117722.515363]
[work_notifysig+0x13/0x19] work_notifysig+0x13/0x19
Mar  9 03:00:59 Aula2Server kernel: [117722.515711]  =======================
Mar  9 03:00:59 Aula2Server kernel: [117722.515939] Code: 8b 46 44 8b 50
08 b8 83 cd 3c c0 e8 82 e9 fc ff 8b 46 4c 85 c0 74 14 8b 40 10 85 c0 74
0d 8b 50 2c b8 74 bc 3c c0 e8 67 e9 fc ff <0f> 0b eb fe 8b 53 0c eb 85
8d b4 26 00 00 00 00 8d bc 27 00 00
Mar  9 03:00:59 Aula2Server kernel: [117722.517495] EIP:
[page_remove_rmap+0xf9/0x110] page_remove_rmap+0xf9/0x110 SS:ESP
0068:f3807da0
Mar  9 03:00:59 Aula2Server kernel: [117722.576235] ---[ end trace
1b2cab846758a6ac ]---
Mar  9 03:00:59 Aula2Server kernel: [117722.576540] Fixing recursive
fault but reboot is needed!
Mar  9 03:00:59 Aula2Server kernel: [117722.576890] BUG: scheduling
while atomic: hadcm3trans_um_/29294/0x00000001
Mar  9 03:00:59 Aula2Server kernel: [117722.597227] Pid: 29294, comm:
hadcm3trans_um_ Tainted: G      D 2.6.24-23-server #1
Mar  9 03:00:59 Aula2Server kernel: [117722.619395]
[jbd:schedule+0x582/0x6b0] schedule+0x582/0x630
Mar  9 03:00:59 Aula2Server kernel: [117722.639702]
[do_exit+0x750/0x860] do_exit+0x750/0x860
Mar  9 03:00:59 Aula2Server kernel: [117722.662075]
[snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
Mar  9 03:00:59 Aula2Server kernel: [117722.682283]  [die+0x277/0x280]
die+0x277/0x280
Mar  9 03:00:59 Aula2Server kernel: [117722.702388]
[do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
Mar  9 03:00:59 Aula2Server kernel: [117722.724478]
[do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
Mar  9 03:00:59 Aula2Server kernel: [117722.744549]
[page_remove_rmap+0xf9/0x110] page_remove_rmap+0xf9/0x110
Mar  9 03:00:59 Aula2Server kernel: [117722.766710]
[snd_hwdep:__wake_up+0x3e/0x1f10] __wake_up+0x3e/0x60
Mar  9 03:00:59 Aula2Server kernel: [117722.786542]
[wake_up_klogd+0x3b/0x40] wake_up_klogd+0x3b/0x40
Mar  9 03:00:59 Aula2Server kernel: [117722.807980]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:00:59 Aula2Server kernel: [117722.827340]
[page_remove_rmap+0xf9/0x110] page_remove_rmap+0xf9/0x110
Mar  9 03:00:59 Aula2Server kernel: [117722.848661]
[unmap_vmas+0x46c/0x740] unmap_vmas+0x46c/0x740
Mar  9 03:00:59 Aula2Server kernel: [117722.868105]
[exit_mmap+0x79/0xf0] exit_mmap+0x79/0xf0
Mar  9 03:00:59 Aula2Server kernel: [117722.887337]  [mmput+0x1e/0x80]
mmput+0x1e/0x80
Mar  9 03:00:59 Aula2Server kernel: [117722.908603]
[do_exit+0x165/0x860] do_exit+0x165/0x860
Mar  9 03:00:59 Aula2Server kernel: [117722.928016]
[recalc_sigpending+0xb/0x40] recalc_sigpending+0xb/0x40
Mar  9 03:00:59 Aula2Server kernel: [117722.949648]
[dequeue_signal+0x6b/0x150] dequeue_signal+0x6b/0x150
Mar  9 03:00:59 Aula2Server kernel: [117722.969151]
[do_group_exit+0x26/0x80] do_group_exit+0x26/0x80
Mar  9 03:00:59 Aula2Server kernel: [117722.988429]
[get_signal_to_deliver+0x2c7/0x4c0] get_signal_to_deliver+0x2c7/0x4c0
Mar  9 03:00:59 Aula2Server kernel: [117723.009712]
[finish_task_switch+0x70/0x90] finish_task_switch+0x70/0x90
Mar  9 03:00:59 Aula2Server kernel: [117723.030677]
[do_notify_resume+0x93/0x720] do_notify_resume+0x93/0x720
Mar  9 03:00:59 Aula2Server kernel: [117723.048891]
[__remove_hrtimer+0x4f/0x80] __remove_hrtimer+0x4f/0x80
Mar  9 03:00:59 Aula2Server kernel: [117723.066359]
[hrtimer_try_to_cancel+0x3c/0x80] hrtimer_try_to_cancel+0x3c/0x80
Mar  9 03:00:59 Aula2Server kernel: [117723.085353]
[hrtimer_cancel+0xe/0x20] hrtimer_cancel+0xe/0x20
Mar  9 03:00:59 Aula2Server kernel: [117723.101499]
[do_nanosleep+0x59/0x70] do_nanosleep+0x59/0x70
Mar  9 03:00:59 Aula2Server kernel: [117723.117188]
[hrtimer_nanosleep+0x5c/0xd0] hrtimer_nanosleep+0x5c/0xd0
Mar  9 03:00:59 Aula2Server kernel: [117723.134874]
[hrtimer_wakeup+0x0/0x20] hrtimer_wakeup+0x0/0x20
Mar  9 03:00:59 Aula2Server kernel: [117723.150343]
[sys_nanosleep+0x58/0x60] sys_nanosleep+0x58/0x60
Mar  9 03:00:59 Aula2Server kernel: [117723.165590]
[work_notifysig+0x13/0x19] work_notifysig+0x13/0x19
Mar  9 03:00:59 Aula2Server kernel: [117723.182636]  =======================
Mar  9 03:01:02 Aula2Server kernel: [117724.867853] ------------[ cut
here ]------------
Mar  9 03:01:02 Aula2Server kernel: [117724.882838] kernel BUG at
/build/buildd/linux-2.6.24/arch/x86/mm/highmem_32.c:42!
Mar  9 03:01:02 Aula2Server kernel: [117724.898270] invalid opcode: 0000
[#2] SMP
Mar  9 03:01:02 Aula2Server kernel: [117724.913491] Modules linked in:
xt_multiport video output sbs sbshc container dock battery w83627ehf
hwmon_vid iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop
ipv6 sn9c102 compat_ioctl32 gspca videodev v4l2_common v4l1_compat
snd_hda_intel snd_hwdep snd_pcm_oss snd_pcm snd_page_alloc snd_mixer_oss
sky2 snd_seq_dummy snd_seq_oss psmouse snd_seq_midi serio_raw
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device shpchp
button evdev pci_hotplug snd pcspkr parport_pc parport soundcore
intel_agp agpgart jfs sr_mod cdrom pata_acpi ata_piix usbhid hid
usb_storage libusual sg sd_mod ahci ata_generic pata_it821x libata
floppy scsi_mod ehci_hcd uhci_hcd usbcore raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
processor fan fuse vesafb fbcon tileblit font bitblit softcursor
Mar  9 03:01:02 Aula2Server kernel: [117725.017819]
Mar  9 03:01:02 Aula2Server kernel: [117725.035765] Pid: 6404, comm:
cron Tainted: G      D (2.6.24-23-server #1)
Mar  9 03:01:02 Aula2Server kernel: [117725.054331] EIP:
0060:[kmap_atomic_prot+0x90/0x130] EFLAGS: 00010206 CPU: 0
Mar  9 03:01:02 Aula2Server kernel: [117725.072872] EIP is at
kmap_atomic_prot+0x90/0x130
Mar  9 03:01:02 Aula2Server kernel: [117725.091414] EAX: 7d1fc163 EBX:
00000007 ECX: c1fa1ec0 EDX: 00000000
Mar  9 03:01:02 Aula2Server kernel: [117725.110362] ESI: 00000163 EDI:
80000000 EBP: f589c574 ESP: f559be64
Mar  9 03:01:02 Aula2Server kernel: [117725.129109]  DS: 007b ES: 007b
FS: 00d8 GS: 0033 SS: 0068
Mar  9 03:01:02 Aula2Server kernel: [117725.147878] Process cron (pid:
6404, ti=f559a000 task=f5598000 task.ti=f559a000)
Mar  9 03:01:02 Aula2Server kernel: [117725.148357] Stack: c0224be5
0000370c fffff000 00000038 00000007 80000000 7d0f6067 f589c540
Mar  9 03:01:02 Aula2Server kernel: [117725.167780]        f589c574
c01261ec 00000163 80000000 f589c540 c0183859 c200fb80 c20134b4
Mar  9 03:01:02 Aula2Server kernel: [117725.187262]        c2011100
00000000 c04053a0 c010736e f55981f0 c049a400 f750fc40 f589c540
Mar  9 03:01:02 Aula2Server kernel: [117725.206923] Call Trace:
Mar  9 03:01:02 Aula2Server kernel: [117725.245863]
[snd_seq:vsnprintf+0x2d5/0x610] vsnprintf+0x2d5/0x610
Mar  9 03:01:02 Aula2Server kernel: [117725.265618]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:02 Aula2Server kernel: [117725.285370]
[handle_mm_fault+0x149/0xb80] handle_mm_fault+0x149/0xb80
Mar  9 03:01:02 Aula2Server kernel: [117725.305389]
[__switch_to+0x9e/0x150] __switch_to+0x9e/0x150
Mar  9 03:01:02 Aula2Server kernel: [117725.325281]
[hrtimer_cancel+0xe/0x20] hrtimer_cancel+0xe/0x20
Mar  9 03:01:02 Aula2Server kernel: [117725.345056]
[do_nanosleep+0x59/0x70] do_nanosleep+0x59/0x70
Mar  9 03:01:02 Aula2Server kernel: [117725.364607]
[hrtimer_nanosleep+0x5c/0xd0] hrtimer_nanosleep+0x5c/0xd0
Mar  9 03:01:02 Aula2Server kernel: [117725.383540]
[do_page_fault+0x143/0x900] do_page_fault+0x143/0x900
Mar  9 03:01:02 Aula2Server kernel: [117725.402224]
[do_nanosleep+0x46/0x70] do_nanosleep+0x46/0x70
Mar  9 03:01:02 Aula2Server kernel: [117725.420897]
[sys_nanosleep+0x58/0x60] sys_nanosleep+0x58/0x60
Mar  9 03:01:02 Aula2Server kernel: [117725.439298]
[do_page_fault+0x0/0x900] do_page_fault+0x0/0x900
Mar  9 03:01:02 Aula2Server kernel: [117725.457566]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:02 Aula2Server kernel: [117725.475694]  =======================
Mar  9 03:01:02 Aula2Server kernel: [117725.493441] Code: 14 40 8d 14 90
a1 20 a3 40 c0 01 da 89 54 24 10 c1 e2 03 89 54 24 0c 89 44 24 08 a1 28
43 4b c0 29 d0 8b 50 04 8b 00 85 c0 74 04 <0f> 0b eb fe 85 d2 75 f8 2b
0d 00 1e 50 c0 31 db c1 f9 05 0f a4
Mar  9 03:01:02 Aula2Server kernel: [117725.531982] EIP:
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130 SS:ESP
0068:f559be64
Mar  9 03:01:02 Aula2Server kernel: [117725.553358] ---[ end trace
1b2cab846758a6ac ]---
Mar  9 03:01:02 Aula2Server kernel: [117725.573195] note: cron[6404]
exited with preempt_count 1
Mar  9 03:01:02 Aula2Server kernel: [117725.593000] ------------[ cut
here ]------------
Mar  9 03:01:03 Aula2Server kernel: [117725.612578] kernel BUG at
/build/buildd/linux-2.6.24/arch/x86/mm/highmem_32.c:42!
Mar  9 03:01:03 Aula2Server kernel: [117725.632546] invalid opcode: 0000
[#3] SMP
Mar  9 03:01:03 Aula2Server kernel: [117725.652633] Modules linked in:
xt_multiport video output sbs sbshc container dock battery w83627ehf
hwmon_vid iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop
ipv6 sn9c102 compat_ioctl32 gspca videodev v4l2_common v4l1_compat
snd_hda_intel snd_hwdep snd_pcm_oss snd_pcm snd_page_alloc snd_mixer_oss
sky2 snd_seq_dummy snd_seq_oss psmouse snd_seq_midi serio_raw
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device shpchp
button evdev pci_hotplug snd pcspkr parport_pc parport soundcore
intel_agp agpgart jfs sr_mod cdrom pata_acpi ata_piix usbhid hid
usb_storage libusual sg sd_mod ahci ata_generic pata_it821x libata
floppy scsi_mod ehci_hcd uhci_hcd usbcore raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
processor fan fuse vesafb fbcon tileblit font bitblit softcursor
Mar  9 03:01:03 Aula2Server kernel: [117725.789349]
Mar  9 03:01:03 Aula2Server kernel: [117725.812937] Pid: 6404, comm:
cron Tainted: G      D (2.6.24-23-server #1)
Mar  9 03:01:03 Aula2Server kernel: [117725.836878] EIP:
0060:[kmap_atomic_prot+0x90/0x130] EFLAGS: 00010206 CPU: 0
Mar  9 03:01:03 Aula2Server kernel: [117725.860904] EIP is at
kmap_atomic_prot+0x90/0x130
Mar  9 03:01:03 Aula2Server kernel: [117725.884974] EAX: 7d1fc163 EBX:
00000007 ECX: c1fa1aa0 EDX: 00000000
Mar  9 03:01:03 Aula2Server kernel: [117725.909216] ESI: 00000163 EDI:
80000000 EBP: 00000200 ESP: f559bc44
Mar  9 03:01:03 Aula2Server kernel: [117725.933475]  DS: 007b ES: 007b
FS: 00d8 GS: 0000 SS: 0068
Mar  9 03:01:03 Aula2Server kernel: [117725.957763] Process cron (pid:
6404, ti=f559a000 task=f5598000 task.ti=f559a000)
Mar  9 03:01:03 Aula2Server kernel: [117725.958243] Stack: 00000046
00000046 fffff000 00000038 00000007 80000000 00000007 7d0d5067
Mar  9 03:01:03 Aula2Server kernel: [117725.982975]        00000200
c01261ec 00000163 80000000 c1fa1aa0 c0181978 c04b48d0 00000092
Mar  9 03:01:03 Aula2Server kernel: [117726.007926]        c1fa1aac
c04992a0 c200f2b0 00000000 f5475c08 f559bd14 00000000 00000000
Mar  9 03:01:03 Aula2Server kernel: [117726.032861] Call Trace:
Mar  9 03:01:03 Aula2Server kernel: [117726.082371]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:03 Aula2Server kernel: [117726.107561]
[unmap_vmas+0x2e8/0x740] unmap_vmas+0x2e8/0x740
Mar  9 03:01:03 Aula2Server kernel: [117726.132795]
[exit_mmap+0x79/0xf0] exit_mmap+0x79/0xf0
Mar  9 03:01:03 Aula2Server kernel: [117726.157893]  [mmput+0x1e/0x80]
mmput+0x1e/0x80
Mar  9 03:01:03 Aula2Server kernel: [117726.182690]
[do_exit+0x165/0x860] do_exit+0x165/0x860
Mar  9 03:01:03 Aula2Server kernel: [117726.207467]
[snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
Mar  9 03:01:03 Aula2Server kernel: [117726.231978]  [die+0x277/0x280]
die+0x277/0x280
Mar  9 03:01:03 Aula2Server kernel: [117726.255891]
[do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
Mar  9 03:01:03 Aula2Server kernel: [117726.279131]
[do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
Mar  9 03:01:03 Aula2Server kernel: [117726.301695]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:03 Aula2Server kernel: [117726.323631]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:03 Aula2Server kernel: [117726.344812]
[number+0x35d/0x370] number+0x35d/0x370
Mar  9 03:01:03 Aula2Server kernel: [117726.365534]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:03 Aula2Server kernel: [117726.386057]
[sys_uselib+0xfb/0x130] sys_uselib+0xfb/0x130
Mar  9 03:01:03 Aula2Server kernel: [117726.406388]
[switch_to_new_gdt+0x28/0x40] switch_to_new_gdt+0x28/0x40
Mar  9 03:01:03 Aula2Server kernel: [117726.426607]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:03 Aula2Server kernel: [117726.446814]
[snd_seq:vsnprintf+0x2d5/0x610] vsnprintf+0x2d5/0x610
Mar  9 03:01:03 Aula2Server kernel: [117726.466986]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:03 Aula2Server kernel: [117726.486954]
[handle_mm_fault+0x149/0xb80] handle_mm_fault+0x149/0xb80
Mar  9 03:01:03 Aula2Server kernel: [117726.506874]
[__switch_to+0x9e/0x150] __switch_to+0x9e/0x150
Mar  9 03:01:03 Aula2Server kernel: [117726.526755]
[hrtimer_cancel+0xe/0x20] hrtimer_cancel+0xe/0x20
Mar  9 03:01:03 Aula2Server kernel: [117726.546293]
[do_nanosleep+0x59/0x70] do_nanosleep+0x59/0x70
Mar  9 03:01:03 Aula2Server kernel: [117726.565582]
[hrtimer_nanosleep+0x5c/0xd0] hrtimer_nanosleep+0x5c/0xd0
Mar  9 03:01:03 Aula2Server kernel: [117726.584854]
[do_page_fault+0x143/0x900] do_page_fault+0x143/0x900
Mar  9 03:01:03 Aula2Server kernel: [117726.603991]
[do_nanosleep+0x46/0x70] do_nanosleep+0x46/0x70
Mar  9 03:01:03 Aula2Server kernel: [117726.622953]
[sys_nanosleep+0x58/0x60] sys_nanosleep+0x58/0x60
Mar  9 03:01:03 Aula2Server kernel: [117726.642004]
[do_page_fault+0x0/0x900] do_page_fault+0x0/0x900
Mar  9 03:01:03 Aula2Server kernel: [117726.661037]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:03 Aula2Server kernel: [117726.679960]  =======================
Mar  9 03:01:03 Aula2Server kernel: [117726.698983] Code: 14 40 8d 14 90
a1 20 a3 40 c0 01 da 89 54 24 10 c1 e2 03 89 54 24 0c 89 44 24 08 a1 28
43 4b c0 29 d0 8b 50 04 8b 00 85 c0 74 04 <0f> 0b eb fe 85 d2 75 f8 2b
0d 00 1e 50 c0 31 db c1 f9 05 0f a4
Mar  9 03:01:03 Aula2Server kernel: [117726.739508] EIP:
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130 SS:ESP
0068:f559bc44
Mar  9 03:01:03 Aula2Server kernel: [117726.761983] ---[ end trace
1b2cab846758a6ac ]---
Mar  9 03:01:03 Aula2Server kernel: [117726.782897] Fixing recursive
fault but reboot is needed!
Mar  9 03:01:03 Aula2Server zmdc[6010]: ERR ['zma -m 1' exited
abnormally, exit status 214]
Mar  9 03:01:03 Aula2Server kernel: [117726.803544] BUG: scheduling
while atomic: cron/6404/0x00000002
Mar  9 03:01:03 Aula2Server kernel: [117726.826323] Pid: 6404, comm:
cron Tainted: G      D 2.6.24-23-server #1
Mar  9 03:01:03 Aula2Server kernel: [117726.849360]
[jbd:schedule+0x582/0x6b0] schedule+0x582/0x630
Mar  9 03:01:03 Aula2Server kernel: [117726.870349]
[do_exit+0x750/0x860] do_exit+0x750/0x860
Mar  9 03:01:03 Aula2Server kernel: [117726.892581]
[snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
Mar  9 03:01:03 Aula2Server kernel: [117726.912405]  [die+0x277/0x280]
die+0x277/0x280
Mar  9 03:01:03 Aula2Server kernel: [117726.931941]
[do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
Mar  9 03:01:03 Aula2Server kernel: [117726.953328]
[do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
Mar  9 03:01:03 Aula2Server kernel: [117726.972712]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:03 Aula2Server kernel: [117726.993687]  [<f8abb35f>]
uhci_irq+0x8f/0x160 [uhci_hcd]
Mar  9 03:01:03 Aula2Server kernel: [117727.012681]
[update_curr+0x9f/0x150] update_curr+0x9f/0x150
Mar  9 03:01:03 Aula2Server kernel: [117727.031612]
[ack_ioapic_quirk_irq+0x47/0xb0] ack_ioapic_quirk_irq+0x47/0xb0
Mar  9 03:01:03 Aula2Server kernel: [117727.051786]
[handle_fasteoi_irq+0x9c/0xe0] handle_fasteoi_irq+0x9c/0xe0
Mar  9 03:01:03 Aula2Server kernel: [117727.069447]  [do_IRQ+0x40/0x70]
do_IRQ+0x40/0x70
Mar  9 03:01:03 Aula2Server kernel: [117727.088513]
[run_timer_softirq+0x30/0x1e0] run_timer_softirq+0x30/0x1e0
Mar  9 03:01:03 Aula2Server kernel: [117727.104968]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:03 Aula2Server kernel: [117727.120928]
[copy_process+0x84b/0x11e0] copy_process+0x84b/0x11e0
Mar  9 03:01:03 Aula2Server kernel: [117727.138109]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:03 Aula2Server kernel: [117727.153458]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:03 Aula2Server kernel: [117727.168562]
[unmap_vmas+0x2e8/0x740] unmap_vmas+0x2e8/0x740
Mar  9 03:01:03 Aula2Server kernel: [117727.185262]
[exit_mmap+0x79/0xf0] exit_mmap+0x79/0xf0
Mar  9 03:01:03 Aula2Server kernel: [117727.200120]  [mmput+0x1e/0x80]
mmput+0x1e/0x80
Mar  9 03:01:03 Aula2Server kernel: [117727.216694]
[do_exit+0x165/0x860] do_exit+0x165/0x860
Mar  9 03:01:03 Aula2Server kernel: [117727.231247]
[snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
Mar  9 03:01:04 Aula2Server kernel: [117727.245820]  [die+0x277/0x280]
die+0x277/0x280
Mar  9 03:01:04 Aula2Server kernel: [117727.262003]
[do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
Mar  9 03:01:04 Aula2Server kernel: [117727.276008]
[do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
Mar  9 03:01:04 Aula2Server kernel: [117727.289916]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:04 Aula2Server kernel: [117727.303720]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:04 Aula2Server kernel: [117727.319095]
[number+0x35d/0x370] number+0x35d/0x370
Mar  9 03:01:04 Aula2Server kernel: [117727.332469]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:04 Aula2Server kernel: [117727.345920]
[sys_uselib+0xfb/0x130] sys_uselib+0xfb/0x130
Mar  9 03:01:04 Aula2Server kernel: [117727.361200]
[switch_to_new_gdt+0x28/0x40] switch_to_new_gdt+0x28/0x40
Mar  9 03:01:04 Aula2Server kernel: [117727.374719]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:04 Aula2Server kernel: [117727.388280]
[snd_seq:vsnprintf+0x2d5/0x610] vsnprintf+0x2d5/0x610
Mar  9 03:01:04 Aula2Server kernel: [117727.403529]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:04 Aula2Server kernel: [117727.417117]
[handle_mm_fault+0x149/0xb80] handle_mm_fault+0x149/0xb80
Mar  9 03:01:04 Aula2Server kernel: [117727.430748]
[__switch_to+0x9e/0x150] __switch_to+0x9e/0x150
Mar  9 03:01:04 Aula2Server kernel: [117727.444533]
[hrtimer_cancel+0xe/0x20] hrtimer_cancel+0xe/0x20
Mar  9 03:01:04 Aula2Server kernel: [117727.460085]
[do_nanosleep+0x59/0x70] do_nanosleep+0x59/0x70
Mar  9 03:01:04 Aula2Server kernel: [117727.473903]
[hrtimer_nanosleep+0x5c/0xd0] hrtimer_nanosleep+0x5c/0xd0
Mar  9 03:01:04 Aula2Server kernel: [117727.487771]
[do_page_fault+0x143/0x900] do_page_fault+0x143/0x900
Mar  9 03:01:04 Aula2Server megatec[6322]: Communications with UPS lost:
No status from UPS.
Mar  9 03:01:04 Aula2Server kernel: [117727.503506]
[do_nanosleep+0x46/0x70] do_nanosleep+0x46/0x70
Mar  9 03:01:04 Aula2Server kernel: [117727.517255]
[sys_nanosleep+0x58/0x60] sys_nanosleep+0x58/0x60
Mar  9 03:01:04 Aula2Server kernel: [117727.531151]
[do_page_fault+0x0/0x900] do_page_fault+0x0/0x900
Mar  9 03:01:04 Aula2Server kernel: [117727.546866]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:04 Aula2Server kernel: [117727.560737]  =======================
Mar  9 03:01:06 Aula2Server megatec[6322]: Communications with UPS
re-established
Mar  9 03:01:32 Aula2Server kernel: [117755.397881] ------------[ cut
here ]------------
Mar  9 03:01:32 Aula2Server kernel: [117755.411787] kernel BUG at
/build/buildd/linux-2.6.24/arch/x86/mm/highmem_32.c:42!
Mar  9 03:01:32 Aula2Server kernel: [117755.426060] invalid opcode: 0000
[#4] SMP
Mar  9 03:01:32 Aula2Server kernel: [117755.440372] Modules linked in:
xt_multiport video output sbs sbshc container dock battery w83627ehf
hwmon_vid iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop
ipv6 sn9c102 compat_ioctl32 gspca videodev v4l2_common v4l1_compat
snd_hda_intel snd_hwdep snd_pcm_oss snd_pcm snd_page_alloc snd_mixer_oss
sky2 snd_seq_dummy snd_seq_oss psmouse snd_seq_midi serio_raw
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device shpchp
button evdev pci_hotplug snd pcspkr parport_pc parport soundcore
intel_agp agpgart jfs sr_mod cdrom pata_acpi ata_piix usbhid hid
usb_storage libusual sg sd_mod ahci ata_generic pata_it821x libata
floppy scsi_mod ehci_hcd uhci_hcd usbcore raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
processor fan fuse vesafb fbcon tileblit font bitblit softcursor
Mar  9 03:01:32 Aula2Server kernel: [117755.542494]
Mar  9 03:01:32 Aula2Server kernel: [117755.560234] Pid: 6050, comm:
zmfilter.pl Tainted: G      D (2.6.24-23-server #1)
Mar  9 03:01:32 Aula2Server kernel: [117755.578651] EIP:
0060:[kmap_atomic_prot+0x90/0x130] EFLAGS: 00010206 CPU: 0
Mar  9 03:01:32 Aula2Server kernel: [117755.596530] EIP is at
kmap_atomic_prot+0x90/0x130
Mar  9 03:01:32 Aula2Server kernel: [117755.614095] EAX: 7d1fc163 EBX:
00000007 ECX: c1ff3900 EDX: 00000000
Mar  9 03:01:32 Aula2Server kernel: [117755.631456] ESI: 00000163 EDI:
80000000 EBP: f750f734 ESP: dfc75e64
Mar  9 03:01:32 Aula2Server kernel: [117755.648811]  DS: 007b ES: 007b
FS: 00d8 GS: 0033 SS: 0068
Mar  9 03:01:32 Aula2Server kernel: [117755.665956] Process zmfilter.pl
(pid: 6050, ti=dfc74000 task=f680ab80 task.ti=dfc74000)
Mar  9 03:01:32 Aula2Server kernel: [117755.666474] Stack: 00000000
0000000f fffff000 00000038 00000007 80000000 7f9c8067 f750f700
Mar  9 03:01:32 Aula2Server kernel: [117755.684130]        f750f734
c01261ec 00000163 80000000 f750f700 c0183859 ffffffff 00000000
Mar  9 03:01:32 Aula2Server kernel: [117755.701855]        c2011100
00000000 c04053a0 c010736e f680ad70 c049a400 f750fc40 f750f700
Mar  9 03:01:32 Aula2Server kernel: [117755.719535] Call Trace:
Mar  9 03:01:32 Aula2Server kernel: [117755.754567]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:32 Aula2Server kernel: [117755.772589]
[handle_mm_fault+0x149/0xb80] handle_mm_fault+0x149/0xb80
Mar  9 03:01:32 Aula2Server kernel: [117755.790488]
[__switch_to+0x9e/0x150] __switch_to+0x9e/0x150
Mar  9 03:01:32 Aula2Server kernel: [117755.808695]
[hrtimer_cancel+0xe/0x20] hrtimer_cancel+0xe/0x20
Mar  9 03:01:32 Aula2Server kernel: [117755.826665]
[do_nanosleep+0x59/0x70] do_nanosleep+0x59/0x70
Mar  9 03:01:32 Aula2Server kernel: [117755.844744]
[hrtimer_nanosleep+0x5c/0xd0] hrtimer_nanosleep+0x5c/0xd0
Mar  9 03:01:32 Aula2Server kernel: [117755.862667]
[do_page_fault+0x143/0x900] do_page_fault+0x143/0x900
Mar  9 03:01:32 Aula2Server kernel: [117755.880552]
[do_nanosleep+0x46/0x70] do_nanosleep+0x46/0x70
Mar  9 03:01:32 Aula2Server kernel: [117755.898575]
[sys_nanosleep+0x58/0x60] sys_nanosleep+0x58/0x60
Mar  9 03:01:32 Aula2Server kernel: [117755.916377]
[do_page_fault+0x0/0x900] do_page_fault+0x0/0x900
Mar  9 03:01:32 Aula2Server kernel: [117755.934311]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:32 Aula2Server kernel: [117755.952037]  =======================
Mar  9 03:01:32 Aula2Server kernel: [117755.969896] Code: 14 40 8d 14 90
a1 20 a3 40 c0 01 da 89 54 24 10 c1 e2 03 89 54 24 0c 89 44 24 08 a1 28
43 4b c0 29 d0 8b 50 04 8b 00 85 c0 74 04 <0f> 0b eb fe 85 d2 75 f8 2b
0d 00 1e 50 c0 31 db c1 f9 05 0f a4
Mar  9 03:01:32 Aula2Server kernel: [117756.008087] EIP:
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130 SS:ESP
0068:dfc75e64
Mar  9 03:01:32 Aula2Server kernel: [117756.029528] ---[ end trace
1b2cab846758a6ac ]---
Mar  9 03:01:32 Aula2Server kernel: [117756.048874] note:
zmfilter.pl[6050] exited with preempt_count 1
Mar  9 03:01:32 Aula2Server kernel: [117756.070543] ------------[ cut
here ]------------
Mar  9 03:01:34 Aula2Server kernel: [117756.090423] kernel BUG at
/build/buildd/linux-2.6.24/arch/x86/mm/highmem_32.c:42!
Mar  9 03:01:34 Aula2Server kernel: [117756.110356] invalid opcode: 0000
[#5] SMP
Mar  9 03:01:34 Aula2Server kernel: [117756.130515] Modules linked in:
xt_multiport video output sbs sbshc container dock battery w83627ehf
hwmon_vid iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop
ipv6 sn9c102 compat_ioctl32 gspca videodev v4l2_common v4l1_compat
snd_hda_intel snd_hwdep snd_pcm_oss snd_pcm snd_page_alloc snd_mixer_oss
sky2 snd_seq_dummy snd_seq_oss psmouse snd_seq_midi serio_raw
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device shpchp
button evdev pci_hotplug snd pcspkr parport_pc parport soundcore
intel_agp agpgart jfs sr_mod cdrom pata_acpi ata_piix usbhid hid
usb_storage libusual sg sd_mod ahci ata_generic pata_it821x libata
floppy scsi_mod ehci_hcd uhci_hcd usbcore raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
processor fan fuse vesafb fbcon tileblit font bitblit softcursor
Mar  9 03:01:34 Aula2Server kernel: [117756.268073]
Mar  9 03:01:34 Aula2Server kernel: [117756.291887] Pid: 6050, comm:
zmfilter.pl Tainted: G      D (2.6.24-23-server #1)
Mar  9 03:01:34 Aula2Server kernel: [117756.316224] EIP:
0060:[kmap_atomic_prot+0x90/0x130] EFLAGS: 00010206 CPU: 0
Mar  9 03:01:34 Aula2Server kernel: [117756.340438] EIP is at
kmap_atomic_prot+0x90/0x130
Mar  9 03:01:34 Aula2Server kernel: [117756.364817] EAX: 7d1fc163 EBX:
00000007 ECX: c1ff00e0 EDX: 00000000
Mar  9 03:01:34 Aula2Server kernel: [117756.389443] ESI: 00000163 EDI:
80000000 EBP: 00000200 ESP: dfc75c44
Mar  9 03:01:34 Aula2Server kernel: [117756.414058]  DS: 007b ES: 007b
FS: 00d8 GS: 0000 SS: 0068
Mar  9 03:01:34 Aula2Server kernel: [117756.438681] Process zmfilter.pl
(pid: 6050, ti=dfc74000 task=f680ab80 task.ti=dfc74000)
Mar  9 03:01:34 Aula2Server kernel: [117756.439199] Stack: 00000046
00000046 fffff000 00000038 00000007 80000000 00000007 7f807067
Mar  9 03:01:34 Aula2Server kernel: [117756.464342]        00000200
c01261ec 00000163 80000000 c1ff00e0 c0181978 c04b48d7 00000092
Mar  9 03:01:34 Aula2Server kernel: [117756.489627]        c1ff00ec
c04992a0 c200f2b0 00000000 f648d108 dfc75d14 00000000 00000000
Mar  9 03:01:34 Aula2Server kernel: [117756.515079] Call Trace:
Mar  9 03:01:34 Aula2Server kernel: [117756.565433]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:34 Aula2Server kernel: [117756.590993]
[unmap_vmas+0x2e8/0x740] unmap_vmas+0x2e8/0x740
Mar  9 03:01:34 Aula2Server kernel: [117756.616442]
[exit_mmap+0x79/0xf0] exit_mmap+0x79/0xf0
Mar  9 03:01:34 Aula2Server kernel: [117756.641987]  [mmput+0x1e/0x80]
mmput+0x1e/0x80
Mar  9 03:01:34 Aula2Server kernel: [117756.667446]
[do_exit+0x165/0x860] do_exit+0x165/0x860
Mar  9 03:01:34 Aula2Server kernel: [117756.692858]
[snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
Mar  9 03:01:34 Aula2Server kernel: [117756.718015]  [die+0x277/0x280]
die+0x277/0x280
Mar  9 03:01:34 Aula2Server kernel: [117756.742755]
[do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
Mar  9 03:01:34 Aula2Server kernel: [117756.767065]
[do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
Mar  9 03:01:34 Aula2Server kernel: [117756.790674]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:34 Aula2Server kernel: [117756.813708]
[do_lookup+0x67/0x1c0] do_lookup+0x67/0x1c0
Mar  9 03:01:34 Aula2Server kernel: [117756.836052]
[permission+0x97/0x120] permission+0x97/0x120
Mar  9 03:01:34 Aula2Server kernel: [117756.857755]
[ext3:__mark_inode_dirty+0x58/0x1190] __mark_inode_dirty+0x58/0x180
Mar  9 03:01:34 Aula2Server kernel: [117756.879048]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:34 Aula2Server kernel: [117756.900132]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:34 Aula2Server kernel: [117756.921118]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:34 Aula2Server kernel: [117756.941810]
[handle_mm_fault+0x149/0xb80] handle_mm_fault+0x149/0xb80
Mar  9 03:01:34 Aula2Server kernel: [117756.962487]
[__switch_to+0x9e/0x150] __switch_to+0x9e/0x150
Mar  9 03:01:34 Aula2Server kernel: [117756.983258]
[hrtimer_cancel+0xe/0x20] hrtimer_cancel+0xe/0x20
Mar  9 03:01:34 Aula2Server kernel: [117757.003783]
[do_nanosleep+0x59/0x70] do_nanosleep+0x59/0x70
Mar  9 03:01:34 Aula2Server kernel: [117757.024219]
[hrtimer_nanosleep+0x5c/0xd0] hrtimer_nanosleep+0x5c/0xd0
Mar  9 03:01:34 Aula2Server kernel: [117757.044466]
[do_page_fault+0x143/0x900] do_page_fault+0x143/0x900
Mar  9 03:01:34 Aula2Server kernel: [117757.064529]
[do_nanosleep+0x46/0x70] do_nanosleep+0x46/0x70
Mar  9 03:01:34 Aula2Server kernel: [117757.084428]
[sys_nanosleep+0x58/0x60] sys_nanosleep+0x58/0x60
Mar  9 03:01:34 Aula2Server kernel: [117757.104084]
[do_page_fault+0x0/0x900] do_page_fault+0x0/0x900
Mar  9 03:01:34 Aula2Server kernel: [117757.123504]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:34 Aula2Server kernel: [117757.143073]  =======================
Mar  9 03:01:34 Aula2Server kernel: [117757.162369] Code: 14 40 8d 14 90
a1 20 a3 40 c0 01 da 89 54 24 10 c1 e2 03 89 54 24 0c 89 44 24 08 a1 28
43 4b c0 29 d0 8b 50 04 8b 00 85 c0 74 04 <0f> 0b eb fe 85 d2 75 f8 2b
0d 00 1e 50 c0 31 db c1 f9 05 0f a4
Mar  9 03:01:34 Aula2Server kernel: [117757.203734] EIP:
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130 SS:ESP
0068:dfc75c44
Mar  9 03:01:34 Aula2Server kernel: [117757.226904] ---[ end trace
1b2cab846758a6ac ]---
Mar  9 03:01:34 Aula2Server kernel: [117757.248468] Fixing recursive
fault but reboot is needed!
Mar  9 03:01:34 Aula2Server kernel: [117757.271769] BUG: scheduling
while atomic: zmfilter.pl/6050/0x00000002
Mar  9 03:01:34 Aula2Server kernel: [117757.293247] Pid: 6050, comm:
zmfilter.pl Tainted: G      D 2.6.24-23-server #1
Mar  9 03:01:34 Aula2Server kernel: [117757.316664]
[jbd:schedule+0x582/0x6b0] schedule+0x582/0x630
Mar  9 03:01:34 Aula2Server kernel: [117757.338126]
[do_exit+0x750/0x860] do_exit+0x750/0x860
Mar  9 03:01:34 Aula2Server kernel: [117757.361360]
[snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
Mar  9 03:01:34 Aula2Server kernel: [117757.382648]  [die+0x277/0x280]
die+0x277/0x280
Mar  9 03:01:34 Aula2Server kernel: [117757.405437]
[do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
Mar  9 03:01:34 Aula2Server kernel: [117757.425940]
[do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
Mar  9 03:01:34 Aula2Server kernel: [117757.445942]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:34 Aula2Server kernel: [117757.468049]
[handle_IRQ_event+0x30/0x60] handle_IRQ_event+0x30/0x60
Mar  9 03:01:34 Aula2Server kernel: [117757.489747]
[jbd:autoremove_wake_function+0x14/0x40] autoremove_wake_function+0x14/0x40
Mar  9 03:01:34 Aula2Server kernel: [117757.509656]
[__wake_up_common+0x4b/0x80] __wake_up_common+0x4b/0x80
Mar  9 03:01:34 Aula2Server kernel: [117757.531011]
[snd_hwdep:__wake_up+0x3e/0x1f10] __wake_up+0x3e/0x60
Mar  9 03:01:34 Aula2Server kernel: [117757.550276]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:34 Aula2Server kernel: [117757.569089]
[copy_process+0x84b/0x11e0] copy_process+0x84b/0x11e0
Mar  9 03:01:34 Aula2Server kernel: [117757.588967]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:34 Aula2Server kernel: [117757.606338]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:34 Aula2Server kernel: [117757.623082]
[unmap_vmas+0x2e8/0x740] unmap_vmas+0x2e8/0x740
Mar  9 03:01:34 Aula2Server kernel: [117757.641065]
[exit_mmap+0x79/0xf0] exit_mmap+0x79/0xf0
Mar  9 03:01:34 Aula2Server kernel: [117757.656707]  [mmput+0x1e/0x80]
mmput+0x1e/0x80
Mar  9 03:01:34 Aula2Server kernel: [117757.672051]
[do_exit+0x165/0x860] do_exit+0x165/0x860
Mar  9 03:01:34 Aula2Server kernel: [117757.688953]
[snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
Mar  9 03:01:34 Aula2Server kernel: [117757.703926]  [die+0x277/0x280]
die+0x277/0x280
Mar  9 03:01:34 Aula2Server kernel: [117757.718791]
[do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
Mar  9 03:01:34 Aula2Server kernel: [117757.735409]
[do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
Mar  9 03:01:34 Aula2Server kernel: [117757.750088]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:34 Aula2Server kernel: [117757.764700]
[do_lookup+0x67/0x1c0] do_lookup+0x67/0x1c0
Mar  9 03:01:34 Aula2Server kernel: [117757.780744]
[permission+0x97/0x120] permission+0x97/0x120
Mar  9 03:01:34 Aula2Server kernel: [117757.794814]
[ext3:__mark_inode_dirty+0x58/0x1190] __mark_inode_dirty+0x58/0x180
Mar  9 03:01:34 Aula2Server kernel: [117757.809026]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:34 Aula2Server kernel: [117757.824789]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:34 Aula2Server kernel: [117757.838541]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:34 Aula2Server kernel: [117757.853999]
[handle_mm_fault+0x149/0xb80] handle_mm_fault+0x149/0xb80
Mar  9 03:01:34 Aula2Server kernel: [117757.867732]
[__switch_to+0x9e/0x150] __switch_to+0x9e/0x150
Mar  9 03:01:34 Aula2Server kernel: [117757.881328]
[hrtimer_cancel+0xe/0x20] hrtimer_cancel+0xe/0x20
Mar  9 03:01:34 Aula2Server kernel: [117757.895123]
[do_nanosleep+0x59/0x70] do_nanosleep+0x59/0x70
Mar  9 03:01:34 Aula2Server kernel: [117757.910678]
[hrtimer_nanosleep+0x5c/0xd0] hrtimer_nanosleep+0x5c/0xd0
Mar  9 03:01:34 Aula2Server kernel: [117757.924491]
[do_page_fault+0x143/0x900] do_page_fault+0x143/0x900
Mar  9 03:01:34 Aula2Server kernel: [117757.938271]
[do_nanosleep+0x46/0x70] do_nanosleep+0x46/0x70
Mar  9 03:01:34 Aula2Server kernel: [117757.953816]
[sys_nanosleep+0x58/0x60] sys_nanosleep+0x58/0x60
Mar  9 03:01:34 Aula2Server kernel: [117757.967812]
[do_page_fault+0x0/0x900] do_page_fault+0x0/0x900
Mar  9 03:01:34 Aula2Server kernel: [117757.981892]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:34 Aula2Server kernel: [117757.997575]  =======================
Mar  9 03:01:35 Aula2Server kernel: [117758.059723] ------------[ cut
here ]------------
Mar  9 03:01:35 Aula2Server kernel: [117758.073601] kernel BUG at
/build/buildd/linux-2.6.24/arch/x86/mm/highmem_32.c:42!
Mar  9 03:01:35 Aula2Server kernel: [117758.087805] invalid opcode: 0000
[#6] SMP
Mar  9 03:01:35 Aula2Server kernel: [117758.101907] Modules linked in:
xt_multiport video output sbs sbshc container dock battery w83627ehf
hwmon_vid iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop
ipv6 sn9c102 compat_ioctl32 gspca videodev v4l2_common v4l1_compat
snd_hda_intel snd_hwdep snd_pcm_oss snd_pcm snd_page_alloc snd_mixer_oss
sky2 snd_seq_dummy snd_seq_oss psmouse snd_seq_midi serio_raw
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device shpchp
button evdev pci_hotplug snd pcspkr parport_pc parport soundcore
intel_agp agpgart jfs sr_mod cdrom pata_acpi ata_piix usbhid hid
usb_storage libusual sg sd_mod ahci ata_generic pata_it821x libata
floppy scsi_mod ehci_hcd uhci_hcd usbcore raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
processor fan fuse vesafb fbcon tileblit font bitblit softcursor
Mar  9 03:01:35 Aula2Server kernel: [117758.203892]
Mar  9 03:01:35 Aula2Server kernel: [117758.221732] Pid: 8792, comm: zmf
Tainted: G      D (2.6.24-23-server #1)
Mar  9 03:01:35 Aula2Server kernel: [117758.239839] EIP:
0060:[kmap_atomic_prot+0x90/0x130] EFLAGS: 00010206 CPU: 0
Mar  9 03:01:35 Aula2Server kernel: [117758.258215] EIP is at
kmap_atomic_prot+0x90/0x130
Mar  9 03:01:35 Aula2Server kernel: [117758.276455] EAX: 7d1fc163 EBX:
00000007 ECX: c1fc9800 EDX: 00000000
Mar  9 03:01:35 Aula2Server kernel: [117758.295019] ESI: 00000163 EDI:
80000000 EBP: f44a28f4 ESP: f4575e64
Mar  9 03:01:35 Aula2Server kernel: [117758.313525]  DS: 007b ES: 007b
FS: 00d8 GS: 0033 SS: 0068
Mar  9 03:01:35 Aula2Server kernel: [117758.331594] Process zmf (pid:
8792, ti=f4574000 task=f54c25c0 task.ti=f4574000)
Mar  9 03:01:35 Aula2Server kernel: [117758.332067] Stack: 0000001c
00000004 fffff000 00000038 00000007 80000000 7e4c0067 f44a28c0
Mar  9 03:01:35 Aula2Server kernel: [117758.350283]        f44a28f4
c01261ec 00000163 80000000 f44a28c0 c0183859 f4575f24 c01f0d8c
Mar  9 03:01:35 Aula2Server kernel: [117758.368313]        ecde5de8
c01865d1 00000001 f4575f64 f5069a80 c049a400 ecde5de8 f8c3eee0
Mar  9 03:01:35 Aula2Server kernel: [117758.386523] Call Trace:
Mar  9 03:01:35 Aula2Server kernel: [117758.421750]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:35 Aula2Server kernel: [117758.439487]
[handle_mm_fault+0x149/0xb80] handle_mm_fault+0x149/0xb80
Mar  9 03:01:35 Aula2Server kernel: [117758.457005]
[security_inode_permission+0x1c/0x20] security_inode_permission+0x1c/0x20
Mar  9 03:01:35 Aula2Server kernel: [117758.474843]
[vma_adjust+0x111/0x440] vma_adjust+0x111/0x440
Mar  9 03:01:35 Aula2Server kernel: [117758.492591]  [<c0145fb0>]
autoremove_wake_function+0x0/0x40
Mar  9 03:01:35 Aula2Server kernel: [117758.510631]
[do_page_fault+0x143/0x900] do_page_fault+0x143/0x900
Mar  9 03:01:35 Aula2Server kernel: [117758.528523]
[vfs_write+0x117/0x170] vfs_write+0x117/0x170
Mar  9 03:01:35 Aula2Server kernel: [117758.546688]
[sys_write+0x41/0x70] sys_write+0x41/0x70
Mar  9 03:01:35 Aula2Server kernel: [117758.564591]
[do_page_fault+0x0/0x900] do_page_fault+0x0/0x900
Mar  9 03:01:35 Aula2Server kernel: [117758.582643]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:35 Aula2Server kernel: [117758.600630]  =======================
Mar  9 03:01:35 Aula2Server kernel: [117758.618432] Code: 14 40 8d 14 90
a1 20 a3 40 c0 01 da 89 54 24 10 c1 e2 03 89 54 24 0c 89 44 24 08 a1 28
43 4b c0 29 d0 8b 50 04 8b 00 85 c0 74 04 <0f> 0b eb fe 85 d2 75 f8 2b
0d 00 1e 50 c0 31 db c1 f9 05 0f a4
Mar  9 03:01:35 Aula2Server kernel: [117758.657074] EIP:
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130 SS:ESP
0068:f4575e64
Mar  9 03:01:35 Aula2Server kernel: [117758.678545] ---[ end trace
1b2cab846758a6ac ]---
Mar  9 03:01:35 Aula2Server kernel: [117758.698473] note: zmf[8792]
exited with preempt_count 1
Mar  9 03:01:36 Aula2Server kernel: [117758.718286] ------------[ cut
here ]------------
Mar  9 03:01:36 Aula2Server kernel: [117758.737873] kernel BUG at
/build/buildd/linux-2.6.24/arch/x86/mm/highmem_32.c:42!
Mar  9 03:01:36 Aula2Server kernel: [117758.757788] invalid opcode: 0000
[#7] SMP
Mar  9 03:01:36 Aula2Server kernel: [117758.777919] Modules linked in:
xt_multiport video output sbs sbshc container dock battery w83627ehf
hwmon_vid iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop
ipv6 sn9c102 compat_ioctl32 gspca videodev v4l2_common v4l1_compat
snd_hda_intel snd_hwdep snd_pcm_oss snd_pcm snd_page_alloc snd_mixer_oss
sky2 snd_seq_dummy snd_seq_oss psmouse snd_seq_midi serio_raw
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device shpchp
button evdev pci_hotplug snd pcspkr parport_pc parport soundcore
intel_agp agpgart jfs sr_mod cdrom pata_acpi ata_piix usbhid hid
usb_storage libusual sg sd_mod ahci ata_generic pata_it821x libata
floppy scsi_mod ehci_hcd uhci_hcd usbcore raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
processor fan fuse vesafb fbcon tileblit font bitblit softcursor
Mar  9 03:01:36 Aula2Server kernel: [117758.915309]
Mar  9 03:01:36 Aula2Server kernel: [117758.938990] Pid: 8792, comm: zmf
Tainted: G      D (2.6.24-23-server #1)
Mar  9 03:01:36 Aula2Server kernel: [117758.963049] EIP:
0060:[kmap_atomic_prot+0x90/0x130] EFLAGS: 00010206 CPU: 0
Mar  9 03:01:36 Aula2Server kernel: [117758.987303] EIP is at
kmap_atomic_prot+0x90/0x130
Mar  9 03:01:36 Aula2Server kernel: [117759.011538] EAX: 7d1fc163 EBX:
00000007 ECX: c1fc9860 EDX: 00000000
Mar  9 03:01:36 Aula2Server kernel: [117759.035985] ESI: 00000163 EDI:
80000000 EBP: 00000200 ESP: f4575c44
Mar  9 03:01:36 Aula2Server kernel: [117759.060509]  DS: 007b ES: 007b
FS: 00d8 GS: 0000 SS: 0068
Mar  9 03:01:36 Aula2Server kernel: [117759.085044] Process zmf (pid:
8792, ti=f4574000 task=f54c25c0 task.ti=f4574000)
Mar  9 03:01:36 Aula2Server kernel: [117759.085518] Stack: 00000046
00000046 fffff000 00000038 00000007 80000000 00000007 7e4c3067
Mar  9 03:01:36 Aula2Server kernel: [117759.110503]        00000200
c01261ec 00000163 80000000 c1fc9860 c0181978 c04b48cf 00000092
Mar  9 03:01:36 Aula2Server kernel: [117759.135536]        c1fc986c
c04992a0 c200f2b0 00000000 f55f4000 f4575d14 00000000 00000000
Mar  9 03:01:36 Aula2Server kernel: [117759.160895] Call Trace:
Mar  9 03:01:36 Aula2Server kernel: [117759.210895]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:36 Aula2Server kernel: [117759.236266]
[unmap_vmas+0x2e8/0x740] unmap_vmas+0x2e8/0x740
Mar  9 03:01:36 Aula2Server kernel: [117759.261568]
[exit_mmap+0x79/0xf0] exit_mmap+0x79/0xf0
Mar  9 03:01:36 Aula2Server kernel: [117759.286870]  [mmput+0x1e/0x80]
mmput+0x1e/0x80
Mar  9 03:01:36 Aula2Server kernel: [117759.312193]
[do_exit+0x165/0x860] do_exit+0x165/0x860
Mar  9 03:01:36 Aula2Server kernel: [117759.337498]
[snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
Mar  9 03:01:36 Aula2Server kernel: [117759.362700]  [die+0x277/0x280]
die+0x277/0x280
Mar  9 03:01:36 Aula2Server kernel: [117759.387602]
[do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
Mar  9 03:01:36 Aula2Server kernel: [117759.412186]
[do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
Mar  9 03:01:36 Aula2Server kernel: [117759.436276]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:36 Aula2Server kernel: [117759.459746]  [<f8c1e452>]
jfs_create+0x132/0x320 [jfs]
Mar  9 03:01:36 Aula2Server kernel: [117759.482661]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:36 Aula2Server kernel: [117759.504879]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:36 Aula2Server kernel: [117759.526504]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:36 Aula2Server kernel: [117759.547591]
[handle_mm_fault+0x149/0xb80] handle_mm_fault+0x149/0xb80
Mar  9 03:01:36 Aula2Server kernel: [117759.568482]
[security_inode_permission+0x1c/0x20] security_inode_permission+0x1c/0x20
Mar  9 03:01:36 Aula2Server kernel: [117759.589385]
[vma_adjust+0x111/0x440] vma_adjust+0x111/0x440
Mar  9 03:01:36 Aula2Server kernel: [117759.610162]  [<c0145fb0>]
autoremove_wake_function+0x0/0x40
Mar  9 03:01:36 Aula2Server kernel: [117759.630992]
[do_page_fault+0x143/0x900] do_page_fault+0x143/0x900
Mar  9 03:01:36 Aula2Server kernel: [117759.651847]
[vfs_write+0x117/0x170] vfs_write+0x117/0x170
Mar  9 03:01:36 Aula2Server kernel: [117759.672521]
[sys_write+0x41/0x70] sys_write+0x41/0x70
Mar  9 03:01:36 Aula2Server kernel: [117759.692988]
[do_page_fault+0x0/0x900] do_page_fault+0x0/0x900
Mar  9 03:01:36 Aula2Server kernel: [117759.713277]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:36 Aula2Server kernel: [117759.733383]  =======================
Mar  9 03:01:36 Aula2Server kernel: [117759.753334] Code: 14 40 8d 14 90
a1 20 a3 40 c0 01 da 89 54 24 10 c1 e2 03 89 54 24 0c 89 44 24 08 a1 28
43 4b c0 29 d0 8b 50 04 8b 00 85 c0 74 04 <0f> 0b eb fe 85 d2 75 f8 2b
0d 00 1e 50 c0 31 db c1 f9 05 0f a4
Mar  9 03:01:36 Aula2Server kernel: [117759.795286] EIP:
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130 SS:ESP
0068:f4575c44
Mar  9 03:01:36 Aula2Server kernel: [117759.818442] ---[ end trace
1b2cab846758a6ac ]---
Mar  9 03:01:36 Aula2Server kernel: [117759.842581] Fixing recursive
fault but reboot is needed!
Mar  9 03:01:36 Aula2Server kernel: [117759.863714] BUG: scheduling
while atomic: zmf/8792/0x00000002
Mar  9 03:01:36 Aula2Server kernel: [117759.886845] Pid: 8792, comm: zmf
Tainted: G      D 2.6.24-23-server #1
Mar  9 03:01:36 Aula2Server kernel: [117759.908198]
[jbd:schedule+0x582/0x6b0] schedule+0x582/0x630
Mar  9 03:01:36 Aula2Server kernel: [117759.931341]
[do_exit+0x750/0x860] do_exit+0x750/0x860
Mar  9 03:01:36 Aula2Server kernel: [117759.952419]
[snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
Mar  9 03:01:36 Aula2Server kernel: [117759.973680]  [die+0x277/0x280]
die+0x277/0x280
Mar  9 03:01:36 Aula2Server kernel: [117759.996820]
[do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
Mar  9 03:01:36 Aula2Server kernel: [117760.018108]
[do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
Mar  9 03:01:36 Aula2Server kernel: [117760.041151]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:36 Aula2Server kernel: [117760.063593]
[scsi_mod:blk_run_queue+0x37/0x240] blk_run_queue+0x37/0x80
Mar  9 03:01:36 Aula2Server kernel: [117760.083654]  [<f8af9a40>]
scsi_next_command+0x30/0x50 [scsi_mod]
Mar  9 03:01:36 Aula2Server kernel: [117760.103865]  [<f8af9bcb>]
scsi_end_request+0xab/0xe0 [scsi_mod]
Mar  9 03:01:36 Aula2Server kernel: [117760.125814]  [<f8afa8b9>]
scsi_io_completion+0xa9/0x3d0 [scsi_mod]
Mar  9 03:01:36 Aula2Server kernel: [117760.146036]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:36 Aula2Server kernel: [117760.167682]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:36 Aula2Server kernel: [117760.187308]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:36 Aula2Server kernel: [117760.208663]
[unmap_vmas+0x2e8/0x740] unmap_vmas+0x2e8/0x740
Mar  9 03:01:36 Aula2Server kernel: [117760.227539]
[exit_mmap+0x79/0xf0] exit_mmap+0x79/0xf0
Mar  9 03:01:37 Aula2Server kernel: [117760.245662]  [mmput+0x1e/0x80]
mmput+0x1e/0x80
Mar  9 03:01:37 Aula2Server kernel: [117760.264956]
[do_exit+0x165/0x860] do_exit+0x165/0x860
Mar  9 03:01:37 Aula2Server kernel: [117760.282099]
[snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
Mar  9 03:01:37 Aula2Server kernel: [117760.300010]  [die+0x277/0x280]
die+0x277/0x280
Mar  9 03:01:37 Aula2Server kernel: [117760.315575]
[do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
Mar  9 03:01:37 Aula2Server kernel: [117760.331049]
[do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
Mar  9 03:01:37 Aula2Server kernel: [117760.348199]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:37 Aula2Server kernel: [117760.363412]  [<f8c1e452>]
jfs_create+0x132/0x320 [jfs]
Mar  9 03:01:37 Aula2Server kernel: [117760.378677]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:37 Aula2Server kernel: [117760.395540]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:37 Aula2Server kernel: [117760.410653]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:37 Aula2Server kernel: [117760.425342]
[handle_mm_fault+0x149/0xb80] handle_mm_fault+0x149/0xb80
Mar  9 03:01:37 Aula2Server kernel: [117760.440033]
[security_inode_permission+0x1c/0x20] security_inode_permission+0x1c/0x20
Mar  9 03:01:37 Aula2Server kernel: [117760.456505]
[vma_adjust+0x111/0x440] vma_adjust+0x111/0x440
Mar  9 03:01:37 Aula2Server kernel: [117760.470923]  [<c0145fb0>]
autoremove_wake_function+0x0/0x40
Mar  9 03:01:37 Aula2Server kernel: [117760.487480]
[do_page_fault+0x143/0x900] do_page_fault+0x143/0x900
Mar  9 03:01:37 Aula2Server kernel: [117760.501762]
[vfs_write+0x117/0x170] vfs_write+0x117/0x170
Mar  9 03:01:37 Aula2Server kernel: [117760.515830]
[sys_write+0x41/0x70] sys_write+0x41/0x70
Mar  9 03:01:37 Aula2Server kernel: [117760.531861]
[do_page_fault+0x0/0x900] do_page_fault+0x0/0x900
Mar  9 03:01:37 Aula2Server kernel: [117760.546088]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:37 Aula2Server kernel: [117760.560539]  =======================
Mar  9 03:01:38 Aula2Server kernel: [117760.865960] ------------[ cut
here ]------------
Mar  9 03:01:38 Aula2Server kernel: [117760.880270] kernel BUG at
/build/buildd/linux-2.6.24/arch/x86/mm/highmem_32.c:42!
Mar  9 03:01:38 Aula2Server kernel: [117760.894866] invalid opcode: 0000
[#8] SMP
Mar  9 03:01:38 Aula2Server kernel: [117760.909619] Modules linked in:
xt_multiport video output sbs sbshc container dock battery w83627ehf
hwmon_vid iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop
ipv6 sn9c102 compat_ioctl32 gspca videodev v4l2_common v4l1_compat
snd_hda_intel snd_hwdep snd_pcm_oss snd_pcm snd_page_alloc snd_mixer_oss
sky2 snd_seq_dummy snd_seq_oss psmouse snd_seq_midi serio_raw
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device shpchp
button evdev pci_hotplug snd pcspkr parport_pc parport soundcore
intel_agp agpgart jfs sr_mod cdrom pata_acpi ata_piix usbhid hid
usb_storage libusual sg sd_mod ahci ata_generic pata_it821x libata
floppy scsi_mod ehci_hcd uhci_hcd usbcore raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
processor fan fuse vesafb fbcon tileblit font bitblit softcursor
Mar  9 03:01:38 Aula2Server kernel: [117761.015060]
Mar  9 03:01:38 Aula2Server kernel: [117761.033332] Pid: 14625, comm:
zma Tainted: G      D (2.6.24-23-server #1)
Mar  9 03:01:38 Aula2Server kernel: [117761.052176] EIP:
0060:[kmap_atomic_prot+0x90/0x130] EFLAGS: 00010206 CPU: 0
Mar  9 03:01:38 Aula2Server kernel: [117761.070838] EIP is at
kmap_atomic_prot+0x90/0x130
Mar  9 03:01:38 Aula2Server kernel: [117761.089622] EAX: 7d1fc163 EBX:
00000007 ECX: c1fa2820 EDX: 00000000
Mar  9 03:01:38 Aula2Server kernel: [117761.108417] ESI: 00000163 EDI:
80000000 EBP: f54131f4 ESP: e8455e64
Mar  9 03:01:38 Aula2Server kernel: [117761.127205]  DS: 007b ES: 007b
FS: 00d8 GS: 0033 SS: 0068
Mar  9 03:01:38 Aula2Server kernel: [117761.146295] Process zma (pid:
14625, ti=e8454000 task=e84505c0 task.ti=e8454000)
Mar  9 03:01:38 Aula2Server kernel: [117761.146774] Stack: 0000001c
00000004 fffff000 00000038 00000007 80000000 7d141067 f54131c0
Mar  9 03:01:38 Aula2Server kernel: [117761.166156]        f54131f4
c01261ec 00000163 80000000 f54131c0 c0183859 e8455f24 00006b1a
Mar  9 03:01:38 Aula2Server kernel: [117761.185777]        f7c70000
c01865d1 00000001 e8455f64 f50f0d80 c049a400 e582d6f8 f8c3eee0
Mar  9 03:01:38 Aula2Server kernel: [117761.205585] Call Trace:
Mar  9 03:01:38 Aula2Server kernel: [117761.243350]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:38 Aula2Server kernel: [117761.262171]
[handle_mm_fault+0x149/0xb80] handle_mm_fault+0x149/0xb80
Mar  9 03:01:38 Aula2Server kernel: [117761.280709]
[vma_adjust+0x111/0x440] vma_adjust+0x111/0x440
Mar  9 03:01:38 Aula2Server kernel: [117761.299168]  [<c0145fb0>]
autoremove_wake_function+0x0/0x40
Mar  9 03:01:38 Aula2Server kernel: [117761.317798]
[do_page_fault+0x143/0x900] do_page_fault+0x143/0x900
Mar  9 03:01:38 Aula2Server kernel: [117761.336112]
[vfs_write+0x117/0x170] vfs_write+0x117/0x170
Mar  9 03:01:38 Aula2Server kernel: [117761.354414]
[sys_write+0x41/0x70] sys_write+0x41/0x70
Mar  9 03:01:38 Aula2Server kernel: [117761.372570]
[do_page_fault+0x0/0x900] do_page_fault+0x0/0x900
Mar  9 03:01:38 Aula2Server kernel: [117761.390718]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:38 Aula2Server kernel: [117761.409085]  =======================
Mar  9 03:01:38 Aula2Server kernel: [117761.427241] Code: 14 40 8d 14 90
a1 20 a3 40 c0 01 da 89 54 24 10 c1 e2 03 89 54 24 0c 89 44 24 08 a1 28
43 4b c0 29 d0 8b 50 04 8b 00 85 c0 74 04 <0f> 0b eb fe 85 d2 75 f8 2b
0d 00 1e 50 c0 31 db c1 f9 05 0f a4
Mar  9 03:01:38 Aula2Server kernel: [117761.466675] EIP:
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130 SS:ESP
0068:e8455e64
Mar  9 03:01:38 Aula2Server kernel: [117761.488424] ---[ end trace
1b2cab846758a6ac ]---
Mar  9 03:01:38 Aula2Server kernel: [117761.508516] note: zma[14625]
exited with preempt_count 1
Mar  9 03:01:38 Aula2Server kernel: [117761.528426] ------------[ cut
here ]------------
Mar  9 03:01:39 Aula2Server kernel: [117761.548236] kernel BUG at
/build/buildd/linux-2.6.24/arch/x86/mm/highmem_32.c:42!
Mar  9 03:01:39 Aula2Server kernel: [117761.568123] invalid opcode: 0000
[#9] SMP
Mar  9 03:01:39 Aula2Server kernel: [117761.588021] Modules linked in:
xt_multiport video output sbs sbshc container dock battery w83627ehf
hwmon_vid iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop
ipv6 sn9c102 compat_ioctl32 gspca videodev v4l2_common v4l1_compat
snd_hda_intel snd_hwdep snd_pcm_oss snd_pcm snd_page_alloc snd_mixer_oss
sky2 snd_seq_dummy snd_seq_oss psmouse snd_seq_midi serio_raw
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device shpchp
button evdev pci_hotplug snd pcspkr parport_pc parport soundcore
intel_agp agpgart jfs sr_mod cdrom pata_acpi ata_piix usbhid hid
usb_storage libusual sg sd_mod ahci ata_generic pata_it821x libata
floppy scsi_mod ehci_hcd uhci_hcd usbcore raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
processor fan fuse vesafb fbcon tileblit font bitblit softcursor
Mar  9 03:01:39 Aula2Server kernel: [117761.724904]
Mar  9 03:01:39 Aula2Server kernel: [117761.748599] Pid: 14625, comm:
zma Tainted: G      D (2.6.24-23-server #1)
Mar  9 03:01:39 Aula2Server kernel: [117761.772789] EIP:
0060:[kmap_atomic_prot+0x90/0x130] EFLAGS: 00010206 CPU: 0
Mar  9 03:01:39 Aula2Server kernel: [117761.797106] EIP is at
kmap_atomic_prot+0x90/0x130
Mar  9 03:01:39 Aula2Server kernel: [117761.821415] EAX: 7d1fc163 EBX:
00000007 ECX: c1fc97c0 EDX: 00000000
Mar  9 03:01:39 Aula2Server kernel: [117761.845919] ESI: 00000163 EDI:
80000000 EBP: 00000200 ESP: e8455c44
Mar  9 03:01:39 Aula2Server kernel: [117761.870426]  DS: 007b ES: 007b
FS: 00d8 GS: 0000 SS: 0068
Mar  9 03:01:39 Aula2Server kernel: [117761.894883] Process zma (pid:
14625, ti=e8454000 task=e84505c0 task.ti=e8454000)
Mar  9 03:01:39 Aula2Server kernel: [117761.895304] Stack: 00000046
00000046 fffff000 00000038 00000007 80000000 00000007 7e4be067
Mar  9 03:01:39 Aula2Server kernel: [117761.920262]        00000200
c01261ec 00000163 80000000 c1fc97c0 c0181978 c04b48d0 00000092
Mar  9 03:01:39 Aula2Server kernel: [117761.945487]        c1fc97cc
c04992a0 c200f2b0 00000000 f45ca000 e8455d14 00000000 00000000
Mar  9 03:01:39 Aula2Server kernel: [117761.970814] Call Trace:
Mar  9 03:01:39 Aula2Server kernel: [117762.020602]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:39 Aula2Server kernel: [117762.045612]
[unmap_vmas+0x2e8/0x740] unmap_vmas+0x2e8/0x740
Mar  9 03:01:39 Aula2Server kernel: [117762.070814]
[exit_mmap+0x79/0xf0] exit_mmap+0x79/0xf0
Mar  9 03:01:39 Aula2Server kernel: [117762.096008]  [mmput+0x1e/0x80]
mmput+0x1e/0x80
Mar  9 03:01:39 Aula2Server kernel: [117762.121138]
[do_exit+0x165/0x860] do_exit+0x165/0x860
Mar  9 03:01:39 Aula2Server kernel: [117762.146297]
[snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
Mar  9 03:01:39 Aula2Server kernel: [117762.171301]  [die+0x277/0x280]
die+0x277/0x280
Mar  9 03:01:39 Aula2Server kernel: [117762.196214]
[do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
Mar  9 03:01:39 Aula2Server kernel: [117762.221001]
[do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
Mar  9 03:01:39 Aula2Server kernel: [117762.245488]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:39 Aula2Server kernel: [117762.269474]  [<f8c1e452>]
jfs_create+0x132/0x320 [jfs]
Mar  9 03:01:39 Aula2Server kernel: [117762.292831]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:39 Aula2Server kernel: [117762.315554]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:39 Aula2Server kernel: [117762.337675]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:39 Aula2Server kernel: [117762.359032]
[handle_mm_fault+0x149/0xb80] handle_mm_fault+0x149/0xb80
Mar  9 03:01:39 Aula2Server kernel: [117762.379845]
[vma_adjust+0x111/0x440] vma_adjust+0x111/0x440
Mar  9 03:01:39 Aula2Server kernel: [117762.400789]  [<c0145fb0>]
autoremove_wake_function+0x0/0x40
Mar  9 03:01:39 Aula2Server kernel: [117762.421568]
[do_page_fault+0x143/0x900] do_page_fault+0x143/0x900
Mar  9 03:01:39 Aula2Server kernel: [117762.442194]
[vfs_write+0x117/0x170] vfs_write+0x117/0x170
Mar  9 03:01:39 Aula2Server kernel: [117762.462746]
[sys_write+0x41/0x70] sys_write+0x41/0x70
Mar  9 03:01:39 Aula2Server kernel: [117762.483071]
[do_page_fault+0x0/0x900] do_page_fault+0x0/0x900
Mar  9 03:01:39 Aula2Server kernel: [117762.503576]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:39 Aula2Server kernel: [117762.523800]  =======================
Mar  9 03:01:39 Aula2Server kernel: [117762.543746] Code: 14 40 8d 14 90
a1 20 a3 40 c0 01 da 89 54 24 10 c1 e2 03 89 54 24 0c 89 44 24 08 a1 28
43 4b c0 29 d0 8b 50 04 8b 00 85 c0 74 04 <0f> 0b eb fe 85 d2 75 f8 2b
0d 00 1e 50 c0 31 db c1 f9 05 0f a4
Mar  9 03:01:39 Aula2Server kernel: [117762.585824] EIP:
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130 SS:ESP
0068:e8455c44
Mar  9 03:01:39 Aula2Server kernel: [117762.609146] ---[ end trace
1b2cab846758a6ac ]---
Mar  9 03:01:39 Aula2Server kernel: [117762.630878] Fixing recursive
fault but reboot is needed!
Mar  9 03:01:39 Aula2Server kernel: [117762.653707] BUG: scheduling
while atomic: zma/14625/0x00000002
Mar  9 03:01:39 Aula2Server kernel: [117762.674652] Pid: 14625, comm:
zma Tainted: G      D 2.6.24-23-server #1
Mar  9 03:01:39 Aula2Server kernel: [117762.697808]
[jbd:schedule+0x582/0x6b0] schedule+0x582/0x630
Mar  9 03:01:39 Aula2Server kernel: [117762.718935]
[do_exit+0x750/0x860] do_exit+0x750/0x860
Mar  9 03:01:39 Aula2Server kernel: [117762.741766]
[snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
Mar  9 03:01:39 Aula2Server kernel: [117762.762696]  [die+0x277/0x280]
die+0x277/0x280
Mar  9 03:01:39 Aula2Server kernel: [117762.785560]
[do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
Mar  9 03:01:39 Aula2Server kernel: [117762.806511]
[do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
Mar  9 03:01:39 Aula2Server kernel: [117762.827454]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:39 Aula2Server kernel: [117762.850366]
[scsi_mod:blk_run_queue+0x37/0x240] blk_run_queue+0x37/0x80
Mar  9 03:01:39 Aula2Server kernel: [117762.870999]  [<f8af9a40>]
scsi_next_command+0x30/0x50 [scsi_mod]
Mar  9 03:01:39 Aula2Server kernel: [117762.892988]  [<f8af9bcb>]
scsi_end_request+0xab/0xe0 [scsi_mod]
Mar  9 03:01:39 Aula2Server kernel: [117762.914837]  [<f8afa8b9>]
scsi_io_completion+0xa9/0x3d0 [scsi_mod]
Mar  9 03:01:39 Aula2Server kernel: [117762.934645]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:39 Aula2Server kernel: [117762.954395]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:39 Aula2Server kernel: [117762.976152]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:39 Aula2Server kernel: [117762.995607]
[unmap_vmas+0x2e8/0x740] unmap_vmas+0x2e8/0x740
Mar  9 03:01:39 Aula2Server kernel: [117763.016647]
[exit_mmap+0x79/0xf0] exit_mmap+0x79/0xf0
Mar  9 03:01:39 Aula2Server kernel: [117763.035223]  [mmput+0x1e/0x80]
mmput+0x1e/0x80
Mar  9 03:01:39 Aula2Server kernel: [117763.053258]
[do_exit+0x165/0x860] do_exit+0x165/0x860
Mar  9 03:01:39 Aula2Server kernel: [117763.072400]
[snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
Mar  9 03:01:39 Aula2Server kernel: [117763.089140]  [die+0x277/0x280]
die+0x277/0x280
Mar  9 03:01:39 Aula2Server kernel: [117763.106854]
[do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
Mar  9 03:01:39 Aula2Server kernel: [117763.122295]
[do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
Mar  9 03:01:39 Aula2Server kernel: [117763.137510]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:39 Aula2Server kernel: [117763.154535]  [<f8c1e452>]
jfs_create+0x132/0x320 [jfs]
Mar  9 03:01:39 Aula2Server kernel: [117763.169697]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:39 Aula2Server kernel: [117763.184564]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:01:39 Aula2Server kernel: [117763.201417]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:01:39 Aula2Server kernel: [117763.216275]
[handle_mm_fault+0x149/0xb80] handle_mm_fault+0x149/0xb80
Mar  9 03:01:40 Aula2Server kernel: [117763.230928]
[vma_adjust+0x111/0x440] vma_adjust+0x111/0x440
Mar  9 03:01:40 Aula2Server kernel: [117763.245559]  [<c0145fb0>]
autoremove_wake_function+0x0/0x40
Mar  9 03:01:40 Aula2Server kernel: [117763.261959]
[do_page_fault+0x143/0x900] do_page_fault+0x143/0x900
Mar  9 03:01:40 Aula2Server kernel: [117763.276175]
[vfs_write+0x117/0x170] vfs_write+0x117/0x170
Mar  9 03:01:40 Aula2Server kernel: [117763.292312]
[sys_write+0x41/0x70] sys_write+0x41/0x70
Mar  9 03:01:40 Aula2Server kernel: [117763.306266]
[do_page_fault+0x0/0x900] do_page_fault+0x0/0x900
Mar  9 03:01:40 Aula2Server kernel: [117763.320203]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:01:40 Aula2Server kernel: [117763.335856]  =======================
Mar  9 03:01:52 Aula2Server zmc_dvideo0[6032]: WAR [Buffer overrun at
index 15, slow down capture, speed up analysis or increase ring buffer size]
Mar  9 03:03:20 Aula2Server zmc_dvideo0[6032]: WAR [Buffer overrun at
index 15, slow down capture, speed up analysis or increase ring buffer size]
Mar  9 03:11:11 Aula2Server zmc_dvideo0[6032]: WAR [Buffer overrun at
index 15, slow down capture, speed up analysis or increase ring buffer size]
Mar  9 03:18:48 Aula2Server zmc_dvideo0[6032]: WAR [Buffer overrun at
index 15, slow down capture, speed up analysis or increase ring buffer size]
Mar  9 03:19:26 Aula2Server kernel: [118828.714570] ------------[ cut
here ]------------
Mar  9 03:19:26 Aula2Server kernel: [118828.728613] kernel BUG at
/build/buildd/linux-2.6.24/arch/x86/mm/highmem_32.c:42!
Mar  9 03:19:26 Aula2Server kernel: [118828.742890] invalid opcode: 0000
[#10] SMP
Mar  9 03:19:26 Aula2Server kernel: [118828.757383] Modules linked in:
xt_multiport video output sbs sbshc container dock battery w83627ehf
hwmon_vid iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop
ipv6 sn9c102 compat_ioctl32 gspca videodev v4l2_common v4l1_compat
snd_hda_intel snd_hwdep snd_pcm_oss snd_pcm snd_page_alloc snd_mixer_oss
sky2 snd_seq_dummy snd_seq_oss psmouse snd_seq_midi serio_raw
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device shpchp
button evdev pci_hotplug snd pcspkr parport_pc parport soundcore
intel_agp agpgart jfs sr_mod cdrom pata_acpi ata_piix usbhid hid
usb_storage libusual sg sd_mod ahci ata_generic pata_it821x libata
floppy scsi_mod ehci_hcd uhci_hcd usbcore raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
processor fan fuse vesafb fbcon tileblit font bitblit softcursor
Mar  9 03:19:26 Aula2Server kernel: [118828.860940]
Mar  9 03:19:26 Aula2Server kernel: [118828.879010] Pid: 5992, comm:
smartd Tainted: G      D (2.6.24-23-server #1)
Mar  9 03:19:26 Aula2Server kernel: [118828.897638] EIP:
0060:[kmap_atomic_prot+0x90/0x130] EFLAGS: 00010206 CPU: 0
Mar  9 03:19:26 Aula2Server kernel: [118828.916236] EIP is at
kmap_atomic_prot+0x90/0x130
Mar  9 03:19:26 Aula2Server kernel: [118828.935010] EAX: 7d1fc163 EBX:
00000007 ECX: c1fcb6c0 EDX: 00000000
Mar  9 03:19:26 Aula2Server kernel: [118828.953769] ESI: 00000163 EDI:
80000000 EBP: f750fab4 ESP: dfc41c94
Mar  9 03:19:26 Aula2Server kernel: [118828.972488]  DS: 007b ES: 007b
FS: 00d8 GS: 0033 SS: 0068
Mar  9 03:19:26 Aula2Server kernel: [118828.991413] Process smartd (pid:
5992, ti=dfc40000 task=f7051140 task.ti=dfc40000)
Mar  9 03:19:26 Aula2Server kernel: [118828.991898] Stack: df8cd020
c02144ab fffff000 00000038 00000007 80000000 7e5b6067 f750fa80
Mar  9 03:19:26 Aula2Server kernel: [118829.011172]        f750fab4
c01261ec 00000163 80000000 f750fa80 c0183859 00000000 00000001
Mar  9 03:19:26 Aula2Server kernel: [118829.030681]        f7492480
00000000 f64ddcc0 f74c0d80 00000000 c049a400 00000000 00000000
Mar  9 03:19:26 Aula2Server kernel: [118829.050571] Call Trace:
Mar  9 03:19:26 Aula2Server kernel: [118829.088873]
[__freed_request+0xab/0xc0] __freed_request+0xab/0xc0
Mar  9 03:19:26 Aula2Server kernel: [118829.107914]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:19:26 Aula2Server kernel: [118829.126509]
[handle_mm_fault+0x149/0xb80] handle_mm_fault+0x149/0xb80
Mar  9 03:19:26 Aula2Server kernel: [118829.145019]
[sd_mod:scsi_cmd_ioctl+0xb6/0x61c0] scsi_cmd_ioctl+0xb6/0x480
Mar  9 03:19:26 Aula2Server kernel: [118829.163565]
[unix_dgram_sendmsg+0x459/0x500] unix_dgram_sendmsg+0x459/0x500
Mar  9 03:19:26 Aula2Server kernel: [118829.181901]
[__d_lookup+0x8c/0x120] __d_lookup+0x8c/0x120
Mar  9 03:19:26 Aula2Server kernel: [118829.200274]
[do_page_fault+0x143/0x900] do_page_fault+0x143/0x900
Mar  9 03:19:26 Aula2Server kernel: [118829.218351]
[do_lookup+0x67/0x1c0] do_lookup+0x67/0x1c0
Mar  9 03:19:26 Aula2Server kernel: [118829.236418]
[permission+0x97/0x120] permission+0x97/0x120
Mar  9 03:19:26 Aula2Server kernel: [118829.254696]
[do_page_fault+0x0/0x900] do_page_fault+0x0/0x900
Mar  9 03:19:26 Aula2Server kernel: [118829.272832]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:19:26 Aula2Server kernel: [118829.291165]
[do_execve+0x28/0x1d0] do_execve+0x28/0x1d0
Mar  9 03:19:26 Aula2Server kernel: [118829.309379]
[file_read_actor+0x3b/0x100] file_read_actor+0x3b/0x100
Mar  9 03:19:26 Aula2Server kernel: [118829.327701]
[do_generic_mapping_read+0x377/0x480] do_generic_mapping_read+0x377/0x480
Mar  9 03:19:26 Aula2Server kernel: [118829.346164]
[file_read_actor+0x0/0x100] file_read_actor+0x0/0x100
Mar  9 03:19:26 Aula2Server kernel: [118829.364430]
[ext3:generic_file_aio_read+0x10c/0x6e0] generic_file_aio_read+0x10c/0x1b0
Mar  9 03:19:26 Aula2Server kernel: [118829.382891]
[file_read_actor+0x0/0x100] file_read_actor+0x0/0x100
Mar  9 03:19:26 Aula2Server kernel: [118829.401140]
[ext3:do_sync_read+0xd5/0xb90] do_sync_read+0xd5/0x120
Mar  9 03:19:26 Aula2Server kernel: [118829.419398]  [<c0145fb0>]
autoremove_wake_function+0x0/0x40
Mar  9 03:19:26 Aula2Server kernel: [118829.437739]  [<c019a400>]
do_sync_read+0x0/0x120
Mar  9 03:19:26 Aula2Server kernel: [118829.456009]
[vfs_read+0xb7/0x160] vfs_read+0xb7/0x160
Mar  9 03:19:26 Aula2Server kernel: [118829.474438]
[sys_read+0x41/0x70] sys_read+0x41/0x70
Mar  9 03:19:26 Aula2Server kernel: [118829.492611]
[sysenter_past_esp+0x6b/0xa1] sysenter_past_esp+0x6b/0xa1
Mar  9 03:19:26 Aula2Server kernel: [118829.511020]
[rt_mutex_slowunlock+0x60/0x1c0] rt_mutex_slowunlock+0x60/0x1c0
Mar  9 03:19:26 Aula2Server kernel: [118829.529366]  =======================
Mar  9 03:19:26 Aula2Server kernel: [118829.547663] Code: 14 40 8d 14 90
a1 20 a3 40 c0 01 da 89 54 24 10 c1 e2 03 89 54 24 0c 89 44 24 08 a1 28
43 4b c0 29 d0 8b 50 04 8b 00 85 c0 74 04 <0f> 0b eb fe 85 d2 75 f8 2b
0d 00 1e 50 c0 31 db c1 f9 05 0f a4
Mar  9 03:19:26 Aula2Server kernel: [118829.586982] EIP:
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130 SS:ESP
0068:dfc41c94
Mar  9 03:19:26 Aula2Server kernel: [118829.665174] ---[ end trace
1b2cab846758a6ac ]---
Mar  9 03:19:26 Aula2Server kernel: [118829.685134] note: smartd[5992]
exited with preempt_count 1
Mar  9 03:19:28 Aula2Server kernel: [118829.707531] ------------[ cut
here ]------------
Mar  9 03:19:28 Aula2Server kernel: [118829.728058] kernel BUG at
/build/buildd/linux-2.6.24/arch/x86/mm/highmem_32.c:42!
Mar  9 03:19:28 Aula2Server kernel: [118829.748435] invalid opcode: 0000
[#11] SMP
Mar  9 03:19:28 Aula2Server kernel: [118829.768920] Modules linked in:
xt_multiport video output sbs sbshc container dock battery w83627ehf
hwmon_vid iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop
ipv6 sn9c102 compat_ioctl32 gspca videodev v4l2_common v4l1_compat
snd_hda_intel snd_hwdep snd_pcm_oss snd_pcm snd_page_alloc snd_mixer_oss
sky2 snd_seq_dummy snd_seq_oss psmouse snd_seq_midi serio_raw
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device shpchp
button evdev pci_hotplug snd pcspkr parport_pc parport soundcore
intel_agp agpgart jfs sr_mod cdrom pata_acpi ata_piix usbhid hid
usb_storage libusual sg sd_mod ahci ata_generic pata_it821x libata
floppy scsi_mod ehci_hcd uhci_hcd usbcore raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
processor fan fuse vesafb fbcon tileblit font bitblit softcursor
Mar  9 03:19:28 Aula2Server kernel: [118829.908079]
Mar  9 03:19:28 Aula2Server kernel: [118829.932062] Pid: 5992, comm:
smartd Tainted: G      D (2.6.24-23-server #1)
Mar  9 03:19:28 Aula2Server kernel: [118829.956524] EIP:
0060:[kmap_atomic_prot+0x90/0x130] EFLAGS: 00010206 CPU: 0
Mar  9 03:19:28 Aula2Server kernel: [118829.981037] EIP is at
kmap_atomic_prot+0x90/0x130
Mar  9 03:19:28 Aula2Server kernel: [118830.005471] EAX: 7d1fc163 EBX:
00000007 ECX: c1ff02a0 EDX: 00000000
Mar  9 03:19:28 Aula2Server kernel: [118830.029781] ESI: 00000163 EDI:
80000000 EBP: 00000200 ESP: dfc41a74
Mar  9 03:19:28 Aula2Server kernel: [118830.054029]  DS: 007b ES: 007b
FS: 00d8 GS: 0000 SS: 0068
Mar  9 03:19:28 Aula2Server kernel: [118830.077750] Process smartd (pid:
5992, ti=dfc40000 task=f7051140 task.ti=dfc40000)
Mar  9 03:19:28 Aula2Server kernel: [118830.078243] Stack: 00000046
00000046 fffff000 00000038 00000007 80000000 00000007 7f815067
Mar  9 03:19:28 Aula2Server kernel: [118830.101797]        00000200
c01261ec 00000163 80000000 c1ff02a0 c0181978 c04b48d2 00000092
Mar  9 03:19:28 Aula2Server kernel: [118830.124963]        c1ff02ac
c04992a0 c200f2b0 00000000 f70718f0 dfc41b44 00000000 00000000
Mar  9 03:19:28 Aula2Server kernel: [118830.147620] Call Trace:
Mar  9 03:19:28 Aula2Server kernel: [118830.190405]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:19:28 Aula2Server kernel: [118830.211898]
[unmap_vmas+0x2e8/0x740] unmap_vmas+0x2e8/0x740
Mar  9 03:19:28 Aula2Server kernel: [118830.233198]
[exit_mmap+0x79/0xf0] exit_mmap+0x79/0xf0
Mar  9 03:19:28 Aula2Server kernel: [118830.254239]  [mmput+0x1e/0x80]
mmput+0x1e/0x80
Mar  9 03:19:28 Aula2Server kernel: [118830.275168]
[do_exit+0x165/0x860] do_exit+0x165/0x860
Mar  9 03:19:28 Aula2Server kernel: [118830.295975]
[snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
Mar  9 03:19:28 Aula2Server kernel: [118830.316787]  [die+0x277/0x280]
die+0x277/0x280
Mar  9 03:19:28 Aula2Server kernel: [118830.337501]
[do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
Mar  9 03:19:28 Aula2Server kernel: [118830.357889]
[do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
Mar  9 03:19:28 Aula2Server kernel: [118830.377964]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:19:28 Aula2Server kernel: [118830.397895]
[elv_insert+0x108/0x230] elv_insert+0x108/0x230
Mar  9 03:19:28 Aula2Server kernel: [118830.417908]
[scsi_mod:blk_plug_device+0x47/0x180] blk_plug_device+0x47/0xc0
Mar  9 03:19:28 Aula2Server kernel: [118830.437540]
[wait_for_common+0x7d/0x130] wait_for_common+0x7d/0x130
Mar  9 03:19:28 Aula2Server kernel: [118830.457088]  [<c012b180>]
default_wake_function+0x0/0x10
Mar  9 03:19:28 Aula2Server kernel: [118830.476861]
[scsi_mod:blk_execute_rq+0x7c/0x330] blk_execute_rq+0x7c/0xe0
Mar  9 03:19:28 Aula2Server kernel: [118830.496447]
[blk_end_sync_rq+0x0/0x30] blk_end_sync_rq+0x0/0x30
Mar  9 03:19:28 Aula2Server kernel: [118830.515967]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:19:28 Aula2Server kernel: [118830.535483]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:19:28 Aula2Server kernel: [118830.555080]
[__freed_request+0xab/0xc0] __freed_request+0xab/0xc0
Mar  9 03:19:28 Aula2Server kernel: [118830.574534]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:19:28 Aula2Server kernel: [118830.593980]
[handle_mm_fault+0x149/0xb80] handle_mm_fault+0x149/0xb80
Mar  9 03:19:28 Aula2Server kernel: [118830.613748]
[sd_mod:scsi_cmd_ioctl+0xb6/0x61c0] scsi_cmd_ioctl+0xb6/0x480
Mar  9 03:19:28 Aula2Server kernel: [118830.633287]
[unix_dgram_sendmsg+0x459/0x500] unix_dgram_sendmsg+0x459/0x500
Mar  9 03:19:28 Aula2Server kernel: [118830.652896]
[__d_lookup+0x8c/0x120] __d_lookup+0x8c/0x120
Mar  9 03:19:28 Aula2Server kernel: [118830.672689]
[do_page_fault+0x143/0x900] do_page_fault+0x143/0x900
Mar  9 03:19:28 Aula2Server kernel: [118830.692343]
[do_lookup+0x67/0x1c0] do_lookup+0x67/0x1c0
Mar  9 03:19:28 Aula2Server kernel: [118830.711889]
[permission+0x97/0x120] permission+0x97/0x120
Mar  9 03:19:28 Aula2Server kernel: [118830.731397]
[do_page_fault+0x0/0x900] do_page_fault+0x0/0x900
Mar  9 03:19:28 Aula2Server kernel: [118830.751023]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:19:28 Aula2Server kernel: [118830.770412]
[do_execve+0x28/0x1d0] do_execve+0x28/0x1d0
Mar  9 03:19:28 Aula2Server kernel: [118830.789770]
[file_read_actor+0x3b/0x100] file_read_actor+0x3b/0x100
Mar  9 03:19:28 Aula2Server kernel: [118830.809301]
[do_generic_mapping_read+0x377/0x480] do_generic_mapping_read+0x377/0x480
Mar  9 03:19:28 Aula2Server kernel: [118830.828689]
[file_read_actor+0x0/0x100] file_read_actor+0x0/0x100
Mar  9 03:19:28 Aula2Server kernel: [118830.848120]
[ext3:generic_file_aio_read+0x10c/0x6e0] generic_file_aio_read+0x10c/0x1b0
Mar  9 03:19:28 Aula2Server kernel: [118830.867876]
[file_read_actor+0x0/0x100] file_read_actor+0x0/0x100
Mar  9 03:19:28 Aula2Server kernel: [118830.887480]
[ext3:do_sync_read+0xd5/0xb90] do_sync_read+0xd5/0x120
Mar  9 03:19:28 Aula2Server kernel: [118830.907058]  [<c0145fb0>]
autoremove_wake_function+0x0/0x40
Mar  9 03:19:28 Aula2Server kernel: [118830.926690]  [<c019a400>]
do_sync_read+0x0/0x120
Mar  9 03:19:28 Aula2Server kernel: [118830.945966]
[vfs_read+0xb7/0x160] vfs_read+0xb7/0x160
Mar  9 03:19:28 Aula2Server kernel: [118830.964563]
[sys_read+0x41/0x70] sys_read+0x41/0x70
Mar  9 03:19:28 Aula2Server kernel: [118830.982986]
[sysenter_past_esp+0x6b/0xa1] sysenter_past_esp+0x6b/0xa1
Mar  9 03:19:28 Aula2Server kernel: [118831.001099]
[rt_mutex_slowunlock+0x60/0x1c0] rt_mutex_slowunlock+0x60/0x1c0
Mar  9 03:19:28 Aula2Server kernel: [118831.019169]  =======================
Mar  9 03:19:28 Aula2Server kernel: [118831.037284] Code: 14 40 8d 14 90
a1 20 a3 40 c0 01 da 89 54 24 10 c1 e2 03 89 54 24 0c 89 44 24 08 a1 28
43 4b c0 29 d0 8b 50 04 8b 00 85 c0 74 04 <0f> 0b eb fe 85 d2 75 f8 2b
0d 00 1e 50 c0 31 db c1 f9 05 0f a4
Mar  9 03:19:28 Aula2Server kernel: [118831.075434] EIP:
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130 SS:ESP
0068:dfc41a74
Mar  9 03:19:28 Aula2Server kernel: [118831.096069] ---[ end trace
1b2cab846758a6ac ]---
Mar  9 03:19:28 Aula2Server kernel: [118831.114138] Fixing recursive
fault but reboot is needed!
Mar  9 03:19:28 Aula2Server megatec[6322]: Communications with UPS lost:
No status from UPS.
Mar  9 03:19:28 Aula2Server kernel: [118831.134413] BUG: scheduling
while atomic: smartd/5992/0x00000002
Mar  9 03:19:28 Aula2Server kernel: [118831.151519] Pid: 5992, comm:
smartd Tainted: G      D 2.6.24-23-server #1
Mar  9 03:19:28 Aula2Server kernel: [118831.167952]
[jbd:schedule+0x582/0x6b0] schedule+0x582/0x630
Mar  9 03:19:28 Aula2Server kernel: [118831.185965]
[do_exit+0x750/0x860] do_exit+0x750/0x860
Mar  9 03:19:28 Aula2Server kernel: [118831.201821]
[snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
Mar  9 03:19:28 Aula2Server kernel: [118831.217372]  [die+0x277/0x280]
die+0x277/0x280
Mar  9 03:19:28 Aula2Server kernel: [118831.234910]
[do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
Mar  9 03:19:28 Aula2Server kernel: [118831.250180]
[do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
Mar  9 03:19:28 Aula2Server kernel: [118831.265366]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:19:28 Aula2Server kernel: [118831.282653]  [<f8abb35f>]
uhci_irq+0x8f/0x160 [uhci_hcd]
Mar  9 03:19:28 Aula2Server kernel: [118831.297787]  [<f9160ffc>]
sky2_poll+0x4c/0xd10 [sky2]
Mar  9 03:19:28 Aula2Server kernel: [118831.314862]  [<f9160ffc>]
sky2_poll+0x4c/0xd10 [sky2]
Mar  9 03:19:28 Aula2Server kernel: [118831.329419]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:19:28 Aula2Server kernel: [118831.343936]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:19:28 Aula2Server kernel: [118831.360489]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:19:28 Aula2Server kernel: [118831.374589]
[unmap_vmas+0x2e8/0x740] unmap_vmas+0x2e8/0x740
Mar  9 03:19:28 Aula2Server kernel: [118831.388636]
[exit_mmap+0x79/0xf0] exit_mmap+0x79/0xf0
Mar  9 03:19:28 Aula2Server kernel: [118831.404779]  [mmput+0x1e/0x80]
mmput+0x1e/0x80
Mar  9 03:19:28 Aula2Server kernel: [118831.418845]
[do_exit+0x165/0x860] do_exit+0x165/0x860
Mar  9 03:19:28 Aula2Server kernel: [118831.432775]
[snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
Mar  9 03:19:28 Aula2Server kernel: [118831.448860]  [die+0x277/0x280]
die+0x277/0x280
Mar  9 03:19:28 Aula2Server kernel: [118831.462925]
[do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
Mar  9 03:19:28 Aula2Server kernel: [118831.476985]
[do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
Mar  9 03:19:28 Aula2Server kernel: [118831.490843]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:19:28 Aula2Server kernel: [118831.507058]
[elv_insert+0x108/0x230] elv_insert+0x108/0x230
Mar  9 03:19:28 Aula2Server kernel: [118831.521197]
[scsi_mod:blk_plug_device+0x47/0x180] blk_plug_device+0x47/0xc0
Mar  9 03:19:28 Aula2Server kernel: [118831.535326]
[wait_for_common+0x7d/0x130] wait_for_common+0x7d/0x130
Mar  9 03:19:28 Aula2Server kernel: [118831.551373]  [<c012b180>]
default_wake_function+0x0/0x10
Mar  9 03:19:28 Aula2Server kernel: [118831.565606]
[scsi_mod:blk_execute_rq+0x7c/0x330] blk_execute_rq+0x7c/0xe0
Mar  9 03:19:28 Aula2Server kernel: [118831.579796]
[blk_end_sync_rq+0x0/0x30] blk_end_sync_rq+0x0/0x30
Mar  9 03:19:28 Aula2Server kernel: [118831.595813]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:19:28 Aula2Server kernel: [118831.609964]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:19:28 Aula2Server kernel: [118831.624153]
[__freed_request+0xab/0xc0] __freed_request+0xab/0xc0
Mar  9 03:19:28 Aula2Server kernel: [118831.638334]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:19:28 Aula2Server kernel: [118831.654497]
[handle_mm_fault+0x149/0xb80] handle_mm_fault+0x149/0xb80
Mar  9 03:19:28 Aula2Server kernel: [118831.668743]
[sd_mod:scsi_cmd_ioctl+0xb6/0x61c0] scsi_cmd_ioctl+0xb6/0x480
Mar  9 03:19:28 Aula2Server kernel: [118831.684997]
[unix_dgram_sendmsg+0x459/0x500] unix_dgram_sendmsg+0x459/0x500
Mar  9 03:19:28 Aula2Server kernel: [118831.699113]
[__d_lookup+0x8c/0x120] __d_lookup+0x8c/0x120
Mar  9 03:19:28 Aula2Server kernel: [118831.713328]
[do_page_fault+0x143/0x900] do_page_fault+0x143/0x900
Mar  9 03:19:28 Aula2Server kernel: [118831.729577]
[do_lookup+0x67/0x1c0] do_lookup+0x67/0x1c0
Mar  9 03:19:28 Aula2Server kernel: [118831.743582]
[permission+0x97/0x120] permission+0x97/0x120
Mar  9 03:19:28 Aula2Server kernel: [118831.757748]
[do_page_fault+0x0/0x900] do_page_fault+0x0/0x900
Mar  9 03:19:28 Aula2Server kernel: [118831.773970]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:19:28 Aula2Server kernel: [118831.788143]
[do_execve+0x28/0x1d0] do_execve+0x28/0x1d0
Mar  9 03:19:28 Aula2Server kernel: [118831.802110]
[file_read_actor+0x3b/0x100] file_read_actor+0x3b/0x100
Mar  9 03:19:28 Aula2Server kernel: [118831.818397]
[do_generic_mapping_read+0x377/0x480] do_generic_mapping_read+0x377/0x480
Mar  9 03:19:28 Aula2Server kernel: [118831.832703]
[file_read_actor+0x0/0x100] file_read_actor+0x0/0x100
Mar  9 03:19:29 Aula2Server kernel: [118831.846821]
[ext3:generic_file_aio_read+0x10c/0x6e0] generic_file_aio_read+0x10c/0x1b0
Mar  9 03:19:29 Aula2Server kernel: [118831.861056]
[file_read_actor+0x0/0x100] file_read_actor+0x0/0x100
Mar  9 03:19:29 Aula2Server kernel: [118831.877384]
[ext3:do_sync_read+0xd5/0xb90] do_sync_read+0xd5/0x120
Mar  9 03:19:29 Aula2Server kernel: [118831.891610]  [<c0145fb0>]
autoremove_wake_function+0x0/0x40
Mar  9 03:19:29 Aula2Server kernel: [118831.905773]  [<c019a400>]
do_sync_read+0x0/0x120
Mar  9 03:19:29 Aula2Server kernel: [118831.922059]
[vfs_read+0xb7/0x160] vfs_read+0xb7/0x160
Mar  9 03:19:29 Aula2Server kernel: [118831.936237]
[sys_read+0x41/0x70] sys_read+0x41/0x70
Mar  9 03:19:29 Aula2Server kernel: [118831.950190]
[sysenter_past_esp+0x6b/0xa1] sysenter_past_esp+0x6b/0xa1
Mar  9 03:19:29 Aula2Server kernel: [118831.966453]
[rt_mutex_slowunlock+0x60/0x1c0] rt_mutex_slowunlock+0x60/0x1c0
Mar  9 03:19:29 Aula2Server kernel: [118831.980744]  =======================
Mar  9 03:19:30 Aula2Server megatec[6322]: Communications with UPS lost:
No status from UPS.
Mar  9 03:19:33 Aula2Server megatec[6322]: Communications with UPS
re-established
Mar  9 03:19:34 Aula2Server zmc_dvideo0[6032]: WAR [Buffer overrun at
index 15, slow down capture, speed up analysis or increase ring buffer size]
Mar  9 03:26:27 Aula2Server zmc_dvideo0[6032]: WAR [Buffer overrun at
index 15, slow down capture, speed up analysis or increase ring buffer size]
Mar  9 03:34:03 Aula2Server zmc_dvideo0[6032]: WAR [Buffer overrun at
index 15, slow down capture, speed up analysis or increase ring buffer size]
Mar  9 03:34:18 Aula2Server zmc_dvideo0[6032]: WAR [Buffer overrun at
index 15, slow down capture, speed up analysis or increase ring buffer size]
Mar  9 03:34:22 Aula2Server kernel: [119724.878890] ------------[ cut
here ]------------
Mar  9 03:34:22 Aula2Server kernel: [119724.893108] kernel BUG at
/build/buildd/linux-2.6.24/arch/x86/mm/highmem_32.c:42!
Mar  9 03:34:22 Aula2Server kernel: [119724.907279] invalid opcode: 0000
[#12] SMP
Mar  9 03:34:22 Aula2Server kernel: [119724.920950] Modules linked in:
xt_multiport video output sbs sbshc container dock battery w83627ehf
hwmon_vid iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop
ipv6 sn9c102 compat_ioctl32 gspca videodev v4l2_common v4l1_compat
snd_hda_intel snd_hwdep snd_pcm_oss snd_pcm snd_page_alloc snd_mixer_oss
sky2 snd_seq_dummy snd_seq_oss psmouse snd_seq_midi serio_raw
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device shpchp
button evdev pci_hotplug snd pcspkr parport_pc parport soundcore
intel_agp agpgart jfs sr_mod cdrom pata_acpi ata_piix usbhid hid
usb_storage libusual sg sd_mod ahci ata_generic pata_it821x libata
floppy scsi_mod ehci_hcd uhci_hcd usbcore raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
processor fan fuse vesafb fbcon tileblit font bitblit softcursor
Mar  9 03:34:22 Aula2Server kernel: [119725.015460]
Mar  9 03:34:22 Aula2Server kernel: [119725.031855] Pid: 8708, comm:
pickup Tainted: G      D (2.6.24-23-server #1)
Mar  9 03:34:22 Aula2Server kernel: [119725.048565] EIP:
0060:[kmap_atomic_prot+0x90/0x130] EFLAGS: 00210206 CPU: 0
Mar  9 03:34:22 Aula2Server kernel: [119725.065580] EIP is at
kmap_atomic_prot+0x90/0x130
Mar  9 03:34:22 Aula2Server kernel: [119725.082491] EAX: 7d1fc163 EBX:
00000007 ECX: c1fa3000 EDX: 00000000
Mar  9 03:34:22 Aula2Server kernel: [119725.099778] ESI: 00000163 EDI:
80000000 EBP: 00000200 ESP: ed47de80
Mar  9 03:34:22 Aula2Server kernel: [119725.117006]  DS: 007b ES: 007b
FS: 00d8 GS: 0000 SS: 0068
Mar  9 03:34:22 Aula2Server kernel: [119725.134285] Process pickup (pid:
8708, ti=ed47c000 task=e840c5c0 task.ti=ed47c000)
Mar  9 03:34:22 Aula2Server kernel: [119725.134769] Stack: ffffffeb
ed47df30 fffff000 00000038 00000007 80000000 00000007 7d180067
Mar  9 03:34:22 Aula2Server kernel: [119725.152335]        00000200
c01261ec 00000163 80000000 c1fa3000 c0181978 00000000 ed47dedc
Mar  9 03:34:22 Aula2Server kernel: [119725.170427]        c1fa300c
c04992a0 c200f2b0 00000000 f55ba898 ed47df50 00000000 00000000
Mar  9 03:34:22 Aula2Server kernel: [119725.188452] Call Trace:
Mar  9 03:34:22 Aula2Server kernel: [119725.224151]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:34:22 Aula2Server kernel: [119725.242508]
[unmap_vmas+0x2e8/0x740] unmap_vmas+0x2e8/0x740
Mar  9 03:34:22 Aula2Server kernel: [119725.260735]
[exit_mmap+0x79/0xf0] exit_mmap+0x79/0xf0
Mar  9 03:34:22 Aula2Server kernel: [119725.278903]  [mmput+0x1e/0x80]
mmput+0x1e/0x80
Mar  9 03:34:22 Aula2Server kernel: [119725.297214]
[do_exit+0x165/0x860] do_exit+0x165/0x860
Mar  9 03:34:22 Aula2Server kernel: [119725.315397]
[vfs_write+0x117/0x170] vfs_write+0x117/0x170
Mar  9 03:34:22 Aula2Server kernel: [119725.333805]
[do_group_exit+0x26/0x80] do_group_exit+0x26/0x80
Mar  9 03:34:22 Aula2Server kernel: [119725.352062]
[sysenter_past_esp+0x6b/0xa1] sysenter_past_esp+0x6b/0xa1
Mar  9 03:34:22 Aula2Server kernel: [119725.370484]  =======================
Mar  9 03:34:22 Aula2Server kernel: [119725.389012] Code: 14 40 8d 14 90
a1 20 a3 40 c0 01 da 89 54 24 10 c1 e2 03 89 54 24 0c 89 44 24 08 a1 28
43 4b c0 29 d0 8b 50 04 8b 00 85 c0 74 04 <0f> 0b eb fe 85 d2 75 f8 2b
0d 00 1e 50 c0 31 db c1 f9 05 0f a4
Mar  9 03:34:22 Aula2Server kernel: [119725.428129] EIP:
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130 SS:ESP
0068:ed47de80
Mar  9 03:34:22 Aula2Server kernel: [119725.506484] ---[ end trace
1b2cab846758a6ac ]---
Mar  9 03:34:23 Aula2Server kernel: [119725.528738] Fixing recursive
fault but reboot is needed!
Mar  9 03:34:23 Aula2Server kernel: [119725.548785] BUG: scheduling
while atomic: pickup/8708/0x00000001
Mar  9 03:34:23 Aula2Server kernel: [119725.570912] Pid: 8708, comm:
pickup Tainted: G      D 2.6.24-23-server #1
Mar  9 03:34:23 Aula2Server kernel: [119725.591248]
[jbd:schedule+0x582/0x6b0] schedule+0x582/0x630
Mar  9 03:34:23 Aula2Server kernel: [119725.613895]
[do_exit+0x750/0x860] do_exit+0x750/0x860
Mar  9 03:34:23 Aula2Server kernel: [119725.634289]
[snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
Mar  9 03:34:23 Aula2Server kernel: [119725.656546]  [die+0x277/0x280]
die+0x277/0x280
Mar  9 03:34:23 Aula2Server kernel: [119725.676661]
[do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
Mar  9 03:34:23 Aula2Server kernel: [119725.698784]
[do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
Mar  9 03:34:23 Aula2Server kernel: [119725.718767]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:34:23 Aula2Server kernel: [119725.738706]
[snd_hwdep:__wake_up+0x3e/0x1f10] __wake_up+0x3e/0x60
Mar  9 03:34:23 Aula2Server kernel: [119725.760858]
[sock_def_readable+0x78/0x80] sock_def_readable+0x78/0x80
Mar  9 03:34:23 Aula2Server kernel: [119725.780907]
[unix_stream_sendmsg+0x23a/0x3a0] unix_stream_sendmsg+0x23a/0x3a0
Mar  9 03:34:23 Aula2Server kernel: [119725.803030]
[unix_stream_sendmsg+0x189/0x3a0] unix_stream_sendmsg+0x189/0x3a0
Mar  9 03:34:23 Aula2Server kernel: [119725.822958]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:34:23 Aula2Server kernel: [119725.845235]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:34:23 Aula2Server kernel: [119725.865250]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:34:23 Aula2Server kernel: [119725.885322]
[unmap_vmas+0x2e8/0x740] unmap_vmas+0x2e8/0x740
Mar  9 03:34:23 Aula2Server kernel: [119725.907206]
[exit_mmap+0x79/0xf0] exit_mmap+0x79/0xf0
Mar  9 03:34:23 Aula2Server kernel: [119725.926969]  [mmput+0x1e/0x80]
mmput+0x1e/0x80
Mar  9 03:34:23 Aula2Server kernel: [119725.948618]
[do_exit+0x165/0x860] do_exit+0x165/0x860
Mar  9 03:34:23 Aula2Server kernel: [119725.970283]
[vfs_write+0x117/0x170] vfs_write+0x117/0x170
Mar  9 03:34:23 Aula2Server kernel: [119725.990071]
[do_group_exit+0x26/0x80] do_group_exit+0x26/0x80
Mar  9 03:34:23 Aula2Server kernel: [119726.009622]
[sysenter_past_esp+0x6b/0xa1] sysenter_past_esp+0x6b/0xa1
Mar  9 03:34:23 Aula2Server kernel: [119726.031206]  =======================
Mar  9 03:34:33 Aula2Server zmc_dvideo0[6032]: WAR [Buffer overrun at
index 15, slow down capture, speed up analysis or increase ring buffer size]
Mar  9 03:34:48 Aula2Server zmc_dvideo0[6032]: WAR [Buffer overrun at
index 15, slow down capture, speed up analysis or increase ring buffer size]
Mar  9 03:34:58 Aula2Server kernel: [119760.575883] ------------[ cut
here ]------------
Mar  9 03:34:58 Aula2Server kernel: [119760.595575] kernel BUG at
/build/buildd/linux-2.6.24/arch/x86/mm/highmem_32.c:42!
Mar  9 03:34:58 Aula2Server kernel: [119760.615642] invalid opcode: 0000
[#13] SMP
Mar  9 03:34:58 Aula2Server kernel: [119760.635721] Modules linked in:
xt_multiport video output sbs sbshc container dock battery w83627ehf
hwmon_vid iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop
ipv6 sn9c102 compat_ioctl32 gspca videodev v4l2_common v4l1_compat
snd_hda_intel snd_hwdep snd_pcm_oss snd_pcm snd_page_alloc snd_mixer_oss
sky2 snd_seq_dummy snd_seq_oss psmouse snd_seq_midi serio_raw
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device shpchp
button evdev pci_hotplug snd pcspkr parport_pc parport soundcore
intel_agp agpgart jfs sr_mod cdrom pata_acpi ata_piix usbhid hid
usb_storage libusual sg sd_mod ahci ata_generic pata_it821x libata
floppy scsi_mod ehci_hcd uhci_hcd usbcore raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
processor fan fuse vesafb fbcon tileblit font bitblit softcursor
Mar  9 03:34:58 Aula2Server kernel: [119760.768988]
Mar  9 03:34:58 Aula2Server kernel: [119760.790232] Pid: 14897, comm:
smtp Tainted: G      D (2.6.24-23-server #1)
Mar  9 03:34:58 Aula2Server kernel: [119760.811267] EIP:
0060:[kmap_atomic_prot+0x90/0x130] EFLAGS: 00210206 CPU: 0
Mar  9 03:34:58 Aula2Server kernel: [119760.831739] EIP is at
kmap_atomic_prot+0x90/0x130
Mar  9 03:34:58 Aula2Server kernel: [119760.851799] EAX: 7d1fc163 EBX:
00000007 ECX: c1fcbc80 EDX: 00000000
Mar  9 03:34:58 Aula2Server kernel: [119760.871822] ESI: 00000163 EDI:
80000000 EBP: f54138f4 ESP: e8453e64
Mar  9 03:34:58 Aula2Server kernel: [119760.891746]  DS: 007b ES: 007b
FS: 00d8 GS: 0033 SS: 0068
Mar  9 03:34:58 Aula2Server kernel: [119760.911523] Process smtp (pid:
14897, ti=e8452000 task=f4d03700 task.ti=e8452000)
Mar  9 03:34:58 Aula2Server kernel: [119760.912007] Stack: e8453f1c
00000000 fffff000 00000038 00000007 80000000 7e5e4067 f54138c0
Mar  9 03:34:58 Aula2Server kernel: [119760.932409]        f54138f4
c01261ec 00000163 80000000 f54138c0 c0183859 0000000f 00000001
Mar  9 03:34:58 Aula2Server kernel: [119760.952723]        350002b6
00000000 f7da6800 c0425fa0 f7c44a00 c049a400 0000001c c0305165
Mar  9 03:34:58 Aula2Server kernel: [119760.973206] Call Trace:
Mar  9 03:34:58 Aula2Server kernel: [119761.013328]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:34:58 Aula2Server kernel: [119761.033327]
[handle_mm_fault+0x149/0xb80] handle_mm_fault+0x149/0xb80
Mar  9 03:34:58 Aula2Server kernel: [119761.053236]
[ipv6:inet_dgram_connect+0x35/0x120] inet_dgram_connect+0x35/0x80
Mar  9 03:34:58 Aula2Server kernel: [119761.073110]
[invalidate_inode_buffers+0xe/0xc0] invalidate_inode_buffers+0xe/0xc0
Mar  9 03:34:58 Aula2Server kernel: [119761.092959]
[ipv6:_spin_lock_bh+0x8/0x20] _spin_lock_bh+0x8/0x20
Mar  9 03:34:58 Aula2Server kernel: [119761.112622]
[do_page_fault+0x143/0x900] do_page_fault+0x143/0x900
Mar  9 03:34:58 Aula2Server kernel: [119761.132285]
[ext3:dput+0x1c/0xc90] dput+0x1c/0x100
Mar  9 03:34:58 Aula2Server kernel: [119761.152014]
[__fput+0x114/0x170] __fput+0x114/0x170
Mar  9 03:34:58 Aula2Server kernel: [119761.171708]
[fuse:mntput_no_expire+0x13/0x3ed0] mntput_no_expire+0x13/0x70
Mar  9 03:34:58 Aula2Server kernel: [119761.191395]
[do_page_fault+0x0/0x900] do_page_fault+0x0/0x900
Mar  9 03:34:58 Aula2Server kernel: [119761.211070]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:34:58 Aula2Server kernel: [119761.230928]  =======================
Mar  9 03:34:58 Aula2Server kernel: [119761.250528] Code: 14 40 8d 14 90
a1 20 a3 40 c0 01 da 89 54 24 10 c1 e2 03 89 54 24 0c 89 44 24 08 a1 28
43 4b c0 29 d0 8b 50 04 8b 00 85 c0 74 04 <0f> 0b eb fe 85 d2 75 f8 2b
0d 00 1e 50 c0 31 db c1 f9 05 0f a4
Mar  9 03:34:58 Aula2Server kernel: [119761.291922] EIP:
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130 SS:ESP
0068:e8453e64
Mar  9 03:34:58 Aula2Server kernel: [119761.314266] ---[ end trace
1b2cab846758a6ac ]---
Mar  9 03:34:58 Aula2Server kernel: [119761.334315] note: smtp[14897]
exited with preempt_count 1
Mar  9 03:34:58 Aula2Server kernel: [119761.354078] ------------[ cut
here ]------------
Mar  9 03:34:59 Aula2Server kernel: [119761.374329] kernel BUG at
/build/buildd/linux-2.6.24/arch/x86/mm/highmem_32.c:42!
Mar  9 03:34:59 Aula2Server kernel: [119761.394283] invalid opcode: 0000
[#14] SMP
Mar  9 03:34:59 Aula2Server kernel: [119761.414296] Modules linked in:
xt_multiport video output sbs sbshc container dock battery w83627ehf
hwmon_vid iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop
ipv6 sn9c102 compat_ioctl32 gspca videodev v4l2_common v4l1_compat
snd_hda_intel snd_hwdep snd_pcm_oss snd_pcm snd_page_alloc snd_mixer_oss
sky2 snd_seq_dummy snd_seq_oss psmouse snd_seq_midi serio_raw
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device shpchp
button evdev pci_hotplug snd pcspkr parport_pc parport soundcore
intel_agp agpgart jfs sr_mod cdrom pata_acpi ata_piix usbhid hid
usb_storage libusual sg sd_mod ahci ata_generic pata_it821x libata
floppy scsi_mod ehci_hcd uhci_hcd usbcore raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
processor fan fuse vesafb fbcon tileblit font bitblit softcursor
Mar  9 03:34:59 Aula2Server kernel: [119761.549755]
Mar  9 03:34:59 Aula2Server kernel: [119761.573237] Pid: 14897, comm:
smtp Tainted: G      D (2.6.24-23-server #1)
Mar  9 03:34:59 Aula2Server kernel: [119761.597164] EIP:
0060:[kmap_atomic_prot+0x90/0x130] EFLAGS: 00210206 CPU: 0
Mar  9 03:34:59 Aula2Server kernel: [119761.621150] EIP is at
kmap_atomic_prot+0x90/0x130
Mar  9 03:34:59 Aula2Server kernel: [119761.645114] EAX: 7d1fc163 EBX:
00000007 ECX: c1fc9b60 EDX: 00000000
Mar  9 03:34:59 Aula2Server kernel: [119761.669376] ESI: 00000163 EDI:
80000000 EBP: 00000200 ESP: e8453c44
Mar  9 03:34:59 Aula2Server kernel: [119761.693503]  DS: 007b ES: 007b
FS: 00d8 GS: 0000 SS: 0068
Mar  9 03:34:59 Aula2Server kernel: [119761.717775] Process smtp (pid:
14897, ti=e8452000 task=f4d03700 task.ti=e8452000)
Mar  9 03:34:59 Aula2Server kernel: [119761.718262] Stack: 00200046
00200046 fffff000 00000038 00000007 80000000 00000007 7e4db067
Mar  9 03:34:59 Aula2Server kernel: [119761.743096]        00000200
c01261ec 00000163 80000000 c1fc9b60 c0181978 c04b48d1 00200092
Mar  9 03:34:59 Aula2Server kernel: [119761.768172]        c1fc9b6c
c04992a0 c200f2b0 00000000 f4508840 e8453d14 00000000 00000000
Mar  9 03:34:59 Aula2Server kernel: [119761.793411] Call Trace:
Mar  9 03:34:59 Aula2Server kernel: [119761.843138]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:34:59 Aula2Server kernel: [119761.868487]
[unmap_vmas+0x2e8/0x740] unmap_vmas+0x2e8/0x740
Mar  9 03:34:59 Aula2Server kernel: [119761.893884]
[exit_mmap+0x79/0xf0] exit_mmap+0x79/0xf0
Mar  9 03:34:59 Aula2Server kernel: [119761.919180]  [mmput+0x1e/0x80]
mmput+0x1e/0x80
Mar  9 03:34:59 Aula2Server kernel: [119761.944346]
[do_exit+0x165/0x860] do_exit+0x165/0x860
Mar  9 03:34:59 Aula2Server kernel: [119761.969307]
[snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
Mar  9 03:34:59 Aula2Server kernel: [119761.994140]  [die+0x277/0x280]
die+0x277/0x280
Mar  9 03:34:59 Aula2Server kernel: [119762.018725]
[do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
Mar  9 03:34:59 Aula2Server kernel: [119762.042773]
[do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
Mar  9 03:34:59 Aula2Server kernel: [119762.066078]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:34:59 Aula2Server kernel: [119762.088807]
[sock_sendmsg+0x111/0x130] sock_sendmsg+0x111/0x130
Mar  9 03:34:59 Aula2Server kernel: [119762.110901]  [<c0145fb0>]
autoremove_wake_function+0x0/0x40
Mar  9 03:34:59 Aula2Server kernel: [119762.132442]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:34:59 Aula2Server kernel: [119762.153370]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:34:59 Aula2Server kernel: [119762.174462]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:34:59 Aula2Server kernel: [119762.195152]
[handle_mm_fault+0x149/0xb80] handle_mm_fault+0x149/0xb80
Mar  9 03:34:59 Aula2Server kernel: [119762.215730]
[ipv6:inet_dgram_connect+0x35/0x120] inet_dgram_connect+0x35/0x80
Mar  9 03:34:59 Aula2Server kernel: [119762.236304]
[invalidate_inode_buffers+0xe/0xc0] invalidate_inode_buffers+0xe/0xc0
Mar  9 03:34:59 Aula2Server kernel: [119762.256820]
[ipv6:_spin_lock_bh+0x8/0x20] _spin_lock_bh+0x8/0x20
Mar  9 03:34:59 Aula2Server kernel: [119762.277496]
[do_page_fault+0x143/0x900] do_page_fault+0x143/0x900
Mar  9 03:34:59 Aula2Server kernel: [119762.297890]
[ext3:dput+0x1c/0xc90] dput+0x1c/0x100
Mar  9 03:34:59 Aula2Server kernel: [119762.318000]
[__fput+0x114/0x170] __fput+0x114/0x170
Mar  9 03:34:59 Aula2Server kernel: [119762.337884]
[fuse:mntput_no_expire+0x13/0x3ed0] mntput_no_expire+0x13/0x70
Mar  9 03:34:59 Aula2Server kernel: [119762.357833]
[do_page_fault+0x0/0x900] do_page_fault+0x0/0x900
Mar  9 03:34:59 Aula2Server kernel: [119762.377472]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:34:59 Aula2Server kernel: [119762.396887]  =======================
Mar  9 03:34:59 Aula2Server kernel: [119762.416354] Code: 14 40 8d 14 90
a1 20 a3 40 c0 01 da 89 54 24 10 c1 e2 03 89 54 24 0c 89 44 24 08 a1 28
43 4b c0 29 d0 8b 50 04 8b 00 85 c0 74 04 <0f> 0b eb fe 85 d2 75 f8 2b
0d 00 1e 50 c0 31 db c1 f9 05 0f a4
Mar  9 03:34:59 Aula2Server kernel: [119762.457691] EIP:
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130 SS:ESP
0068:e8453c44
Mar  9 03:34:59 Aula2Server kernel: [119762.480615] ---[ end trace
1b2cab846758a6ac ]---
Mar  9 03:34:59 Aula2Server kernel: [119762.502097] Fixing recursive
fault but reboot is needed!
Mar  9 03:35:00 Aula2Server kernel: [119762.525116] BUG: scheduling
while atomic: smtp/14897/0x00000002
Mar  9 03:35:00 Aula2Server kernel: [119762.546328] Pid: 14897, comm:
smtp Tainted: G      D 2.6.24-23-server #1
Mar  9 03:35:00 Aula2Server kernel: [119762.569685]
[jbd:schedule+0x582/0x6b0] schedule+0x582/0x630
Mar  9 03:35:00 Aula2Server kernel: [119762.593014]
[do_exit+0x750/0x860] do_exit+0x750/0x860
Mar  9 03:35:00 Aula2Server kernel: [119762.614214]
[snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
Mar  9 03:35:00 Aula2Server kernel: [119762.635499]  [die+0x277/0x280]
die+0x277/0x280
Mar  9 03:35:00 Aula2Server kernel: [119762.658466]
[do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
Mar  9 03:35:00 Aula2Server kernel: [119762.679162]
[do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
Mar  9 03:35:00 Aula2Server kernel: [119762.701084]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:35:00 Aula2Server kernel: [119762.720958]  [<f8abb35f>]
uhci_irq+0x8f/0x160 [uhci_hcd]
Mar  9 03:35:00 Aula2Server kernel: [119762.742551]
[update_curr+0x9f/0x150] update_curr+0x9f/0x150
Mar  9 03:35:00 Aula2Server kernel: [119762.762344]
[ack_ioapic_quirk_irq+0x47/0xb0] ack_ioapic_quirk_irq+0x47/0xb0
Mar  9 03:35:00 Aula2Server kernel: [119762.782061]
[handle_fasteoi_irq+0x9c/0xe0] handle_fasteoi_irq+0x9c/0xe0
Mar  9 03:35:00 Aula2Server kernel: [119762.803473]  [do_IRQ+0x40/0x70]
do_IRQ+0x40/0x70
Mar  9 03:35:00 Aula2Server kernel: [119762.822856]
[tcp_delack_timer+0xc/0x1f0] tcp_delack_timer+0xc/0x1f0
Mar  9 03:35:00 Aula2Server kernel: [119762.843640]
[run_timer_softirq+0x17e/0x1e0] run_timer_softirq+0x17e/0x1e0
Mar  9 03:35:00 Aula2Server kernel: [119762.861922]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:35:00 Aula2Server kernel: [119762.881324]
[copy_process+0x84b/0x11e0] copy_process+0x84b/0x11e0
Mar  9 03:35:00 Aula2Server kernel: [119762.898368]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:35:00 Aula2Server kernel: [119762.914603]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:35:00 Aula2Server kernel: [119762.932148]
[unmap_vmas+0x2e8/0x740] unmap_vmas+0x2e8/0x740
Mar  9 03:35:00 Aula2Server kernel: [119762.947658]
[exit_mmap+0x79/0xf0] exit_mmap+0x79/0xf0
Mar  9 03:35:00 Aula2Server kernel: [119762.965002]  [mmput+0x1e/0x80]
mmput+0x1e/0x80
Mar  9 03:35:00 Aula2Server kernel: [119762.980268]
[do_exit+0x165/0x860] do_exit+0x165/0x860
Mar  9 03:35:00 Aula2Server kernel: [119762.995317]
[snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
Mar  9 03:35:00 Aula2Server kernel: [119763.012202]  [die+0x277/0x280]
die+0x277/0x280
Mar  9 03:35:00 Aula2Server kernel: [119763.027090]
[do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
Mar  9 03:35:00 Aula2Server kernel: [119763.041942]
[do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
Mar  9 03:35:00 Aula2Server kernel: [119763.058423]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:35:00 Aula2Server kernel: [119763.072815]
[sock_sendmsg+0x111/0x130] sock_sendmsg+0x111/0x130
Mar  9 03:35:00 Aula2Server kernel: [119763.087030]  [<c0145fb0>]
autoremove_wake_function+0x0/0x40
Mar  9 03:35:00 Aula2Server kernel: [119763.101322]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:35:00 Aula2Server kernel: [119763.117241]
[kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130
Mar  9 03:35:00 Aula2Server kernel: [119763.131188]
[loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
Mar  9 03:35:00 Aula2Server kernel: [119763.145181]
[handle_mm_fault+0x149/0xb80] handle_mm_fault+0x149/0xb80
Mar  9 03:35:00 Aula2Server kernel: [119763.161111]
[ipv6:inet_dgram_connect+0x35/0x120] inet_dgram_connect+0x35/0x80
Mar  9 03:35:00 Aula2Server kernel: [119763.175256]
[invalidate_inode_buffers+0xe/0xc0] invalidate_inode_buffers+0xe/0xc0
Mar  9 03:35:00 Aula2Server kernel: [119763.189270]
[ipv6:_spin_lock_bh+0x8/0x20] _spin_lock_bh+0x8/0x20
Mar  9 03:35:00 Aula2Server kernel: [119763.205373]
[do_page_fault+0x143/0x900] do_page_fault+0x143/0x900
Mar  9 03:35:00 Aula2Server kernel: [119763.219631]
[ext3:dput+0x1c/0xc90] dput+0x1c/0x100
Mar  9 03:35:00 Aula2Server kernel: [119763.233782]
[__fput+0x114/0x170] __fput+0x114/0x170
Mar  9 03:35:00 Aula2Server kernel: [119763.249847]
[fuse:mntput_no_expire+0x13/0x3ed0] mntput_no_expire+0x13/0x70
Mar  9 03:35:00 Aula2Server kernel: [119763.264207]
[do_page_fault+0x0/0x900] do_page_fault+0x0/0x900
Mar  9 03:35:00 Aula2Server kernel: [119763.278503]
[error_code+0x72/0x78] error_code+0x72/0x78
Mar  9 03:35:00 Aula2Server kernel: [119763.292540]  =======================
Mar  9 03:35:05 Aula2Server zmc_dvideo0[6032]: WAR [Buffer overrun at
index 15, slow down capture, speed up analysis or increase ring buffer size]
Mar  9 15:06:59 Aula2Server kernel: Inspecting
/boot/System.map-2.6.24-23-server
Mar  9 15:06:59 Aula2Server kernel: Loaded 28764 symbols from
/boot/System.map-2.6.24-23-server.
Mar  9 15:06:59 Aula2Server kernel: Symbols match kernel version 2.6.24.
Mar  9 15:06:59 Aula2Server kernel: Loaded 20613 symbols from 94 modules.
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] Initializing cgroup
subsys cpuset
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] Initializing cgroup
subsys cpu
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] Linux version
2.6.24-23-server (buildd@vernadsky) (gcc version 4.2.3 (Ubuntu
4.2.3-2ubuntu7)) #1 SMP Mon Jan 26 00:55:21 UTC 2009 (Ubuntu
2.6.24-23.48-server)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] BIOS-provided
physical RAM map:
Mar  9 15:06:59 Aula2Server kernel: [    0.000000]  BIOS-e820:
0000000000000000 - 000000000009fc00 (usable)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000]  BIOS-e820:
000000000009fc00 - 00000000000a0000 (reserved)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000]  BIOS-e820:
00000000000e4000 - 0000000000100000 (reserved)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000]  BIOS-e820:
0000000000100000 - 000000007ffa0000 (usable)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000]  BIOS-e820:
000000007ffa0000 - 000000007ffae000 (ACPI data)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000]  BIOS-e820:
000000007ffae000 - 000000007ffe0000 (ACPI NVS)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000]  BIOS-e820:
000000007ffe0000 - 0000000080000000 (reserved)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000]  BIOS-e820:
00000000ffb80000 - 0000000100000000 (reserved)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] 1151MB HIGHMEM available.
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] 896MB LOWMEM available.
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] found SMP MP-table at
000ff780
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] Entering
add_active_range(0, 0, 524192) 0 entries of 256 used
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] Zone PFN ranges:
Mar  9 15:06:59 Aula2Server kernel: [    0.000000]   DMA             0
->     4096
Mar  9 15:06:59 Aula2Server kernel: [    0.000000]   Normal       4096
->   229376
Mar  9 15:06:59 Aula2Server kernel: [    0.000000]   HighMem    229376
->   524192
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] Movable zone start
PFN for each node
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] early_node_map[1]
active PFN ranges
Mar  9 15:06:59 Aula2Server kernel: [    0.000000]     0:        0 ->
524192
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] On node 0 totalpages:
524192
Mar  9 15:06:59 Aula2Server kernel: [    0.000000]   DMA zone: 32 pages
used for memmap
Mar  9 15:06:59 Aula2Server kernel: [    0.000000]   DMA zone: 0 pages
reserved
Mar  9 15:06:59 Aula2Server kernel: [    0.000000]   DMA zone: 4064
pages, LIFO batch:0
Mar  9 15:06:59 Aula2Server kernel: [    0.000000]   Normal zone: 1760
pages used for memmap
Mar  9 15:06:59 Aula2Server kernel: [    0.000000]   Normal zone: 223520
pages, LIFO batch:31
Mar  9 15:06:59 Aula2Server kernel: [    0.000000]   HighMem zone: 2303
pages used for memmap
Mar  9 15:06:59 Aula2Server kernel: [    0.000000]   HighMem zone:
292513 pages, LIFO batch:31
Mar  9 15:06:59 Aula2Server kernel: [    0.000000]   Movable zone: 0
pages used for memmap
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] DMI 2.3 present.
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: RSDP signature
@ 0xC00FACD0 checksum 0
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: RSDP 000FACD0,
0024 (r2 ACPIAM)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: XSDT 7FFA0100,
0044 (r1 A M I  OEMXSDT   7000612 MSFT       97)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: FACP 7FFA0290,
00F4 (r3 A M I  OEMFACP   7000612 MSFT       97)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: DSDT 7FFA0400,
8172 (r1  A0227 A0227000        0 INTL  2002026)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: FACS 7FFAE000, 0040
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: APIC 7FFA0390,
0070 (r1 A M I  OEMAPIC   7000612 MSFT       97)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: OEMB 7FFAE040,
0066 (r1 A M I  AMI_OEM   7000612 MSFT       97)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: MCFG 7FFA8580,
003C (r1 A M I  OEMMCFG   7000612 MSFT       97)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: PM-Timer IO
Port: 0x808
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: Local APIC
address 0xfee00000
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x01] lapic_id[0x00] enabled)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] Processor #0 15:6
APIC version 20
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x02] lapic_id[0x01] enabled)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] Processor #1 15:6
APIC version 20
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: IOAPIC
(id[0x02] address[0xfec00000] gsi_base[0])
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] IOAPIC[0]: apic_id 2,
version 32, address 0xfec00000, GSI 0-23
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: INT_SRC_OVR
(bus 0 bus_irq 0 global_irq 2 dfl dfl)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: INT_SRC_OVR
(bus 0 bus_irq 9 global_irq 9 high level)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: INT_SRC_OVR
(bus 0 bus_irq 0 global_irq 2 dfl dfl)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: INT_SRC_OVR
(bus 0 bus_irq 9 global_irq 9 high level)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: IRQ0 used by
override.
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: IRQ2 used by
override.
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: IRQ9 used by
override.
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] Enabling APIC mode:
Flat.  Using 1 I/O APICs
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] Using ACPI (MADT) for
SMP configuration information
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] Allocating PCI
resources starting at 88000000 (gap: 80000000:7fb80000)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] swsusp: Registered
nosave memory region: 000000000009f000 - 00000000000a0000
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] swsusp: Registered
nosave memory region: 00000000000a0000 - 00000000000e4000
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] swsusp: Registered
nosave memory region: 00000000000e4000 - 0000000000100000
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] Built 1 zonelists in
Zone order, mobility grouping on.  Total pages: 520097
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] Kernel command line:
root=/dev/md1 ro noquiet nosplash elevator=deadline acpi_osi="Linux"
vga=0x307
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] ACPI: Added _OSI(Linux)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] mapped APIC to
ffffb000 (fee00000)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] mapped IOAPIC to
ffffa000 (fec00000)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] Enabling fast FPU
save and restore... done.
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] Enabling unmasked
SIMD FPU exception support... done.
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] Initializing CPU#0
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] PID hash table
entries: 4096 (order: 12, 16384 bytes)
Mar  9 15:06:59 Aula2Server kernel: [    0.000000] Detected 3412.175 MHz
processor.
Mar  9 15:06:59 Aula2Server kernel: [   33.456262] Console: colour dummy
device 80x25
Mar  9 15:06:59 Aula2Server kernel: [   33.456266] console [tty0] enabled
Mar  9 15:06:59 Aula2Server kernel: [   33.456630] Dentry cache hash
table entries: 131072 (order: 7, 524288 bytes)
Mar  9 15:06:59 Aula2Server kernel: [   33.456926] Inode-cache hash
table entries: 65536 (order: 6, 262144 bytes)
Mar  9 15:06:59 Aula2Server kernel: [   33.560859] Memory:
2066276k/2096768k available (2258k kernel code, 29268k reserved, 1037k
data, 384k init, 1179264k highmem)
Mar  9 15:06:59 Aula2Server kernel: [   33.560876] virtual kernel memory
layout:
Mar  9 15:06:59 Aula2Server kernel: [   33.560877]     fixmap  :
0xfff4c000 - 0xfffff000   ( 716 kB)
Mar  9 15:06:59 Aula2Server kernel: [   33.560878]     pkmap   :
0xffc00000 - 0xffe00000   (2048 kB)
Mar  9 15:06:59 Aula2Server kernel: [   33.560879]     vmalloc :
0xf8800000 - 0xffbfe000   ( 115 MB)
Mar  9 15:06:59 Aula2Server kernel: [   33.560880]     lowmem  :
0xc0000000 - 0xf8000000   ( 896 MB)
Mar  9 15:06:59 Aula2Server kernel: [   33.560881]       .init :
0xc043e000 - 0xc049e000   ( 384 kB)
Mar  9 15:06:59 Aula2Server kernel: [   33.560882]       .data :
0xc03349d9 - 0xc0437fe4   (1037 kB)
Mar  9 15:06:59 Aula2Server kernel: [   33.560883]       .text :
0xc0100000 - 0xc03349d9   (2258 kB)
Mar  9 15:06:59 Aula2Server kernel: [   33.560899] Checking if this
processor honours the WP bit even in supervisor mode... Ok.
Mar  9 15:06:59 Aula2Server kernel: [   33.560938] SLUB: Genslabs=11,
HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Mar  9 15:06:59 Aula2Server kernel: [   33.710908] Calibrating delay
using timer specific routine.. 6829.07 BogoMIPS (lpj=34145387)
Mar  9 15:06:59 Aula2Server kernel: [   33.710936] Security Framework
initialized
Mar  9 15:06:59 Aula2Server kernel: [   33.710942] SELinux:  Disabled at
boot.
Mar  9 15:06:59 Aula2Server kernel: [   33.710956] AppArmor: AppArmor
initialized
Mar  9 15:06:59 Aula2Server kernel: [   33.710962] Failure registering
capabilities with primary security module.
Mar  9 15:06:59 Aula2Server kernel: [   33.710972] Mount-cache hash
table entries: 512
Mar  9 15:06:59 Aula2Server kernel: [   33.711086] Initializing cgroup
subsys ns
Mar  9 15:06:59 Aula2Server kernel: [   33.711092] Initializing cgroup
subsys cpuacct
Mar  9 15:06:59 Aula2Server kernel: [   33.711106] CPU: After generic
identify, caps: bfebfbff 20000000 00000000 00000000 0000e49d 00000000
00000001 00000000
Mar  9 15:06:59 Aula2Server kernel: [   33.711114] monitor/mwait feature
present.
Mar  9 15:06:59 Aula2Server kernel: [   33.711118] using mwait in idle
threads.
Mar  9 15:06:59 Aula2Server kernel: [   33.711125] CPU: Trace cache: 12K
uops, L1 D cache: 16K
Mar  9 15:06:59 Aula2Server kernel: [   33.711129] CPU: L2 cache: 2048K
Mar  9 15:06:59 Aula2Server kernel: [   33.711133] CPU: Physical
Processor ID: 0
Mar  9 15:06:59 Aula2Server kernel: [   33.711135] CPU: Processor Core ID: 0
Mar  9 15:06:59 Aula2Server kernel: [   33.711139] CPU: After all inits,
caps: bfebfbff 20000000 00000000 00043180 0000e49d 00000000 00000001
00000000
Mar  9 15:06:59 Aula2Server kernel: [   33.711148] Compat vDSO mapped to
ffffe000.
Mar  9 15:06:59 Aula2Server kernel: [   33.711164] Checking 'hlt'
instruction... OK.
Mar  9 15:06:59 Aula2Server kernel: [   33.751357] SMP alternatives:
switching to UP code
Mar  9 15:06:59 Aula2Server kernel: [   33.753063] Early unpacking
initramfs... done
Mar  9 15:06:59 Aula2Server kernel: [   34.029709] ACPI: Core revision
20070126
Mar  9 15:06:59 Aula2Server kernel: [   34.029770] ACPI: Looking for
DSDT in initramfs... error, file /DSDT.aml not found.
Mar  9 15:06:59 Aula2Server kernel: [   34.044805] CPU0: Intel(R)
Pentium(R) D CPU 3.40GHz stepping 05
Mar  9 15:06:59 Aula2Server kernel: [   34.044827] SMP alternatives:
switching to SMP code
Mar  9 15:06:59 Aula2Server kernel: [   34.045569] Booting processor 1/1
eip 3000
Mar  9 15:06:59 Aula2Server kernel: [   34.075804] Initializing CPU#1
Mar  9 15:06:59 Aula2Server kernel: [   34.220726] Calibrating delay
using timer specific routine.. 6824.41 BogoMIPS (lpj=34122066)
Mar  9 15:06:59 Aula2Server kernel: [   34.220735] CPU: After generic
identify, caps: bfebfbff 20000000 00000000 00000000 0000e49d 00000000
00000001 00000000
Mar  9 15:06:59 Aula2Server kernel: [   34.220740] monitor/mwait feature
present.
Mar  9 15:06:59 Aula2Server kernel: [   34.220745] CPU: Trace cache: 12K
uops, L1 D cache: 16K
Mar  9 15:06:59 Aula2Server kernel: [   34.220747] CPU: L2 cache: 2048K
Mar  9 15:06:59 Aula2Server kernel: [   34.220749] CPU: Physical
Processor ID: 0
Mar  9 15:06:59 Aula2Server kernel: [   34.220750] CPU: Processor Core ID: 1
Mar  9 15:06:59 Aula2Server kernel: [   34.220752] CPU: After all inits,
caps: bfebfbff 20000000 00000000 00043180 0000e49d 00000000 00000001
00000000
Mar  9 15:06:59 Aula2Server kernel: [   34.221160] CPU1: Intel(R)
Pentium(R) D CPU 3.40GHz stepping 05
Mar  9 15:06:59 Aula2Server kernel: [   34.221203] Total of 2 processors
activated (13653.49 BogoMIPS).
Mar  9 15:06:59 Aula2Server kernel: [   34.221350] ENABLING IO-APIC IRQs
Mar  9 15:06:59 Aula2Server kernel: [   34.221519] ..TIMER: vector=0x31
apic1=0 pin1=2 apic2=-1 pin2=-1
Mar  9 15:06:59 Aula2Server kernel: [   34.440743] checking TSC
synchronization [CPU#0 -> CPU#1]:
Mar  9 15:06:59 Aula2Server kernel: [   34.460743] Measured 17 cycles
TSC warp between CPUs, turning off TSC clock.
Mar  9 15:06:59 Aula2Server kernel: [   34.460769] Brought up 2 CPUs
Mar  9 15:06:59 Aula2Server kernel: [   34.460798] CPU0 attaching
sched-domain:
Mar  9 15:06:59 Aula2Server kernel: [   34.460801]  domain 0: span 03
Mar  9 15:06:59 Aula2Server kernel: [   34.460803]   groups: 01 02
Mar  9 15:06:59 Aula2Server kernel: [   34.460806] CPU1 attaching
sched-domain:
Mar  9 15:06:59 Aula2Server kernel: [   34.460808]  domain 0: span 03
Mar  9 15:06:59 Aula2Server kernel: [   34.460809]   groups: 02 01
Mar  9 15:06:59 Aula2Server kernel: [   34.460996] net_namespace: 64 bytes
Mar  9 15:06:59 Aula2Server kernel: [   34.461008] Booting
paravirtualized kernel on bare hardware
Mar  9 15:06:59 Aula2Server kernel: [   34.461534] Time: 14:06:19  Date:
03/09/09
Mar  9 15:06:59 Aula2Server kernel: [   34.461557] NET: Registered
protocol family 16
Mar  9 15:06:59 Aula2Server kernel: [   34.461770] EISA bus registered
Mar  9 15:06:59 Aula2Server kernel: [   34.461777] ACPI: bus type pci
registered
Mar  9 15:06:59 Aula2Server kernel: [   34.462095] PCI: PCI BIOS
revision 2.10 entry at 0xf0031, last bus=3
Mar  9 15:06:59 Aula2Server kernel: [   34.462100] PCI: Using
configuration type 1
Mar  9 15:06:59 Aula2Server kernel: [   34.462118] Setting up standard
PCI resources
Mar  9 15:06:59 Aula2Server kernel: [   34.471307] ACPI: EC: Look up EC
in DSDT
Mar  9 15:06:59 Aula2Server kernel: [   34.480390] ACPI: Interpreter enabled
Mar  9 15:06:59 Aula2Server kernel: [   34.480395] ACPI: (supports S0 S1
S3 S4 S5)
Mar  9 15:06:59 Aula2Server kernel: [   34.480415] ACPI: Using IOAPIC
for interrupt routing
Mar  9 15:06:59 Aula2Server kernel: [   34.488113] ACPI: PCI Root Bridge
[PCI0] (0000:00)
Mar  9 15:06:59 Aula2Server kernel: [   34.489271] PCI: Transparent
bridge - 0000:00:1e.0
Mar  9 15:06:59 Aula2Server kernel: [   34.489304] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0._PRT]
Mar  9 15:06:59 Aula2Server kernel: [   34.489447] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.P0P3._PRT]
Mar  9 15:06:59 Aula2Server kernel: [   34.489565] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.P0P4._PRT]
Mar  9 15:06:59 Aula2Server kernel: [   34.489646] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.P0P7._PRT]
Mar  9 15:06:59 Aula2Server kernel: [   34.491980] ACPI: PCI Interrupt
Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
Mar  9 15:06:59 Aula2Server kernel: [   34.492099] ACPI: PCI Interrupt
Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
Mar  9 15:06:59 Aula2Server kernel: [   34.492213] ACPI: PCI Interrupt
Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
Mar  9 15:06:59 Aula2Server kernel: [   34.492329] ACPI: PCI Interrupt
Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
Mar  9 15:06:59 Aula2Server kernel: [   34.492444] ACPI: PCI Interrupt
Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 14 15)
Mar  9 15:06:59 Aula2Server kernel: [   34.492558] ACPI: PCI Interrupt
Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
Mar  9 15:06:59 Aula2Server kernel: [   34.492676] ACPI: PCI Interrupt
Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
Mar  9 15:06:59 Aula2Server kernel: [   34.492793] ACPI: PCI Interrupt
Link [LNKH] (IRQs 3 4 5 6 7 10 *11 12 14 15)
Mar  9 15:06:59 Aula2Server kernel: [   34.492929] ACPI Warning
(tbutils-0217): Incorrect checksum in table [OEMB] -  72, should be 65
[20070126]
Mar  9 15:06:59 Aula2Server kernel: [   34.492942] Linux Plug and Play
Support v0.97 (c) Adam Belay
Mar  9 15:06:59 Aula2Server kernel: [   34.492978] pnp: PnP ACPI init
Mar  9 15:06:59 Aula2Server kernel: [   34.492988] ACPI: bus type pnp
registered
Mar  9 15:06:59 Aula2Server kernel: [   34.497202] pnp: PnP ACPI: found
16 devices
Mar  9 15:06:59 Aula2Server kernel: [   34.497207] ACPI: ACPI bus type
pnp unregistered
Mar  9 15:06:59 Aula2Server kernel: [   34.497212] PnPBIOS: Disabled by
ACPI PNP
Mar  9 15:06:59 Aula2Server kernel: [   34.497453] PCI: Using ACPI for
IRQ routing
Mar  9 15:06:59 Aula2Server kernel: [   34.497458] PCI: If a device
doesn't work, try "pci=routeirq".  If it helps, post a report
Mar  9 15:06:59 Aula2Server kernel: [   34.530732] NET: Registered
protocol family 8
Mar  9 15:06:59 Aula2Server kernel: [   34.530736] NET: Registered
protocol family 20
Mar  9 15:06:59 Aula2Server kernel: [   34.530768] NetLabel: Initializing
Mar  9 15:06:59 Aula2Server kernel: [   34.530772] NetLabel:  domain
hash size = 128
Mar  9 15:06:59 Aula2Server kernel: [   34.530775] NetLabel:  protocols
= UNLABELED CIPSOv4
Mar  9 15:06:59 Aula2Server kernel: [   34.530789] NetLabel:  unlabeled
traffic allowed by default
Mar  9 15:06:59 Aula2Server kernel: [   34.530825] AppArmor: AppArmor
Filesystem Enabled
Mar  9 15:06:59 Aula2Server kernel: [   34.560707] system 00:01: iomem
range 0xfed13000-0xfed19fff has been reserved
Mar  9 15:06:59 Aula2Server kernel: [   34.560729] system 00:08: ioport
range 0x290-0x297 has been reserved
Mar  9 15:06:59 Aula2Server kernel: [   34.560738] system 00:09: ioport
range 0x4d0-0x4d1 has been reserved
Mar  9 15:06:59 Aula2Server kernel: [   34.560743] system 00:09: ioport
range 0x800-0x87f has been reserved
Mar  9 15:06:59 Aula2Server kernel: [   34.560747] system 00:09: ioport
range 0x480-0x4bf has been reserved
Mar  9 15:06:59 Aula2Server kernel: [   34.560751] system 00:09: ioport
range 0x900-0x90f has been reserved
Mar  9 15:06:59 Aula2Server kernel: [   34.560756] system 00:09: iomem
range 0xfed1c000-0xfed1ffff has been reserved
Mar  9 15:06:59 Aula2Server kernel: [   34.560760] system 00:09: iomem
range 0xfed20000-0xfed8ffff has been reserved
Mar  9 15:06:59 Aula2Server kernel: [   34.560765] system 00:09: iomem
range 0xffb00000-0xffbfffff could not be reserved
Mar  9 15:06:59 Aula2Server kernel: [   34.560771] system 00:09: iomem
range 0xfff00000-0xffffffff could not be reserved
Mar  9 15:06:59 Aula2Server kernel: [   34.560780] system 00:0c: iomem
range 0xfec00000-0xfec00fff has been reserved
Mar  9 15:06:59 Aula2Server kernel: [   34.560785] system 00:0c: iomem
range 0xfee00000-0xfee00fff has been reserved
Mar  9 15:06:59 Aula2Server kernel: [   34.560793] system 00:0e: iomem
range 0xf0000000-0xf3ffffff has been reserved
Mar  9 15:06:59 Aula2Server kernel: [   34.560801] system 00:0f: iomem
range 0x0-0x9ffff could not be reserved
Mar  9 15:06:59 Aula2Server kernel: [   34.560806] system 00:0f: iomem
range 0xc0000-0xdffff could not be reserved
Mar  9 15:06:59 Aula2Server kernel: [   34.560810] system 00:0f: iomem
range 0xe0000-0xfffff could not be reserved
Mar  9 15:06:59 Aula2Server kernel: [   34.560814] system 00:0f: iomem
range 0x100000-0x7fffffff could not be reserved
Mar  9 15:06:59 Aula2Server kernel: [   34.560819] system 00:0f: iomem
range 0x0-0x0 could not be reserved
Mar  9 15:06:59 Aula2Server kernel: [   34.591248] PCI: Bridge: 0000:00:1c.0
Mar  9 15:06:59 Aula2Server kernel: [   34.591253]   IO window: e000-efff
Mar  9 15:06:59 Aula2Server kernel: [   34.591259]   MEM window: disabled.
Mar  9 15:06:59 Aula2Server kernel: [   34.591264]   PREFETCH window:
disabled.
Mar  9 15:06:59 Aula2Server kernel: [   34.591270] PCI: Bridge: 0000:00:1c.3
Mar  9 15:06:59 Aula2Server kernel: [   34.591274]   IO window: d000-dfff
Mar  9 15:06:59 Aula2Server kernel: [   34.591280]   MEM window:
dff00000-dfffffff
Mar  9 15:06:59 Aula2Server kernel: [   34.591285]   PREFETCH window:
disabled.
Mar  9 15:06:59 Aula2Server kernel: [   34.591294] PCI: Bridge: 0000:00:1e.0
Mar  9 15:06:59 Aula2Server kernel: [   34.591298]   IO window: a000-cfff
Mar  9 15:06:59 Aula2Server kernel: [   34.591304]   MEM window:
de000000-dfefffff
Mar  9 15:06:59 Aula2Server kernel: [   34.591309]   PREFETCH window:
disabled.
Mar  9 15:06:59 Aula2Server kernel: [   34.591335] ACPI: PCI Interrupt
0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
Mar  9 15:06:59 Aula2Server kernel: [   34.591344] PCI: Setting latency
timer of device 0000:00:1c.0 to 64
Mar  9 15:06:59 Aula2Server kernel: [   34.591363] ACPI: PCI Interrupt
0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 17
Mar  9 15:06:59 Aula2Server kernel: [   34.591371] PCI: Setting latency
timer of device 0000:00:1c.3 to 64
Mar  9 15:06:59 Aula2Server kernel: [   34.591382] PCI: Setting latency
timer of device 0000:00:1e.0 to 64
Mar  9 15:06:59 Aula2Server kernel: [   34.591391] NET: Registered
protocol family 2
Mar  9 15:06:59 Aula2Server kernel: [   34.600641] Time: acpi_pm
clocksource has been installed.
Mar  9 15:06:59 Aula2Server kernel: [   34.600665] Switched to high
resolution mode on CPU 0
Mar  9 15:06:59 Aula2Server kernel: [   34.600739] Switched to high
resolution mode on CPU 1
Mar  9 15:06:59 Aula2Server kernel: [   34.690695] IP route cache hash
table entries: 32768 (order: 5, 131072 bytes)
Mar  9 15:06:59 Aula2Server kernel: [   34.690944] TCP established hash
table entries: 131072 (order: 8, 1048576 bytes)
Mar  9 15:06:59 Aula2Server kernel: [   34.691455] TCP bind hash table
entries: 65536 (order: 7, 524288 bytes)
Mar  9 15:06:59 Aula2Server kernel: [   34.691711] TCP: Hash tables
configured (established 131072 bind 65536)
Mar  9 15:06:59 Aula2Server kernel: [   34.691715] TCP reno registered
Mar  9 15:06:59 Aula2Server kernel: [   34.720742] checking if image is
initramfs... it is
Mar  9 15:06:59 Aula2Server kernel: [   35.266011] Freeing initrd
memory: 7717k freed
Mar  9 15:06:59 Aula2Server kernel: [   35.267026] audit: initializing
netlink socket (disabled)
Mar  9 15:06:59 Aula2Server kernel: [   35.267048]
audit(1236607579.570:1): initialized
Mar  9 15:06:59 Aula2Server kernel: [   35.267371] highmem bounce pool
size: 64 pages
Mar  9 15:06:59 Aula2Server kernel: [   35.267379] Total HugeTLB memory
allocated, 0
Mar  9 15:06:59 Aula2Server kernel: [   35.270367] VFS: Disk quotas
dquot_6.5.1
Mar  9 15:06:59 Aula2Server kernel: [   35.270461] Dquot-cache hash
table entries: 1024 (order 0, 4096 bytes)
Mar  9 15:06:59 Aula2Server kernel: [   35.270729] io scheduler noop
registered
Mar  9 15:06:59 Aula2Server kernel: [   35.270735] io scheduler
anticipatory registered
Mar  9 15:06:59 Aula2Server kernel: [   35.270740] io scheduler deadline
registered (default)
Mar  9 15:06:59 Aula2Server kernel: [   35.270759] io scheduler cfq
registered
Mar  9 15:06:59 Aula2Server kernel: [   35.270866] Boot video device is
0000:01:01.0
Mar  9 15:06:59 Aula2Server kernel: [   35.271027] PCI: Setting latency
timer of device 0000:00:1c.0 to 64
Mar  9 15:06:59 Aula2Server kernel: [   35.271078] assign_interrupt_mode
Found MSI capability
Mar  9 15:06:59 Aula2Server kernel: [   35.271126] Allocate Port
Service[0000:00:1c.0:pcie00]
Mar  9 15:06:59 Aula2Server kernel: [   35.271186] Allocate Port
Service[0000:00:1c.0:pcie02]
Mar  9 15:06:59 Aula2Server kernel: [   35.271305] PCI: Setting latency
timer of device 0000:00:1c.3 to 64
Mar  9 15:06:59 Aula2Server kernel: [   35.271354] assign_interrupt_mode
Found MSI capability
Mar  9 15:06:59 Aula2Server kernel: [   35.271398] Allocate Port
Service[0000:00:1c.3:pcie00]
Mar  9 15:06:59 Aula2Server kernel: [   35.271775] isapnp: Scanning for
PnP cards...
Mar  9 15:06:59 Aula2Server kernel: [   35.626119] isapnp: No Plug &
Play device found
Mar  9 15:06:59 Aula2Server kernel: [   35.670881] Real Time Clock
Driver v1.12ac
Mar  9 15:06:59 Aula2Server kernel: [   35.671023] Serial: 8250/16550
driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Mar  9 15:06:59 Aula2Server kernel: [   35.671167] serial8250: ttyS0 at
I/O 0x3f8 (irq = 4) is a 16550A
Mar  9 15:06:59 Aula2Server kernel: [   35.672069] 00:0d: ttyS0 at I/O
0x3f8 (irq = 4) is a 16550A
Mar  9 15:06:59 Aula2Server kernel: [   35.673247] RAMDISK driver
initialized: 16 RAM disks of 65536K size 1024 blocksize
Mar  9 15:06:59 Aula2Server kernel: [   35.673358] input: Macintosh
mouse button emulation as /devices/virtual/input/input0
Mar  9 15:06:59 Aula2Server kernel: [   35.673517] PNP: PS/2 Controller
[PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
Mar  9 15:06:59 Aula2Server kernel: [   35.676281] serio: i8042 KBD port
at 0x60,0x64 irq 1
Mar  9 15:06:59 Aula2Server kernel: [   35.676293] serio: i8042 AUX port
at 0x60,0x64 irq 12
Mar  9 15:06:59 Aula2Server kernel: [   35.700518] mice: PS/2 mouse
device common for all mice
Mar  9 15:06:59 Aula2Server kernel: [   35.700650] EISA: Probing bus 0
at eisa.0
Mar  9 15:06:59 Aula2Server kernel: [   35.700678] Cannot allocate
resource for EISA slot 7
Mar  9 15:06:59 Aula2Server kernel: [   35.700682] Cannot allocate
resource for EISA slot 8
Mar  9 15:06:59 Aula2Server kernel: [   35.700686] EISA: Detected 0 cards.
Mar  9 15:06:59 Aula2Server kernel: [   35.700690] cpuidle: using
governor ladder
Mar  9 15:06:59 Aula2Server kernel: [   35.700693] cpuidle: using
governor menu
Mar  9 15:06:59 Aula2Server kernel: [   35.700768] NET: Registered
protocol family 1
Mar  9 15:06:59 Aula2Server kernel: [   35.700800] Using IPI No-Shortcut
mode
Mar  9 15:06:59 Aula2Server kernel: [   35.700830] registered taskstats
version 1
Mar  9 15:06:59 Aula2Server kernel: [   35.700921]   Magic number: 1:206:131
Mar  9 15:06:59 Aula2Server kernel: [   35.701043]   hash matches device
PNP0C02:03
Mar  9 15:06:59 Aula2Server kernel: [   35.701048]   hash matches device
device:06
Mar  9 15:06:59 Aula2Server kernel: [   35.701054] BIOS EDD facility
v0.16 2004-Jun-25, 6 devices found
Mar  9 15:06:59 Aula2Server kernel: [   35.701491] Freeing unused kernel
memory: 384k freed
Mar  9 15:06:59 Aula2Server kernel: [   35.701534] Write protecting the
kernel read-only data: 828k
Mar  9 15:06:59 Aula2Server kernel: [   35.732734] input: AT Translated
Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
Mar  9 15:06:59 Aula2Server kernel: [   35.803576] vesafb: framebuffer
at 0xde000000, mapped to 0xf8880000, using 2048k, total 2048k
Mar  9 15:06:59 Aula2Server kernel: [   35.803590] vesafb: mode is
1280x1024x8, linelength=1280, pages=0
Mar  9 15:06:59 Aula2Server kernel: [   35.803595] vesafb: protected
mode interface info at c000:46b4
Mar  9 15:06:59 Aula2Server kernel: [   35.803601] vesafb: pmi: set
display start = c00c476a, set palette = c00c47f4
Mar  9 15:06:59 Aula2Server kernel: [   35.803607] vesafb: pmi: ports =
a085 a01f a0b4 a0b8 a018 a014 a0c0 a0c3 a0c1
Mar  9 15:06:59 Aula2Server kernel: [   35.803624] vesafb: scrolling: redraw
Mar  9 15:06:59 Aula2Server kernel: [   35.803629] vesafb: Pseudocolor:
size=6:6:6:6, shift=0:0:0:0
Mar  9 15:06:59 Aula2Server kernel: [   35.803793] Console: switching to
colour frame buffer device 160x64
Mar  9 15:06:59 Aula2Server kernel: [   35.860495] fb0: VESA VGA frame
buffer device
Mar  9 15:06:59 Aula2Server kernel: [   36.013463] fuse init (API
version 7.9)
Mar  9 15:06:59 Aula2Server kernel: [   36.030640] ACPI: SSDT 7FFA85C0,
02E3 (r1    AMI   CPU1PM        1 INTL 20060113)
Mar  9 15:06:59 Aula2Server kernel: [   36.031582] ACPI: Processor
[CPU1] (supports 8 throttling states)
Mar  9 15:06:59 Aula2Server kernel: [   36.032039] ACPI: SSDT 7FFA88B0,
02DA (r1    AMI   CPU2PM        1 INTL 20060113)
Mar  9 15:06:59 Aula2Server kernel: [   36.032973] ACPI: Processor
[CPU2] (supports 8 throttling states)
Mar  9 15:06:59 Aula2Server kernel: [   36.048338] md: linear
personality registered for level -1
Mar  9 15:06:59 Aula2Server kernel: [   36.052611] md: multipath
personality registered for level -4
Mar  9 15:06:59 Aula2Server kernel: [   36.056975] md: raid0 personality
registered for level 0
Mar  9 15:06:59 Aula2Server kernel: [   36.061856] md: raid1 personality
registered for level 1
Mar  9 15:06:59 Aula2Server kernel: [   36.066003] xor: automatically
using best checksumming function: pIII_sse
Mar  9 15:06:59 Aula2Server kernel: [   36.110075]    pIII_sse  :
5190.000 MB/sec
Mar  9 15:06:59 Aula2Server kernel: [   36.110347] xor: using function:
pIII_sse (5190.000 MB/sec)
Mar  9 15:06:59 Aula2Server kernel: [   36.111434] async_tx: api
initialized (async)
Mar  9 15:06:59 Aula2Server kernel: [   36.280074] raid6: int32x1    898
MB/s
Mar  9 15:06:59 Aula2Server kernel: [   36.449978] raid6: int32x2    999
MB/s
Mar  9 15:06:59 Aula2Server kernel: [   36.619889] raid6: int32x4    985
MB/s
Mar  9 15:06:59 Aula2Server kernel: [   36.789822] raid6: int32x8    717
MB/s
Mar  9 15:06:59 Aula2Server kernel: [   36.959762] raid6: mmxx1     2041
MB/s
Mar  9 15:06:59 Aula2Server kernel: [   37.129686] raid6: mmxx2     2427
MB/s
Mar  9 15:06:59 Aula2Server kernel: [   37.299652] raid6: sse1x1    1255
MB/s
Mar  9 15:06:59 Aula2Server kernel: [   37.469578] raid6: sse1x2    2297
MB/s
Mar  9 15:06:59 Aula2Server kernel: [   37.639496] raid6: sse2x1    2509
MB/s
Mar  9 15:06:59 Aula2Server kernel: [   37.809431] raid6: sse2x2    3560
MB/s
Mar  9 15:06:59 Aula2Server kernel: [   37.809671] raid6: using
algorithm sse2x2 (3560 MB/s)
Mar  9 15:06:59 Aula2Server kernel: [   37.809996] md: raid6 personality
registered for level 6
Mar  9 15:06:59 Aula2Server kernel: [   37.810336] md: raid5 personality
registered for level 5
Mar  9 15:06:59 Aula2Server kernel: [   37.810675] md: raid4 personality
registered for level 4
Mar  9 15:06:59 Aula2Server kernel: [   37.832500] md: raid10
personality registered for level 10
Mar  9 15:06:59 Aula2Server kernel: [   38.067034] usbcore: registered
new interface driver usbfs
Mar  9 15:06:59 Aula2Server kernel: [   38.067415] usbcore: registered
new interface driver hub
Mar  9 15:06:59 Aula2Server kernel: [   38.067789] usbcore: registered
new device driver usb
Mar  9 15:06:59 Aula2Server kernel: [   38.096878] USB Universal Host
Controller Interface driver v3.0
Mar  9 15:06:59 Aula2Server kernel: [   38.111658] ACPI: PCI Interrupt
0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 18
Mar  9 15:06:59 Aula2Server kernel: [   38.126830] PCI: Setting latency
timer of device 0000:00:1d.0 to 64
Mar  9 15:06:59 Aula2Server kernel: [   38.126835] uhci_hcd
0000:00:1d.0: UHCI Host Controller
Mar  9 15:06:59 Aula2Server kernel: [   38.142025] uhci_hcd
0000:00:1d.0: new USB bus registered, assigned bus number 1
Mar  9 15:06:59 Aula2Server kernel: [   38.157422] uhci_hcd
0000:00:1d.0: irq 18, io base 0x00007000
Mar  9 15:06:59 Aula2Server kernel: [   38.172871] usb usb1:
configuration #1 chosen from 1 choice
Mar  9 15:06:59 Aula2Server kernel: [   38.188124] hub 1-0:1.0: USB hub
found
Mar  9 15:06:59 Aula2Server kernel: [   38.203510] hub 1-0:1.0: 2 ports
detected
Mar  9 15:06:59 Aula2Server kernel: [   38.219197] SCSI subsystem
initialized
Mar  9 15:06:59 Aula2Server kernel: [   38.265848] libata version 3.00
loaded.
Mar  9 15:06:59 Aula2Server kernel: [   38.311893] Floppy drive(s): fd0
is 1.44M
Mar  9 15:06:59 Aula2Server kernel: [   38.327856] ACPI: PCI Interrupt
0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 19
Mar  9 15:06:59 Aula2Server kernel: [   38.343352] PCI: Setting latency
timer of device 0000:00:1d.1 to 64
Mar  9 15:06:59 Aula2Server kernel: [   38.343356] uhci_hcd
0000:00:1d.1: UHCI Host Controller
Mar  9 15:06:59 Aula2Server kernel: [   38.358685] uhci_hcd
0000:00:1d.1: new USB bus registered, assigned bus number 2
Mar  9 15:06:59 Aula2Server kernel: [   38.373831] uhci_hcd
0000:00:1d.1: irq 19, io base 0x00007400
Mar  9 15:06:59 Aula2Server kernel: [   38.388982] usb usb2:
configuration #1 chosen from 1 choice
Mar  9 15:06:59 Aula2Server kernel: [   38.403960] hub 2-0:1.0: USB hub
found
Mar  9 15:06:59 Aula2Server kernel: [   38.418524] hub 2-0:1.0: 2 ports
detected
Mar  9 15:06:59 Aula2Server kernel: [   38.436832] FDC 0 is a post-1991
82077
Mar  9 15:06:59 Aula2Server kernel: [   38.539228] ACPI: PCI Interrupt
0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 20
Mar  9 15:06:59 Aula2Server kernel: [   38.553993] PCI: Setting latency
timer of device 0000:00:1d.2 to 64
Mar  9 15:06:59 Aula2Server kernel: [   38.553997] uhci_hcd
0000:00:1d.2: UHCI Host Controller
Mar  9 15:06:59 Aula2Server kernel: [   38.568463] uhci_hcd
0000:00:1d.2: new USB bus registered, assigned bus number 3
Mar  9 15:06:59 Aula2Server kernel: [   38.583302] uhci_hcd
0000:00:1d.2: irq 20, io base 0x00007800
Mar  9 15:06:59 Aula2Server kernel: [   38.598151] usb usb3:
configuration #1 chosen from 1 choice
Mar  9 15:06:59 Aula2Server kernel: [   38.612778] hub 3-0:1.0: USB hub
found
Mar  9 15:06:59 Aula2Server kernel: [   38.627246] hub 3-0:1.0: 2 ports
detected
Mar  9 15:06:59 Aula2Server kernel: [   38.749133] ACPI: PCI Interrupt
0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 17
Mar  9 15:06:59 Aula2Server kernel: [   38.763763] PCI: Setting latency
timer of device 0000:00:1d.3 to 64
Mar  9 15:06:59 Aula2Server kernel: [   38.763767] uhci_hcd
0000:00:1d.3: UHCI Host Controller
Mar  9 15:06:59 Aula2Server kernel: [   38.778470] uhci_hcd
0000:00:1d.3: new USB bus registered, assigned bus number 4
Mar  9 15:06:59 Aula2Server kernel: [   38.793209] uhci_hcd
0000:00:1d.3: irq 17, io base 0x00008000
Mar  9 15:06:59 Aula2Server kernel: [   38.807799] usb usb4:
configuration #1 chosen from 1 choice
Mar  9 15:06:59 Aula2Server kernel: [   38.822137] hub 4-0:1.0: USB hub
found
Mar  9 15:06:59 Aula2Server kernel: [   38.831550] usb 2-1: new full
speed USB device using uhci_hcd and address 2
Mar  9 15:06:59 Aula2Server kernel: [   38.850895] hub 4-0:1.0: 2 ports
detected
Mar  9 15:06:59 Aula2Server kernel: [   38.969172] ACPI: PCI Interrupt
0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 18
Mar  9 15:06:59 Aula2Server kernel: [   38.984056] PCI: Setting latency
timer of device 0000:00:1d.7 to 64
Mar  9 15:06:59 Aula2Server kernel: [   38.984060] ehci_hcd
0000:00:1d.7: EHCI Host Controller
Mar  9 15:06:59 Aula2Server kernel: [   38.998920] ehci_hcd
0000:00:1d.7: new USB bus registered, assigned bus number 5
Mar  9 15:06:59 Aula2Server kernel: [   39.032427] PCI: cache line size
of 128 is not supported by device 0000:00:1d.7
Mar  9 15:06:59 Aula2Server kernel: [   39.032436] ehci_hcd
0000:00:1d.7: irq 18, io mem 0xddfff800
Mar  9 15:06:59 Aula2Server kernel: [   39.034759] usb 2-1:
configuration #1 chosen from 1 choice
Mar  9 15:06:59 Aula2Server kernel: [   39.081459] ehci_hcd
0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Mar  9 15:06:59 Aula2Server kernel: [   39.096494] usb usb5:
configuration #1 chosen from 1 choice
Mar  9 15:06:59 Aula2Server kernel: [   39.111809] hub 5-0:1.0: USB hub
found
Mar  9 15:06:59 Aula2Server kernel: [   39.127194] hub 5-0:1.0: 8 ports
detected
Mar  9 15:06:59 Aula2Server kernel: [   39.248996] pata_it821x:
controller in pass through mode.
Mar  9 15:06:59 Aula2Server kernel: [   39.264736] ACPI: PCI Interrupt
0000:01:03.0[A] -> GSI 20 (level, low) -> IRQ 18
Mar  9 15:06:59 Aula2Server kernel: [   39.280741] PCI: Setting latency
timer of device 0000:01:03.0 to 64
Mar  9 15:06:59 Aula2Server kernel: [   39.280821] scsi0 : pata_it821x
Mar  9 15:06:59 Aula2Server kernel: [   39.297010] scsi1 : pata_it821x
Mar  9 15:06:59 Aula2Server kernel: [   39.313169] ata1: PATA max
UDMA/133 cmd 0xc800 ctl 0xc400 bmdma 0xb400 irq 18
Mar  9 15:06:59 Aula2Server kernel: [   39.329669] ata2: PATA max
UDMA/133 cmd 0xc000 ctl 0xb800 bmdma 0xb408 irq 18
Mar  9 15:06:59 Aula2Server kernel: [   39.391348] usb 2-1: USB
disconnect, address 2
Mar  9 15:06:59 Aula2Server kernel: [   39.568094] ata1.00: ATA-7:
MAXTOR STM3160212A, 3.AAJ, max UDMA/100
Mar  9 15:06:59 Aula2Server kernel: [   39.584975] ata1.00: 312581808
sectors, multi 0: LBA48
Mar  9 15:06:59 Aula2Server kernel: [   39.676123] ata1.00: configured
for UDMA/100
Mar  9 15:06:59 Aula2Server kernel: [   39.861468] scsi 0:0:0:0:
Direct-Access     ATA      MAXTOR STM316021 3.AA PQ: 0 ANSI: 5
Mar  9 15:06:59 Aula2Server kernel: [   39.878895] ahci 0000:00:1f.2:
version 3.0
Mar  9 15:06:59 Aula2Server kernel: [   39.878923] ACPI: PCI Interrupt
0000:00:1f.2[B] -> GSI 23 (level, low) -> IRQ 21
Mar  9 15:06:59 Aula2Server kernel: [   39.903220] Driver 'sd' needs
updating - please use bus_type methods
Mar  9 15:06:59 Aula2Server kernel: [   39.920823] sd 0:0:0:0: [sda]
312581808 512-byte hardware sectors (160042 MB)
Mar  9 15:06:59 Aula2Server kernel: [   39.938397] sd 0:0:0:0: [sda]
Write Protect is off
Mar  9 15:06:59 Aula2Server kernel: [   39.956095] sd 0:0:0:0: [sda]
Mode Sense: 00 3a 00 00
Mar  9 15:06:59 Aula2Server kernel: [   39.956116] sd 0:0:0:0: [sda]
Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  9 15:06:59 Aula2Server kernel: [   39.974111] sd 0:0:0:0: [sda]
312581808 512-byte hardware sectors (160042 MB)
Mar  9 15:06:59 Aula2Server kernel: [   39.992183] sd 0:0:0:0: [sda]
Write Protect is off
Mar  9 15:06:59 Aula2Server kernel: [   40.010115] sd 0:0:0:0: [sda]
Mode Sense: 00 3a 00 00
Mar  9 15:06:59 Aula2Server kernel: [   40.010147] sd 0:0:0:0: [sda]
Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  9 15:06:59 Aula2Server kernel: [   40.028578]  sda: sda1 sda2 sda3 sda4
Mar  9 15:06:59 Aula2Server kernel: [   40.066346] sd 0:0:0:0: [sda]
Attached SCSI disk
Mar  9 15:06:59 Aula2Server kernel: [   40.089984] sd 0:0:0:0: Attached
scsi generic sg0 type 0
Mar  9 15:06:59 Aula2Server kernel: [   40.161024] usb 5-5: new high
speed USB device using ehci_hcd and address 3
Mar  9 15:06:59 Aula2Server kernel: [   40.306746] md: md0 stopped.
Mar  9 15:06:59 Aula2Server kernel: [   40.343036] usb 5-5:
configuration #1 chosen from 1 choice
Mar  9 15:06:59 Aula2Server kernel: [   40.494962] md: bind<sda1>
Mar  9 15:06:59 Aula2Server kernel: [   40.513026] md: md1 stopped.
Mar  9 15:06:59 Aula2Server kernel: [   40.531283] md: md2 stopped.
Mar  9 15:06:59 Aula2Server kernel: [   40.549258] md: md3 stopped.
Mar  9 15:06:59 Aula2Server kernel: [   40.581673] md: md0 stopped.
Mar  9 15:06:59 Aula2Server kernel: [   40.599291] md: unbind<sda1>
Mar  9 15:06:59 Aula2Server kernel: [   40.616454] md: export_rdev(sda1)
Mar  9 15:06:59 Aula2Server kernel: [   40.620975] usbcore: registered
new interface driver libusual
Mar  9 15:06:59 Aula2Server kernel: [   40.656224] Initializing USB Mass
Storage driver...
Mar  9 15:06:59 Aula2Server kernel: [   40.777506] md: bind<sda1>
Mar  9 15:06:59 Aula2Server kernel: [   40.794687] md: md1 stopped.
Mar  9 15:06:59 Aula2Server kernel: [   40.900273] md: bind<sda2>
Mar  9 15:06:59 Aula2Server kernel: [   40.900766] ahci 0000:00:1f.2:
AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
Mar  9 15:06:59 Aula2Server kernel: [   40.900772] ahci 0000:00:1f.2:
flags: 64bit ncq led clo pio slum part
Mar  9 15:06:59 Aula2Server kernel: [   40.900779] PCI: Setting latency
timer of device 0000:00:1f.2 to 64
Mar  9 15:06:59 Aula2Server kernel: [   40.901036] scsi2 : ahci
Mar  9 15:06:59 Aula2Server kernel: [   40.968717] usb 2-1: new full
speed USB device using uhci_hcd and address 3
Mar  9 15:06:59 Aula2Server kernel: [   40.968733] md: md2 stopped.
Mar  9 15:06:59 Aula2Server kernel: [   41.003182] scsi3 : ahci
Mar  9 15:06:59 Aula2Server kernel: [   41.020174] scsi4 : ahci
Mar  9 15:06:59 Aula2Server kernel: [   41.037090] scsi5 : ahci
Mar  9 15:06:59 Aula2Server kernel: [   41.053715] ata3: SATA max
UDMA/133 abar m1024@0xddfffc00 port 0xddfffd00 irq 221
Mar  9 15:06:59 Aula2Server kernel: [   41.070763] ata4: SATA max
UDMA/133 abar m1024@0xddfffc00 port 0xddfffd80 irq 221
Mar  9 15:06:59 Aula2Server kernel: [   41.070766] ata5: SATA max
UDMA/133 abar m1024@0xddfffc00 port 0xddfffe00 irq 221
Mar  9 15:06:59 Aula2Server kernel: [   41.103796] ata6: SATA max
UDMA/133 abar m1024@0xddfffc00 port 0xddfffe80 irq 221
Mar  9 15:06:59 Aula2Server kernel: [   41.156147] md: bind<sda3>
Mar  9 15:06:59 Aula2Server kernel: [   41.172230] md: md3 stopped.
Mar  9 15:06:59 Aula2Server kernel: [   41.223291] md: bind<sda4>
Mar  9 15:06:59 Aula2Server kernel: [   41.239977] usb 2-1:
configuration #1 chosen from 1 choice
Mar  9 15:06:59 Aula2Server kernel: [   41.548014] usb 3-2: new low
speed USB device using uhci_hcd and address 2
Mar  9 15:06:59 Aula2Server kernel: [   41.610508] ata3: SATA link up
3.0 Gbps (SStatus 123 SControl 300)
Mar  9 15:06:59 Aula2Server kernel: [   41.627019] ata3.00: ATA-7:
Hitachi HDS721616PLA380, P22OA50U, max UDMA/133
Mar  9 15:06:59 Aula2Server kernel: [   41.642880] ata3.00: 321672960
sectors, multi 16: LBA48 NCQ (depth 31/32)
Mar  9 15:06:59 Aula2Server kernel: [   41.659864] ata3.00: configured
for UDMA/133
Mar  9 15:06:59 Aula2Server kernel: [   41.754793] usb 3-2:
configuration #1 chosen from 1 choice
Mar  9 15:06:59 Aula2Server kernel: [   41.785170] scsi6 : SCSI
emulation for USB Mass Storage devices
Mar  9 15:06:59 Aula2Server kernel: [   41.801968] usbcore: registered
new interface driver usb-storage
Mar  9 15:06:59 Aula2Server kernel: [   41.807916] usbcore: registered
new interface driver hiddev
Mar  9 15:06:59 Aula2Server kernel: [   41.807945] usb-storage: device
found at 3
Mar  9 15:06:59 Aula2Server kernel: [   41.807947] usb-storage: waiting
for device to settle before scanning
Mar  9 15:06:59 Aula2Server kernel: [   41.833257] USB Mass Storage
support registered.
Mar  9 15:06:59 Aula2Server kernel: [   41.848902] input: Microsoft
Microsoft 3-Button Mouse with IntelliEye(TM) as
/devices/pci0000:00/0000:00:1d.2/usb3/3-2/3-2:1.0/input/input2
Mar  9 15:06:59 Aula2Server kernel: [   41.897918] input,hidraw0: USB
HID v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)]
on usb-0000:00:1d.2-2
Mar  9 15:06:59 Aula2Server kernel: [   41.914610] usbcore: registered
new interface driver usbhid
Mar  9 15:06:59 Aula2Server kernel: [   41.931331]
/build/buildd/linux-2.6.24/drivers/hid/usbhid/hid-core.c: v2.6:USB HID
core driver
Mar  9 15:06:59 Aula2Server kernel: [   42.000316] ata4: SATA link down
(SStatus 0 SControl 300)
Mar  9 15:06:59 Aula2Server kernel: [   42.340182] ata5: SATA link down
(SStatus 0 SControl 300)
Mar  9 15:06:59 Aula2Server kernel: [   42.677555] ata6: SATA link down
(SStatus 0 SControl 300)
Mar  9 15:06:59 Aula2Server kernel: [   42.694633] scsi 2:0:0:0:
Direct-Access     ATA      Hitachi HDS72161 P22O PQ: 0 ANSI: 5
Mar  9 15:06:59 Aula2Server kernel: [   42.711952] sd 2:0:0:0: [sdb]
321672960 512-byte hardware sectors (164697 MB)
Mar  9 15:06:59 Aula2Server kernel: [   42.729241] sd 2:0:0:0: [sdb]
Write Protect is off
Mar  9 15:06:59 Aula2Server kernel: [   42.746226] sd 2:0:0:0: [sdb]
Mode Sense: 00 3a 00 00
Mar  9 15:06:59 Aula2Server kernel: [   42.746248] sd 2:0:0:0: [sdb]
Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  9 15:06:59 Aula2Server kernel: [   42.763679] sd 2:0:0:0: [sdb]
321672960 512-byte hardware sectors (164697 MB)
Mar  9 15:06:59 Aula2Server kernel: [   42.780736] sd 2:0:0:0: [sdb]
Write Protect is off
Mar  9 15:06:59 Aula2Server kernel: [   42.797726] sd 2:0:0:0: [sdb]
Mode Sense: 00 3a 00 00
Mar  9 15:06:59 Aula2Server kernel: [   42.797747] sd 2:0:0:0: [sdb]
Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  9 15:06:59 Aula2Server kernel: [   42.814756]  sdb: sdb1 sdb2 sdb3 sdb4
Mar  9 15:06:59 Aula2Server kernel: [   42.841621] sd 2:0:0:0: [sdb]
Attached SCSI disk
Mar  9 15:06:59 Aula2Server kernel: [   42.858465] sd 2:0:0:0: Attached
scsi generic sg1 type 0
Mar  9 15:06:59 Aula2Server kernel: [   42.875379] ata_piix
0000:00:1f.1: version 2.12
Mar  9 15:06:59 Aula2Server kernel: [   42.875404] ACPI: PCI Interrupt
0000:00:1f.1[A] -> GSI 22 (level, low) -> IRQ 22
Mar  9 15:06:59 Aula2Server kernel: [   42.892336] PCI: Setting latency
timer of device 0000:00:1f.1 to 64
Mar  9 15:06:59 Aula2Server kernel: [   42.892933] scsi7 : ata_piix
Mar  9 15:06:59 Aula2Server kernel: [   42.909788] scsi8 : ata_piix
Mar  9 15:06:59 Aula2Server kernel: [   42.927214] ata7: PATA max
UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
Mar  9 15:06:59 Aula2Server kernel: [   42.943995] ata8: PATA max
UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
Mar  9 15:06:59 Aula2Server kernel: [   43.042298] md: md0 stopped.
Mar  9 15:06:59 Aula2Server kernel: [   43.058693] md: unbind<sda1>
Mar  9 15:06:59 Aula2Server kernel: [   43.074828] md: export_rdev(sda1)
Mar  9 15:06:59 Aula2Server kernel: [   43.133664] md: bind<sda1>
Mar  9 15:06:59 Aula2Server kernel: [   43.149660] md: bind<sdb1>
Mar  9 15:06:59 Aula2Server kernel: [   43.172636] raid1: raid set md0
active with 2 out of 2 mirrors
Mar  9 15:06:59 Aula2Server kernel: [   43.188913] md: md1 stopped.
Mar  9 15:06:59 Aula2Server kernel: [   43.204983] md: unbind<sda2>
Mar  9 15:06:59 Aula2Server kernel: [   43.221287] md: export_rdev(sda2)
Mar  9 15:06:59 Aula2Server kernel: [   43.293394] md: bind<sda2>
Mar  9 15:06:59 Aula2Server kernel: [   43.300187] ata7.00: ATAPI:
HL-DT-STDVD-ROM GDR8161B, 0100, max UDMA/33
Mar  9 15:06:59 Aula2Server kernel: [   43.326478] md: md2 stopped.
Mar  9 15:06:59 Aula2Server kernel: [   43.342759] md: unbind<sda3>
Mar  9 15:06:59 Aula2Server kernel: [   43.359038] md: export_rdev(sda3)
Mar  9 15:06:59 Aula2Server kernel: [   43.441271] md: bind<sda3>
Mar  9 15:06:59 Aula2Server kernel: [   43.457449] md: md3 stopped.
Mar  9 15:06:59 Aula2Server kernel: [   43.473519] md: unbind<sda4>
Mar  9 15:06:59 Aula2Server kernel: [   43.489326] md: export_rdev(sda4)
Mar  9 15:06:59 Aula2Server kernel: [   43.500035] ata7.00: configured
for UDMA/33
Mar  9 15:06:59 Aula2Server kernel: [   43.591570] md: bind<sda4>
Mar  9 15:06:59 Aula2Server kernel: [   43.653662] md: md1 stopped.
Mar  9 15:06:59 Aula2Server kernel: [   43.669115] md: unbind<sda2>
Mar  9 15:06:59 Aula2Server kernel: [   43.684577] md: export_rdev(sda2)
Mar  9 15:06:59 Aula2Server kernel: [   43.721132] md: bind<sda2>
Mar  9 15:06:59 Aula2Server kernel: [   43.736526] scsi 7:0:0:0: CD-ROM
           HL-DT-ST DVD-ROM GDR8161B 0100 PQ: 0 ANSI: 5
Mar  9 15:06:59 Aula2Server kernel: [   43.752602] scsi 7:0:0:0:
Attached scsi generic sg2 type 5
Mar  9 15:06:59 Aula2Server kernel: [   43.769098] md: bind<sdb2>
Mar  9 15:06:59 Aula2Server kernel: [   43.793979] raid1: raid set md1
active with 2 out of 2 mirrors
Mar  9 15:06:59 Aula2Server kernel: [   43.810374] md: md2 stopped.
Mar  9 15:06:59 Aula2Server kernel: [   43.826416] md: unbind<sda3>
Mar  9 15:06:59 Aula2Server kernel: [   43.842645] md: export_rdev(sda3)
Mar  9 15:06:59 Aula2Server kernel: [   43.882685] Driver 'sr' needs
updating - please use bus_type methods
Mar  9 15:06:59 Aula2Server kernel: [   43.922426] sr0: scsi3-mmc drive:
20x/48x cd/rw xa/form2 cdda tray
Mar  9 15:06:59 Aula2Server kernel: [   43.938597] Uniform CD-ROM driver
Revision: 3.20
Mar  9 15:06:59 Aula2Server kernel: [   43.954789] sr 7:0:0:0: Attached
scsi CD-ROM sr0
Mar  9 15:06:59 Aula2Server kernel: [   43.969342] md: bind<sda3>
Mar  9 15:06:59 Aula2Server kernel: [   43.985179] md: bind<sdb3>
Mar  9 15:06:59 Aula2Server kernel: [   44.009276] raid1: raid set md2
active with 2 out of 2 mirrors
Mar  9 15:06:59 Aula2Server kernel: [   44.025259] md: md3 stopped.
Mar  9 15:06:59 Aula2Server kernel: [   44.040925] md: unbind<sda4>
Mar  9 15:06:59 Aula2Server kernel: [   44.056168] md: export_rdev(sda4)
Mar  9 15:06:59 Aula2Server kernel: [   44.173805] md: bind<sda4>
Mar  9 15:06:59 Aula2Server kernel: [   44.189263] md: bind<sdb4>
Mar  9 15:06:59 Aula2Server kernel: [   44.210973] raid1: raid set md3
active with 2 out of 2 mirrors
Mar  9 15:06:59 Aula2Server kernel: [   44.514494] Attempting manual resume
Mar  9 15:06:59 Aula2Server kernel: [   44.529052] swsusp: Resume From
Partition 9:3
Mar  9 15:06:59 Aula2Server kernel: [   44.529054] PM: Checking swsusp
image.
Mar  9 15:06:59 Aula2Server kernel: [   44.566182] JFS: nTxBlock = 8192,
nTxLock = 65536
Mar  9 15:06:59 Aula2Server kernel: [   46.796089] usb-storage: device
scan complete
Mar  9 15:06:59 Aula2Server kernel: [   46.796581] scsi 6:0:0:0:
Direct-Access              USB Flash Memory 1.04 PQ: 0 ANSI: 0 CCS
Mar  9 15:06:59 Aula2Server kernel: [   46.825045] sd 6:0:0:0: [sdc]
1001472 512-byte hardware sectors (513 MB)
Mar  9 15:06:59 Aula2Server kernel: [   46.839413] sd 6:0:0:0: [sdc]
Write Protect is off
Mar  9 15:06:59 Aula2Server kernel: [   46.853016] sd 6:0:0:0: [sdc]
Mode Sense: 23 00 00 00
Mar  9 15:06:59 Aula2Server kernel: [   46.853018] sd 6:0:0:0: [sdc]
Assuming drive cache: write through
Mar  9 15:06:59 Aula2Server kernel: [   46.869402] sd 6:0:0:0: [sdc]
1001472 512-byte hardware sectors (513 MB)
Mar  9 15:06:59 Aula2Server kernel: [   46.883648] sd 6:0:0:0: [sdc]
Write Protect is off
Mar  9 15:06:59 Aula2Server kernel: [   46.897481] sd 6:0:0:0: [sdc]
Mode Sense: 23 00 00 00
Mar  9 15:06:59 Aula2Server kernel: [   46.897483] sd 6:0:0:0: [sdc]
Assuming drive cache: write through
Mar  9 15:06:59 Aula2Server kernel: [   46.911196]  sdc: sdc1
Mar  9 15:06:59 Aula2Server kernel: [   46.926164] sd 6:0:0:0: [sdc]
Attached SCSI removable disk
Mar  9 15:06:59 Aula2Server kernel: [   46.940128] sd 6:0:0:0: Attached
scsi generic sg3 type 0
Mar  9 15:06:59 Aula2Server kernel: [   54.623235] input: PC Speaker as
/devices/platform/pcspkr/input/input3
Mar  9 15:06:59 Aula2Server kernel: [   54.695500] pci_hotplug: PCI Hot
Plug PCI Core version: 0.5
Mar  9 15:06:59 Aula2Server kernel: [   54.725492] shpchp: Standard Hot
Plug PCI Controller Driver version: 0.4
Mar  9 15:06:59 Aula2Server kernel: [   54.772117] parport_pc 00:07:
reported by Plug and Play ACPI
Mar  9 15:06:59 Aula2Server kernel: [   54.786782] parport0: PC-style at
0x378, irq 7 [PCSPP,TRISTATE]
Mar  9 15:06:59 Aula2Server kernel: [   54.802356] input: Power Button
(FF) as /devices/virtual/input/input4
Mar  9 15:06:59 Aula2Server kernel: [   54.865419] Linux agpgart
interface v0.102
Mar  9 15:06:59 Aula2Server kernel: [   55.175298] ACPI: Power Button
(FF) [PWRF]
Mar  9 15:06:59 Aula2Server kernel: [   55.190690] input: Power Button
(CM) as /devices/virtual/input/input5
Mar  9 15:06:59 Aula2Server kernel: [   55.335233] ACPI: Power Button
(CM) [PWRB]
Mar  9 15:06:59 Aula2Server kernel: [   55.422720] ACPI: PCI Interrupt
0000:02:00.0[A] -> GSI 19 (level, low) -> IRQ 17
Mar  9 15:06:59 Aula2Server kernel: [   55.438864] PCI: Setting latency
timer of device 0000:02:00.0 to 64
Mar  9 15:06:59 Aula2Server kernel: [   55.438890] sky2 0000:02:00.0:
v1.20 addr 0xdfffc000 irq 17 Yukon-EC (0xb6) rev 2
Mar  9 15:06:59 Aula2Server kernel: [   55.455501] sky2 eth0: addr
00:17:31:f4:aa:d9
Mar  9 15:06:59 Aula2Server kernel: [   55.701555] ACPI: PCI Interrupt
0000:00:1b.0[A] -> GSI 19 (level, low) -> IRQ 17
Mar  9 15:06:59 Aula2Server kernel: [   55.718619] PCI: Setting latency
timer of device 0000:00:1b.0 to 64
Mar  9 15:06:59 Aula2Server kernel: [   55.719581] Linux video capture
interface: v2.00
Mar  9 15:06:59 Aula2Server kernel: [   55.740469]
/build/buildd/linux-ubuntu-modules-2.6.24-2.6.24/debian/build/build-server/media/gspcav1/gspca_core.c:
USB GSPCA camera found. SONIX sn9c10[1 2]
Mar  9 15:06:59 Aula2Server kernel: [   55.759595] usbcore: registered
new interface driver gspca
Mar  9 15:06:59 Aula2Server kernel: [   55.777128]
/build/buildd/linux-ubuntu-modules-2.6.24-2.6.24/debian/build/build-server/media/gspcav1/gspca_core.c:
gspca driver 01.00.20 registered
Mar  9 15:06:59 Aula2Server kernel: [   55.868181] sn9c102: V4L2 driver
for SN9C1xx PC Camera Controllers v1:1.47
Mar  9 15:06:59 Aula2Server kernel: [   55.886958] usbcore: registered
new interface driver sn9c102
Mar  9 15:06:59 Aula2Server kernel: [   56.528261] sky2 eth0: enabling
interface
Mar  9 15:06:59 Aula2Server kernel: [   56.769984] NET: Registered
protocol family 10
Mar  9 15:06:59 Aula2Server kernel: [   56.788745] lo: Disabled Privacy
Extensions
Mar  9 15:06:59 Aula2Server kernel: [   56.807994] ADDRCONF(NETDEV_UP):
eth0: link is not ready
Mar  9 15:06:59 Aula2Server kernel: [   57.767539] loop: module loaded
Mar  9 15:06:59 Aula2Server kernel: [   57.816659] lp0: using parport0
(interrupt-driven).
Mar  9 15:06:59 Aula2Server kernel: [   57.939486] Adding 513976k swap
on /dev/md3.  Priority:-1 extents:1 across:513976k
Mar  9 15:06:59 Aula2Server kernel: [   58.214340] sky2 eth0: Link is up
at 100 Mbps, full duplex, flow control rx
Mar  9 15:06:59 Aula2Server kernel: [   58.216398]
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Mar  9 15:06:59 Aula2Server kernel: [   68.627765] eth0: no IPv6 routers
present
Mar  9 15:06:59 Aula2Server kernel: [   72.171243] kjournald starting.
Commit interval 5 seconds
Mar  9 15:06:59 Aula2Server kernel: [   72.202138] EXT3 FS on md0,
internal journal
Mar  9 15:06:59 Aula2Server kernel: [   72.202146] EXT3-fs: mounted
filesystem with journal data mode.
Mar  9 15:06:59 Aula2Server kernel: [   72.382632] kjournald starting.
Commit interval 5 seconds
Mar  9 15:06:59 Aula2Server kernel: [   72.382640] EXT3-fs: mounted
filesystem with journal data mode.
Mar  9 15:06:59 Aula2Server kernel: [   73.604691] ip_tables: (C)
2000-2006 Netfilter Core Team
Mar  9 15:06:59 Aula2Server kernel: [   74.171555] w83627ehf: Found
W83627EHG chip at 0x290
Mar  9 15:06:59 Aula2Server kernel: [   75.394100] No dock devices found.
Mar  9 15:06:59 Aula2Server NetworkManager: <info>  starting...
Mar  9 15:07:01 Aula2Server named[5713]: starting BIND 9.4.2-P2 -u bind
Mar  9 15:07:01 Aula2Server named[5713]: found 2 CPUs, using 2 worker
threads
Mar  9 15:07:01 Aula2Server named[5713]: listening on IPv6 interfaces,
port 53
Mar  9 15:07:01 Aula2Server named[5713]: listening on IPv4 interface lo,
127.0.0.1#53
Mar  9 15:07:01 Aula2Server named[5713]: listening on IPv4 interface
eth0, 192.168.0.40#53
Mar  9 15:07:01 Aula2Server named[5713]: automatic empty zone:
254.169.IN-ADDR.ARPA
Mar  9 15:07:01 Aula2Server named[5713]: automatic empty zone:
2.0.192.IN-ADDR.ARPA
Mar  9 15:07:01 Aula2Server named[5713]: automatic empty zone:
255.255.255.255.IN-ADDR.ARPA
Mar  9 15:07:01 Aula2Server named[5713]: automatic empty zone:
0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.IP6.ARPA
Mar  9 15:07:01 Aula2Server named[5713]: automatic empty zone:
1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.IP6.ARPA
Mar  9 15:07:01 Aula2Server named[5713]: automatic empty zone: D.F.IP6.ARPA
Mar  9 15:07:01 Aula2Server named[5713]: automatic empty zone:
8.E.F.IP6.ARPA
Mar  9 15:07:01 Aula2Server named[5713]: automatic empty zone:
9.E.F.IP6.ARPA
Mar  9 15:07:01 Aula2Server named[5713]: automatic empty zone:
A.E.F.IP6.ARPA
Mar  9 15:07:01 Aula2Server named[5713]: automatic empty zone:
B.E.F.IP6.ARPA
Mar  9 15:07:01 Aula2Server named[5713]: command channel listening on
127.0.0.1#953
Mar  9 15:07:01 Aula2Server named[5713]: command channel listening on
::1#953
Mar  9 15:07:01 Aula2Server named[5713]: zone 0.in-addr.arpa/IN: loaded
serial 1
Mar  9 15:07:01 Aula2Server named[5713]: zone 10.in-addr.arpa/IN: loaded
serial 1
Mar  9 15:07:01 Aula2Server named[5713]: zone 127.in-addr.arpa/IN:
loaded serial 2008041601
Mar  9 15:07:01 Aula2Server named[5713]: zone 16.172.in-addr.arpa/IN:
loaded serial 1
Mar  9 15:07:01 Aula2Server named[5713]: zone 17.172.in-addr.arpa/IN:
loaded serial 1
Mar  9 15:07:01 Aula2Server named[5713]: zone 18.172.in-addr.arpa/IN:
loaded serial 1
Mar  9 15:07:01 Aula2Server named[5713]: zone 19.172.in-addr.arpa/IN:
loaded serial 1
Mar  9 15:07:01 Aula2Server named[5713]: zone 20.172.in-addr.arpa/IN:
loaded serial 1
Mar  9 15:07:01 Aula2Server named[5713]: zone 21.172.in-addr.arpa/IN:
loaded serial 1
Mar  9 15:07:01 Aula2Server named[5713]: zone 22.172.in-addr.arpa/IN:
loaded serial 1
Mar  9 15:07:01 Aula2Server named[5713]: zone 23.172.in-addr.arpa/IN:
loaded serial 1
Mar  9 15:07:01 Aula2Server named[5713]: zone 24.172.in-addr.arpa/IN:
loaded serial 1
Mar  9 15:07:01 Aula2Server named[5713]: zone 25.172.in-addr.arpa/IN:
loaded serial 1
Mar  9 15:07:01 Aula2Server named[5713]: zone 26.172.in-addr.arpa/IN:
loaded serial 1
Mar  9 15:07:01 Aula2Server named[5713]: zone 27.172.in-addr.arpa/IN:
loaded serial 1
Mar  9 15:07:01 Aula2Server named[5713]: zone 28.172.in-addr.arpa/IN:
loaded serial 1
Mar  9 15:07:01 Aula2Server named[5713]: zone 29.172.in-addr.arpa/IN:
loaded serial 1
Mar  9 15:07:01 Aula2Server named[5713]: zone 30.172.in-addr.arpa/IN:
loaded serial 1
Mar  9 15:07:01 Aula2Server named[5713]: zone 31.172.in-addr.arpa/IN:
loaded serial 1
Mar  9 15:07:01 Aula2Server named[5713]: zone 168.192.in-addr.arpa/IN:
loaded serial 2008110601
Mar  9 15:07:01 Aula2Server named[5713]: zone 255.in-addr.arpa/IN:
loaded serial 1
Mar  9 15:07:01 Aula2Server named[5713]: zone localhost/IN: loaded serial 2
Mar  9 15:07:01 Aula2Server named[5713]: zone aula2.org/IN: loaded
serial 2008110601
Mar  9 15:07:01 Aula2Server named[5713]: running
Mar  9 15:07:02 Aula2Server /etc/mysql/debian-start[5886]: Upgrading
MySQL tables if necessary.
Mar  9 15:07:02 Aula2Server /etc/mysql/debian-start[5896]: Looking for
'mysql' in: /usr/bin/mysql
Mar  9 15:07:02 Aula2Server /etc/mysql/debian-start[5896]: Looking for
'mysqlcheck' in: /usr/bin/mysqlcheck
Mar  9 15:07:02 Aula2Server /etc/mysql/debian-start[5896]: This
installation of MySQL is already upgraded to 5.0.51a, use --force if you
still need to run mysql_upgrade
Mar  9 15:07:02 Aula2Server /etc/mysql/debian-start[5904]: Checking for
insecure root accounts.
Mar  9 15:07:02 Aula2Server kernel: [   79.439921] apm: BIOS version 1.2
Flags 0x03 (Driver version 1.16ac)
Mar  9 15:07:02 Aula2Server kernel: [   79.439929] apm: disabled - APM
is not SMP safe.
Mar  9 15:07:04 Aula2Server postfix/master[6023]: daemon started --
version 2.5.1, configuration /etc/postfix
Mar  9 15:07:04 Aula2Server smartd[6039]: Drive: DEVICESCAN, implied
'-a' Directive on line 22 of file /etc/smartd.conf
Mar  9 15:07:04 Aula2Server smartd[6039]: Configuration file
/etc/smartd.conf was parsed, found DEVICESCAN, scanning devices
Mar  9 15:07:06 Aula2Server kernel: [   82.892734] usb 5-5: reset high
speed USB device using ehci_hcd and address 3
Mar  9 15:07:06 Aula2Server kernel: [   83.182747] usb 5-5: reset high
speed USB device using ehci_hcd and address 3
Mar  9 15:07:06 Aula2Server smartd[6039]: Device: /dev/sdc, not ATA, no
IDENTIFY DEVICE Structure
Mar  9 15:07:08 Aula2Server /etc/mysql/debian-start[6079]: WARNING:
mysqlcheck has found corrupt tables
Mar  9 15:07:08 Aula2Server /etc/mysql/debian-start[6079]: zm.Events
Mar  9 15:07:08 Aula2Server /etc/mysql/debian-start[6079]: warning  : 1
client is using or hasn't closed the table properly
Mar  9 15:07:08 Aula2Server /etc/mysql/debian-start[6079]: zm.Frames
Mar  9 15:07:08 Aula2Server /etc/mysql/debian-start[6079]: warning  : 1
client is using or hasn't closed the table properly
Mar  9 15:07:08 Aula2Server /etc/mysql/debian-start[6079]: zm.Monitors
Mar  9 15:07:08 Aula2Server /etc/mysql/debian-start[6079]: warning  : 1
client is using or hasn't closed the table properly
Mar  9 15:07:08 Aula2Server /etc/mysql/debian-start[6079]: zm.Zones
Mar  9 15:07:08 Aula2Server /etc/mysql/debian-start[6079]: warning  : 1
client is using or hasn't closed the table properly
Mar  9 15:07:08 Aula2Server /etc/mysql/debian-start[6079]:
Mar  9 15:07:08 Aula2Server /etc/mysql/debian-start[6079]:  Improperly
closed tables are also reported if clients are accessing
Mar  9 15:07:08 Aula2Server /etc/mysql/debian-start[6079]:  the tables
*now*. A list of current connections is below.
Mar  9 15:07:08 Aula2Server /etc/mysql/debian-start[6079]:
Mar  9 15:07:08 Aula2Server /etc/mysql/debian-start[6079]:
+----+------------------+-----------+----+---------+------+-------+------------------+
Mar  9 15:07:08 Aula2Server /etc/mysql/debian-start[6079]: | Id | User
           | Host      | db | Command | Time | State | Info             |
Mar  9 15:07:08 Aula2Server /etc/mysql/debian-start[6079]:
+----+------------------+-----------+----+---------+------+-------+------------------+
Mar  9 15:07:08 Aula2Server /etc/mysql/debian-start[6079]: | 9  | zmuser
          | localhost | zm | Sleep   | 0    |       |                  |
Mar  9 15:07:08 Aula2Server /etc/mysql/debian-start[6079]: | 13 |
debian-sys-maint | localhost |    | Query   | 0    |       | show
processlist |
Mar  9 15:07:08 Aula2Server /etc/mysql/debian-start[6079]:
+----+------------------+-----------+----+---------+------+-------+------------------+
Mar  9 15:07:08 Aula2Server /etc/mysql/debian-start[6079]: Uptime: 7
Threads: 2  Questions: 69  Slow queries: 0  Opens: 39  Flush tables: 1
Open tables: 33  Queries per second avg: 9.857
Mar  9 15:07:11 Aula2Server zmdc[6073]: ERR ['zmf -m 1' exited
abnormally, exit status 255]
Mar  9 15:07:11 Aula2Server zmdc[6073]: ERR ['zmf -m 1' exited
abnormally, exit status 255]
Mar  9 15:07:12 Aula2Server zmdc[6073]: ERR ['zma -m 1' exited
abnormally, exit status 255]
Mar  9 15:07:12 Aula2Server zmdc[6073]: ERR ['zma -m 1' exited
abnormally, exit status 255]
Mar  9 15:07:12 Aula2Server dhcdbd: Started up.
Mar  9 15:07:19 Aula2Server megatec[6393]: Startup successful
Mar  9 15:07:19 Aula2Server upsd[6394]: listening on 127.0.0.1 port 3493
Mar  9 15:07:19 Aula2Server upsd[6394]: listening on 192.168.0.40 port 3493
Mar  9 15:07:19 Aula2Server upsd[6394]: Connected to UPS
[PowerMust600USB]: megatec-PowerMust600USB
Mar  9 15:07:19 Aula2Server upsd[6395]: Startup successful
Mar  9 15:07:19 Aula2Server upsmon[6397]: Startup successful
Mar  9 15:07:19 Aula2Server upsd[6395]: Client root@127.0.0.1 logged
into UPS [PowerMust600USB]
Mar  9 15:07:20 Aula2Server upsd[6395]: Client firefly@192.168.0.1
logged into UPS [PowerMust600USB]





And here's the dmesg:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.24-23-server (buildd@vernadsky) (gcc
version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #1 SMP Mon Jan 26 00:55:21 UTC
2009 (Ubuntu 2.6.24-23.48-server)
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ffa0000 (usable)
[    0.000000]  BIOS-e820: 000000007ffa0000 - 000000007ffae000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ffae000 - 000000007ffe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
[    0.000000] 1151MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000ff780
[    0.000000] Entering add_active_range(0, 0, 524192) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   524192
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   524192
[    0.000000] On node 0 totalpages: 524192
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2303 pages used for memmap
[    0.000000]   HighMem zone: 292513 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP signature @ 0xC00FACD0 checksum 0
[    0.000000] ACPI: RSDP 000FACD0, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT 7FFA0100, 0044 (r1 A M I  OEMXSDT   7000612
MSFT       97)
[    0.000000] ACPI: FACP 7FFA0290, 00F4 (r3 A M I  OEMFACP   7000612
MSFT       97)
[    0.000000] ACPI: DSDT 7FFA0400, 8172 (r1  A0227 A0227000        0
INTL  2002026)
[    0.000000] ACPI: FACS 7FFAE000, 0040
[    0.000000] ACPI: APIC 7FFA0390, 0070 (r1 A M I  OEMAPIC   7000612
MSFT       97)
[    0.000000] ACPI: OEMB 7FFAE040, 0066 (r1 A M I  AMI_OEM   7000612
MSFT       97)
[    0.000000] ACPI: MCFG 7FFA8580, 003C (r1 A M I  OEMMCFG   7000612
MSFT       97)
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:6 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1 15:6 APIC version 20
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 88000000 (gap:
80000000:7fb80000)
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000
- 00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000
- 00000000000e4000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e4000
- 0000000000100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 520097
[    0.000000] Kernel command line: root=/dev/md1 ro noquiet nosplash
elevator=deadline acpi_osi="Linux" vga=0x307
[    0.000000] ACPI: Added _OSI(Linux)
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 3412.175 MHz processor.
[   33.456262] Console: colour dummy device 80x25
[   33.456266] console [tty0] enabled
[   33.456630] Dentry cache hash table entries: 131072 (order: 7, 524288
bytes)
[   33.456926] Inode-cache hash table entries: 65536 (order: 6, 262144
bytes)
[   33.560859] Memory: 2066276k/2096768k available (2258k kernel code,
29268k reserved, 1037k data, 384k init, 1179264k highmem)
[   33.560876] virtual kernel memory layout:
[   33.560877]     fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
[   33.560878]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[   33.560879]     vmalloc : 0xf8800000 - 0xffbfe000   ( 115 MB)
[   33.560880]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   33.560881]       .init : 0xc043e000 - 0xc049e000   ( 384 kB)
[   33.560882]       .data : 0xc03349d9 - 0xc0437fe4   (1037 kB)
[   33.560883]       .text : 0xc0100000 - 0xc03349d9   (2258 kB)
[   33.560899] Checking if this processor honours the WP bit even in
supervisor mode... Ok.
[   33.560938] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4,
CPUs=2, Nodes=1
[   33.710908] Calibrating delay using timer specific routine.. 6829.07
BogoMIPS (lpj=34145387)
[   33.710936] Security Framework initialized
[   33.710942] SELinux:  Disabled at boot.
[   33.710956] AppArmor: AppArmor initialized
[   33.710962] Failure registering capabilities with primary security
module.
[   33.710972] Mount-cache hash table entries: 512
[   33.711086] Initializing cgroup subsys ns
[   33.711092] Initializing cgroup subsys cpuacct
[   33.711106] CPU: After generic identify, caps: bfebfbff 20000000
00000000 00000000 0000e49d 00000000 00000001 00000000
[   33.711114] monitor/mwait feature present.
[   33.711118] using mwait in idle threads.
[   33.711125] CPU: Trace cache: 12K uops, L1 D cache: 16K
[   33.711129] CPU: L2 cache: 2048K
[   33.711133] CPU: Physical Processor ID: 0
[   33.711135] CPU: Processor Core ID: 0
[   33.711139] CPU: After all inits, caps: bfebfbff 20000000 00000000
00043180 0000e49d 00000000 00000001 00000000
[   33.711148] Compat vDSO mapped to ffffe000.
[   33.711164] Checking 'hlt' instruction... OK.
[   33.751357] SMP alternatives: switching to UP code
[   33.753063] Early unpacking initramfs... done
[   34.029709] ACPI: Core revision 20070126
[   34.029770] ACPI: Looking for DSDT in initramfs... error, file
/DSDT.aml not found.
[   34.044805] CPU0: Intel(R) Pentium(R) D CPU 3.40GHz stepping 05
[   34.044827] SMP alternatives: switching to SMP code
[   34.045569] Booting processor 1/1 eip 3000
[   34.075804] Initializing CPU#1
[   34.220726] Calibrating delay using timer specific routine.. 6824.41
BogoMIPS (lpj=34122066)
[   34.220735] CPU: After generic identify, caps: bfebfbff 20000000
00000000 00000000 0000e49d 00000000 00000001 00000000
[   34.220740] monitor/mwait feature present.
[   34.220745] CPU: Trace cache: 12K uops, L1 D cache: 16K
[   34.220747] CPU: L2 cache: 2048K
[   34.220749] CPU: Physical Processor ID: 0
[   34.220750] CPU: Processor Core ID: 1
[   34.220752] CPU: After all inits, caps: bfebfbff 20000000 00000000
00043180 0000e49d 00000000 00000001 00000000
[   34.221160] CPU1: Intel(R) Pentium(R) D CPU 3.40GHz stepping 05
[   34.221203] Total of 2 processors activated (13653.49 BogoMIPS).
[   34.221350] ENABLING IO-APIC IRQs
[   34.221519] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   34.440743] checking TSC synchronization [CPU#0 -> CPU#1]:
[   34.460743] Measured 17 cycles TSC warp between CPUs, turning off TSC
clock.
[   34.460748] Marking TSC unstable due to: check_tsc_sync_source failed.
[   34.460769] Brought up 2 CPUs
[   34.460798] CPU0 attaching sched-domain:
[   34.460801]  domain 0: span 03
[   34.460803]   groups: 01 02
[   34.460806] CPU1 attaching sched-domain:
[   34.460808]  domain 0: span 03
[   34.460809]   groups: 02 01
[   34.460996] net_namespace: 64 bytes
[   34.461008] Booting paravirtualized kernel on bare hardware
[   34.461534] Time: 14:06:19  Date: 03/09/09
[   34.461557] NET: Registered protocol family 16
[   34.461770] EISA bus registered
[   34.461777] ACPI: bus type pci registered
[   34.462095] PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=3
[   34.462100] PCI: Using configuration type 1
[   34.462118] Setting up standard PCI resources
[   34.471307] ACPI: EC: Look up EC in DSDT
[   34.480390] ACPI: Interpreter enabled
[   34.480395] ACPI: (supports S0 S1 S3 S4 S5)
[   34.480415] ACPI: Using IOAPIC for interrupt routing
[   34.488113] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   34.489271] PCI: Transparent bridge - 0000:00:1e.0
[   34.489304] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   34.489447] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[   34.489565] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[   34.489646] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
[   34.491980] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12
14 15)
[   34.492099] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12
14 15)
[   34.492213] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12
14 15)
[   34.492329] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12
14 15)
[   34.492444] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12
14 15)
[   34.492558] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12
14 15) *0, disabled.
[   34.492676] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12
14 15) *0, disabled.
[   34.492793] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11 12
14 15)
[   34.492929] ACPI Warning (tbutils-0217): Incorrect checksum in table
[OEMB] -  72, should be 65 [20070126]
[   34.492942] Linux Plug and Play Support v0.97 (c) Adam Belay
[   34.492978] pnp: PnP ACPI init
[   34.492988] ACPI: bus type pnp registered
[   34.497202] pnp: PnP ACPI: found 16 devices
[   34.497207] ACPI: ACPI bus type pnp unregistered
[   34.497212] PnPBIOS: Disabled by ACPI PNP
[   34.497453] PCI: Using ACPI for IRQ routing
[   34.497458] PCI: If a device doesn't work, try "pci=routeirq".  If it
helps, post a report
[   34.530732] NET: Registered protocol family 8
[   34.530736] NET: Registered protocol family 20
[   34.530768] NetLabel: Initializing
[   34.530772] NetLabel:  domain hash size = 128
[   34.530775] NetLabel:  protocols = UNLABELED CIPSOv4
[   34.530789] NetLabel:  unlabeled traffic allowed by default
[   34.530825] AppArmor: AppArmor Filesystem Enabled
[   34.560707] system 00:01: iomem range 0xfed13000-0xfed19fff has been
reserved
[   34.560729] system 00:08: ioport range 0x290-0x297 has been reserved
[   34.560738] system 00:09: ioport range 0x4d0-0x4d1 has been reserved
[   34.560743] system 00:09: ioport range 0x800-0x87f has been reserved
[   34.560747] system 00:09: ioport range 0x480-0x4bf has been reserved
[   34.560751] system 00:09: ioport range 0x900-0x90f has been reserved
[   34.560756] system 00:09: iomem range 0xfed1c000-0xfed1ffff has been
reserved
[   34.560760] system 00:09: iomem range 0xfed20000-0xfed8ffff has been
reserved
[   34.560765] system 00:09: iomem range 0xffb00000-0xffbfffff could not
be reserved
[   34.560771] system 00:09: iomem range 0xfff00000-0xffffffff could not
be reserved
[   34.560780] system 00:0c: iomem range 0xfec00000-0xfec00fff has been
reserved
[   34.560785] system 00:0c: iomem range 0xfee00000-0xfee00fff has been
reserved
[   34.560793] system 00:0e: iomem range 0xf0000000-0xf3ffffff has been
reserved
[   34.560801] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
[   34.560806] system 00:0f: iomem range 0xc0000-0xdffff could not be
reserved
[   34.560810] system 00:0f: iomem range 0xe0000-0xfffff could not be
reserved
[   34.560814] system 00:0f: iomem range 0x100000-0x7fffffff could not
be reserved
[   34.560819] system 00:0f: iomem range 0x0-0x0 could not be reserved
[   34.591248] PCI: Bridge: 0000:00:1c.0
[   34.591253]   IO window: e000-efff
[   34.591259]   MEM window: disabled.
[   34.591264]   PREFETCH window: disabled.
[   34.591270] PCI: Bridge: 0000:00:1c.3
[   34.591274]   IO window: d000-dfff
[   34.591280]   MEM window: dff00000-dfffffff
[   34.591285]   PREFETCH window: disabled.
[   34.591294] PCI: Bridge: 0000:00:1e.0
[   34.591298]   IO window: a000-cfff
[   34.591304]   MEM window: de000000-dfefffff
[   34.591309]   PREFETCH window: disabled.
[   34.591335] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   34.591344] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   34.591363] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level,
low) -> IRQ 17
[   34.591371] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[   34.591382] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   34.591391] NET: Registered protocol family 2
[   34.600641] Time: acpi_pm clocksource has been installed.
[   34.600665] Switched to high resolution mode on CPU 0
[   34.600739] Switched to high resolution mode on CPU 1
[   34.690695] IP route cache hash table entries: 32768 (order: 5,
131072 bytes)
[   34.690944] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[   34.691455] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   34.691711] TCP: Hash tables configured (established 131072 bind 65536)
[   34.691715] TCP reno registered
[   34.720742] checking if image is initramfs... it is
[   35.266011] Freeing initrd memory: 7717k freed
[   35.267026] audit: initializing netlink socket (disabled)
[   35.267048] audit(1236607579.570:1): initialized
[   35.267371] highmem bounce pool size: 64 pages
[   35.267379] Total HugeTLB memory allocated, 0
[   35.270367] VFS: Disk quotas dquot_6.5.1
[   35.270461] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   35.270729] io scheduler noop registered
[   35.270735] io scheduler anticipatory registered
[   35.270740] io scheduler deadline registered (default)
[   35.270759] io scheduler cfq registered
[   35.270866] Boot video device is 0000:01:01.0
[   35.271027] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   35.271078] assign_interrupt_mode Found MSI capability
[   35.271126] Allocate Port Service[0000:00:1c.0:pcie00]
[   35.271186] Allocate Port Service[0000:00:1c.0:pcie02]
[   35.271305] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[   35.271354] assign_interrupt_mode Found MSI capability
[   35.271398] Allocate Port Service[0000:00:1c.3:pcie00]
[   35.271775] isapnp: Scanning for PnP cards...
[   35.626119] isapnp: No Plug & Play device found
[   35.670881] Real Time Clock Driver v1.12ac
[   35.671023] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ
sharing enabled
[   35.671167] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   35.672069] 00:0d: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   35.673247] RAMDISK driver initialized: 16 RAM disks of 65536K size
1024 blocksize
[   35.673358] input: Macintosh mouse button emulation as
/devices/virtual/input/input0
[   35.673517] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at
0x60,0x64 irq 1,12
[   35.676281] serio: i8042 KBD port at 0x60,0x64 irq 1
[   35.676293] serio: i8042 AUX port at 0x60,0x64 irq 12
[   35.700518] mice: PS/2 mouse device common for all mice
[   35.700650] EISA: Probing bus 0 at eisa.0
[   35.700678] Cannot allocate resource for EISA slot 7
[   35.700682] Cannot allocate resource for EISA slot 8
[   35.700686] EISA: Detected 0 cards.
[   35.700690] cpuidle: using governor ladder
[   35.700693] cpuidle: using governor menu
[   35.700768] NET: Registered protocol family 1
[   35.700800] Using IPI No-Shortcut mode
[   35.700830] registered taskstats version 1
[   35.700921]   Magic number: 1:206:131
[   35.701043]   hash matches device PNP0C02:03
[   35.701048]   hash matches device device:06
[   35.701054] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[   35.701491] Freeing unused kernel memory: 384k freed
[   35.701534] Write protecting the kernel read-only data: 828k
[   35.732734] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input1
[   35.803576] vesafb: framebuffer at 0xde000000, mapped to 0xf8880000,
using 2048k, total 2048k
[   35.803590] vesafb: mode is 1280x1024x8, linelength=1280, pages=0
[   35.803595] vesafb: protected mode interface info at c000:46b4
[   35.803601] vesafb: pmi: set display start = c00c476a, set palette =
c00c47f4
[   35.803607] vesafb: pmi: ports = a085 a01f a0b4 a0b8 a018 a014 a0c0
a0c3 a0c1
[   35.803624] vesafb: scrolling: redraw
[   35.803629] vesafb: Pseudocolor: size=6:6:6:6, shift=0:0:0:0
[   35.803793] Console: switching to colour frame buffer device 160x64
[   35.860495] fb0: VESA VGA frame buffer device
[   36.013463] fuse init (API version 7.9)
[   36.030640] ACPI: SSDT 7FFA85C0, 02E3 (r1    AMI   CPU1PM        1
INTL 20060113)
[   36.031582] ACPI: Processor [CPU1] (supports 8 throttling states)
[   36.032039] ACPI: SSDT 7FFA88B0, 02DA (r1    AMI   CPU2PM        1
INTL 20060113)
[   36.032973] ACPI: Processor [CPU2] (supports 8 throttling states)
[   36.048338] md: linear personality registered for level -1
[   36.052611] md: multipath personality registered for level -4
[   36.056975] md: raid0 personality registered for level 0
[   36.061856] md: raid1 personality registered for level 1
[   36.066003] xor: automatically using best checksumming function: pIII_sse
[   36.110075]    pIII_sse  :  5190.000 MB/sec
[   36.110347] xor: using function: pIII_sse (5190.000 MB/sec)
[   36.111434] async_tx: api initialized (async)
[   36.280074] raid6: int32x1    898 MB/s
[   36.449978] raid6: int32x2    999 MB/s
[   36.619889] raid6: int32x4    985 MB/s
[   36.789822] raid6: int32x8    717 MB/s
[   36.959762] raid6: mmxx1     2041 MB/s
[   37.129686] raid6: mmxx2     2427 MB/s
[   37.299652] raid6: sse1x1    1255 MB/s
[   37.469578] raid6: sse1x2    2297 MB/s
[   37.639496] raid6: sse2x1    2509 MB/s
[   37.809431] raid6: sse2x2    3560 MB/s
[   37.809671] raid6: using algorithm sse2x2 (3560 MB/s)
[   37.809996] md: raid6 personality registered for level 6
[   37.810336] md: raid5 personality registered for level 5
[   37.810675] md: raid4 personality registered for level 4
[   37.832500] md: raid10 personality registered for level 10
[   38.067034] usbcore: registered new interface driver usbfs
[   38.067415] usbcore: registered new interface driver hub
[   38.067789] usbcore: registered new device driver usb
[   38.096878] USB Universal Host Controller Interface driver v3.0
[   38.111658] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level,
low) -> IRQ 18
[   38.126830] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   38.126835] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   38.142025] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 1
[   38.157422] uhci_hcd 0000:00:1d.0: irq 18, io base 0x00007000
[   38.172871] usb usb1: configuration #1 chosen from 1 choice
[   38.188124] hub 1-0:1.0: USB hub found
[   38.203510] hub 1-0:1.0: 2 ports detected
[   38.219197] SCSI subsystem initialized
[   38.265848] libata version 3.00 loaded.
[   38.311893] Floppy drive(s): fd0 is 1.44M
[   38.327856] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level,
low) -> IRQ 19
[   38.343352] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   38.343356] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   38.358685] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 2
[   38.373831] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00007400
[   38.388982] usb usb2: configuration #1 chosen from 1 choice
[   38.403960] hub 2-0:1.0: USB hub found
[   38.418524] hub 2-0:1.0: 2 ports detected
[   38.436832] FDC 0 is a post-1991 82077
[   38.539228] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level,
low) -> IRQ 20
[   38.553993] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   38.553997] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   38.568463] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 3
[   38.583302] uhci_hcd 0000:00:1d.2: irq 20, io base 0x00007800
[   38.598151] usb usb3: configuration #1 chosen from 1 choice
[   38.612778] hub 3-0:1.0: USB hub found
[   38.627246] hub 3-0:1.0: 2 ports detected
[   38.749133] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level,
low) -> IRQ 17
[   38.763763] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[   38.763767] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   38.778470] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned
bus number 4
[   38.793209] uhci_hcd 0000:00:1d.3: irq 17, io base 0x00008000
[   38.807799] usb usb4: configuration #1 chosen from 1 choice
[   38.822137] hub 4-0:1.0: USB hub found
[   38.831550] usb 2-1: new full speed USB device using uhci_hcd and
address 2
[   38.850895] hub 4-0:1.0: 2 ports detected
[   38.969172] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level,
low) -> IRQ 18
[   38.984056] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   38.984060] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   38.998920] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 5
[   39.017693] ehci_hcd 0000:00:1d.7: debug port 1
[   39.032427] PCI: cache line size of 128 is not supported by device
0000:00:1d.7
[   39.032436] ehci_hcd 0000:00:1d.7: irq 18, io mem 0xddfff800
[   39.034759] usb 2-1: configuration #1 chosen from 1 choice
[   39.081459] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver
10 Dec 2004
[   39.096494] usb usb5: configuration #1 chosen from 1 choice
[   39.111809] hub 5-0:1.0: USB hub found
[   39.127194] hub 5-0:1.0: 8 ports detected
[   39.248996] pata_it821x: controller in pass through mode.
[   39.264736] ACPI: PCI Interrupt 0000:01:03.0[A] -> GSI 20 (level,
low) -> IRQ 18
[   39.280741] PCI: Setting latency timer of device 0000:01:03.0 to 64
[   39.280821] scsi0 : pata_it821x
[   39.297010] scsi1 : pata_it821x
[   39.313169] ata1: PATA max UDMA/133 cmd 0xc800 ctl 0xc400 bmdma
0xb400 irq 18
[   39.329669] ata2: PATA max UDMA/133 cmd 0xc000 ctl 0xb800 bmdma
0xb408 irq 18
[   39.391348] usb 2-1: USB disconnect, address 2
[   39.568094] ata1.00: ATA-7: MAXTOR STM3160212A, 3.AAJ, max UDMA/100
[   39.584975] ata1.00: 312581808 sectors, multi 0: LBA48
[   39.676123] ata1.00: configured for UDMA/100
[   39.861468] scsi 0:0:0:0: Direct-Access     ATA      MAXTOR STM316021
3.AA PQ: 0 ANSI: 5
[   39.878895] ahci 0000:00:1f.2: version 3.0
[   39.878923] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23 (level,
low) -> IRQ 21
[   39.903220] Driver 'sd' needs updating - please use bus_type methods
[   39.920823] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors
(160042 MB)
[   39.938397] sd 0:0:0:0: [sda] Write Protect is off
[   39.956095] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   39.956116] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   39.974111] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors
(160042 MB)
[   39.992183] sd 0:0:0:0: [sda] Write Protect is off
[   40.010115] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   40.010147] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   40.028578]  sda: sda1 sda2 sda3 sda4
[   40.066346] sd 0:0:0:0: [sda] Attached SCSI disk
[   40.089984] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   40.161024] usb 5-5: new high speed USB device using ehci_hcd and
address 3
[   40.306746] md: md0 stopped.
[   40.343036] usb 5-5: configuration #1 chosen from 1 choice
[   40.494962] md: bind<sda1>
[   40.513026] md: md1 stopped.
[   40.531283] md: md2 stopped.
[   40.549258] md: md3 stopped.
[   40.581673] md: md0 stopped.
[   40.599291] md: unbind<sda1>
[   40.616454] md: export_rdev(sda1)
[   40.620975] usbcore: registered new interface driver libusual
[   40.656224] Initializing USB Mass Storage driver...
[   40.777506] md: bind<sda1>
[   40.794687] md: md1 stopped.
[   40.900273] md: bind<sda2>
[   40.900766] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps
0xf impl SATA mode
[   40.900772] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part
[   40.900779] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   40.901036] scsi2 : ahci
[   40.968717] usb 2-1: new full speed USB device using uhci_hcd and
address 3
[   40.968733] md: md2 stopped.
[   41.003182] scsi3 : ahci
[   41.020174] scsi4 : ahci
[   41.037090] scsi5 : ahci
[   41.053715] ata3: SATA max UDMA/133 abar m1024@0xddfffc00 port
0xddfffd00 irq 221
[   41.070763] ata4: SATA max UDMA/133 abar m1024@0xddfffc00 port
0xddfffd80 irq 221
[   41.070766] ata5: SATA max UDMA/133 abar m1024@0xddfffc00 port
0xddfffe00 irq 221
[   41.103796] ata6: SATA max UDMA/133 abar m1024@0xddfffc00 port
0xddfffe80 irq 221
[   41.156147] md: bind<sda3>
[   41.172230] md: md3 stopped.
[   41.223291] md: bind<sda4>
[   41.239977] usb 2-1: configuration #1 chosen from 1 choice
[   41.548014] usb 3-2: new low speed USB device using uhci_hcd and
address 2
[   41.610508] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   41.627019] ata3.00: ATA-7: Hitachi HDS721616PLA380, P22OA50U, max
UDMA/133
[   41.642880] ata3.00: 321672960 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   41.659864] ata3.00: configured for UDMA/133
[   41.754793] usb 3-2: configuration #1 chosen from 1 choice
[   41.785170] scsi6 : SCSI emulation for USB Mass Storage devices
[   41.801968] usbcore: registered new interface driver usb-storage
[   41.807916] usbcore: registered new interface driver hiddev
[   41.807945] usb-storage: device found at 3
[   41.807947] usb-storage: waiting for device to settle before scanning
[   41.833257] USB Mass Storage support registered.
[   41.848902] input: Microsoft Microsoft 3-Button Mouse with
IntelliEye(TM) as
/devices/pci0000:00/0000:00:1d.2/usb3/3-2/3-2:1.0/input/input2
[   41.897918] input,hidraw0: USB HID v1.10 Mouse [Microsoft Microsoft
3-Button Mouse with IntelliEye(TM)] on usb-0000:00:1d.2-2
[   41.914610] usbcore: registered new interface driver usbhid
[   41.931331] /build/buildd/linux-2.6.24/drivers/hid/usbhid/hid-core.c:
v2.6:USB HID core driver
[   42.000316] ata4: SATA link down (SStatus 0 SControl 300)
[   42.340182] ata5: SATA link down (SStatus 0 SControl 300)
[   42.677555] ata6: SATA link down (SStatus 0 SControl 300)
[   42.694633] scsi 2:0:0:0: Direct-Access     ATA      Hitachi HDS72161
P22O PQ: 0 ANSI: 5
[   42.711952] sd 2:0:0:0: [sdb] 321672960 512-byte hardware sectors
(164697 MB)
[   42.729241] sd 2:0:0:0: [sdb] Write Protect is off
[   42.746226] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   42.746248] sd 2:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   42.763679] sd 2:0:0:0: [sdb] 321672960 512-byte hardware sectors
(164697 MB)
[   42.780736] sd 2:0:0:0: [sdb] Write Protect is off
[   42.797726] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   42.797747] sd 2:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   42.814756]  sdb: sdb1 sdb2 sdb3 sdb4
[   42.841621] sd 2:0:0:0: [sdb] Attached SCSI disk
[   42.858465] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   42.875379] ata_piix 0000:00:1f.1: version 2.12
[   42.875404] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 22 (level,
low) -> IRQ 22
[   42.892336] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[   42.892933] scsi7 : ata_piix
[   42.909788] scsi8 : ata_piix
[   42.927214] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0
irq 14
[   42.943995] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8
irq 15
[   43.042298] md: md0 stopped.
[   43.058693] md: unbind<sda1>
[   43.074828] md: export_rdev(sda1)
[   43.133664] md: bind<sda1>
[   43.149660] md: bind<sdb1>
[   43.172636] raid1: raid set md0 active with 2 out of 2 mirrors
[   43.188913] md: md1 stopped.
[   43.204983] md: unbind<sda2>
[   43.221287] md: export_rdev(sda2)
[   43.293394] md: bind<sda2>
[   43.300187] ata7.00: ATAPI: HL-DT-STDVD-ROM GDR8161B, 0100, max UDMA/33
[   43.326478] md: md2 stopped.
[   43.342759] md: unbind<sda3>
[   43.359038] md: export_rdev(sda3)
[   43.441271] md: bind<sda3>
[   43.457449] md: md3 stopped.
[   43.473519] md: unbind<sda4>
[   43.489326] md: export_rdev(sda4)
[   43.500035] ata7.00: configured for UDMA/33
[   43.591570] md: bind<sda4>
[   43.653662] md: md1 stopped.
[   43.669115] md: unbind<sda2>
[   43.684577] md: export_rdev(sda2)
[   43.721132] md: bind<sda2>
[   43.736526] scsi 7:0:0:0: CD-ROM            HL-DT-ST DVD-ROM GDR8161B
0100 PQ: 0 ANSI: 5
[   43.752602] scsi 7:0:0:0: Attached scsi generic sg2 type 5
[   43.769098] md: bind<sdb2>
[   43.793979] raid1: raid set md1 active with 2 out of 2 mirrors
[   43.810374] md: md2 stopped.
[   43.826416] md: unbind<sda3>
[   43.842645] md: export_rdev(sda3)
[   43.882685] Driver 'sr' needs updating - please use bus_type methods
[   43.922426] sr0: scsi3-mmc drive: 20x/48x cd/rw xa/form2 cdda tray
[   43.938597] Uniform CD-ROM driver Revision: 3.20
[   43.954789] sr 7:0:0:0: Attached scsi CD-ROM sr0
[   43.969342] md: bind<sda3>
[   43.985179] md: bind<sdb3>
[   44.009276] raid1: raid set md2 active with 2 out of 2 mirrors
[   44.025259] md: md3 stopped.
[   44.040925] md: unbind<sda4>
[   44.056168] md: export_rdev(sda4)
[   44.173805] md: bind<sda4>
[   44.189263] md: bind<sdb4>
[   44.210973] raid1: raid set md3 active with 2 out of 2 mirrors
[   44.514494] Attempting manual resume
[   44.529052] swsusp: Resume From Partition 9:3
[   44.529054] PM: Checking swsusp image.
[   44.529184] PM: Resume from disk failed.
[   44.566182] JFS: nTxBlock = 8192, nTxLock = 65536
[   46.796089] usb-storage: device scan complete
[   46.796581] scsi 6:0:0:0: Direct-Access              USB Flash Memory
1.04 PQ: 0 ANSI: 0 CCS
[   46.825045] sd 6:0:0:0: [sdc] 1001472 512-byte hardware sectors (513 MB)
[   46.839413] sd 6:0:0:0: [sdc] Write Protect is off
[   46.853016] sd 6:0:0:0: [sdc] Mode Sense: 23 00 00 00
[   46.853018] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[   46.869402] sd 6:0:0:0: [sdc] 1001472 512-byte hardware sectors (513 MB)
[   46.883648] sd 6:0:0:0: [sdc] Write Protect is off
[   46.897481] sd 6:0:0:0: [sdc] Mode Sense: 23 00 00 00
[   46.897483] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[   46.911196]  sdc: sdc1
[   46.926164] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[   46.940128] sd 6:0:0:0: Attached scsi generic sg3 type 0
[   54.623235] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   54.695500] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   54.725492] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   54.772117] parport_pc 00:07: reported by Plug and Play ACPI
[   54.786782] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   54.802356] input: Power Button (FF) as /devices/virtual/input/input4
[   54.865419] Linux agpgart interface v0.102
[   55.175298] ACPI: Power Button (FF) [PWRF]
[   55.190690] input: Power Button (CM) as /devices/virtual/input/input5
[   55.335233] ACPI: Power Button (CM) [PWRB]
[   55.422720] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 19 (level,
low) -> IRQ 17
[   55.438864] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   55.438890] sky2 0000:02:00.0: v1.20 addr 0xdfffc000 irq 17 Yukon-EC
(0xb6) rev 2
[   55.455501] sky2 eth0: addr 00:17:31:f4:aa:d9
[   55.701555] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 19 (level,
low) -> IRQ 17
[   55.718619] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   55.719581] Linux video capture interface: v2.00
[   55.740469]
/build/buildd/linux-ubuntu-modules-2.6.24-2.6.24/debian/build/build-server/media/gspcav1/gspca_core.c:
USB GSPCA camera found. SONIX sn9c10[1 2]
[   55.759595] usbcore: registered new interface driver gspca
[   55.777128]
/build/buildd/linux-ubuntu-modules-2.6.24-2.6.24/debian/build/build-server/media/gspcav1/gspca_core.c:
gspca driver 01.00.20 registered
[   55.868181] sn9c102: V4L2 driver for SN9C1xx PC Camera Controllers
v1:1.47
[   55.886958] usbcore: registered new interface driver sn9c102
[   56.528261] sky2 eth0: enabling interface
[   56.769984] NET: Registered protocol family 10
[   56.788745] lo: Disabled Privacy Extensions
[   56.807994] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   57.767539] loop: module loaded
[   57.816659] lp0: using parport0 (interrupt-driven).
[   57.939486] Adding 513976k swap on /dev/md3.  Priority:-1 extents:1
across:513976k
[   58.214340] sky2 eth0: Link is up at 100 Mbps, full duplex, flow
control rx
[   58.216398] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   68.627765] eth0: no IPv6 routers present
[   72.171243] kjournald starting.  Commit interval 5 seconds
[   72.202138] EXT3 FS on md0, internal journal
[   72.202146] EXT3-fs: mounted filesystem with journal data mode.
[   72.382632] kjournald starting.  Commit interval 5 seconds
[   72.382640] EXT3-fs: mounted filesystem with journal data mode.
[   73.604691] ip_tables: (C) 2000-2006 Netfilter Core Team
[   74.171555] w83627ehf: Found W83627EHG chip at 0x290
[   75.394100] No dock devices found.
[   79.439921] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[   79.439929] apm: disabled - APM is not SMP safe.
[   82.892734] usb 5-5: reset high speed USB device using ehci_hcd and
address 3
[   83.182747] usb 5-5: reset high speed USB device using ehci_hcd and
address 3
[  858.265160] EXT3 FS on sdc1, internal journal
[  895.599516] kjournald starting.  Commit interval 5 seconds
[  895.599759] EXT3-fs: mounted filesystem with journal data mode.
[ 1518.113669] kjournald starting.  Commit interval 5 seconds
[ 1518.113897] EXT3 FS on md0, internal journal
[ 1518.113907] EXT3-fs: mounted filesystem with journal data mode.

Don't know more :(
If you need something else please contact me :)

-- 
Fr3ddie
fr3ddie@fr3ddie.it
Home Page: http://www.fr3ddie.it
OpenPGP Public Key available on my website

