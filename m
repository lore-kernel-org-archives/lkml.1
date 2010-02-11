Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab0BKBYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 20:24:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50533 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab0BKBYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 20:24:23 -0500
Date: Thu, 11 Feb 2010 01:24:20 +0000 (GMT)
From: "imran.javeed@i-ksolutions.com" <imran.javeed@i-ksolutions.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "imran.javeed@vocalink.com" <imran.javeed@vocalink.com>
Message-ID: <64656416.181639.1265851460791.JavaMail.open-xchange@oxltgw01.schlund.de>
Subject: Fwd: PROBLEM: kernel 2.6.32-7 will not boot -- could not find
 /dev/root Dell Vostro 1000
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_181637_1538288329.1265851460627"
X-Priority: 3
X-Mailer: Open-Xchange Mailer v6.14.0-Rev13
X-Provags-ID: V01U2FsdGVkX1/F9tGYEbM9GXC8oDQaPCQbQ392V9nk5AVxYtf
 W9Z5/Bwmjjh/nD2mBbQdaecZAZ7IFkeD35Ukp91A+frWxYhhT5
 /ERxCDUTWCy6Vy69zYtiabXX4uw9aw1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_181637_1538288329.1265851460627
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


---------- Original Message ----------
From: "imran.javeed@i-ksolutions.com" <imran.javeed@i-ksolutions.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: imran.javeed@i-ksolutions.com, "imran.javeed@vocalink.com"
<imran.javeed@vocalink.com>
Date: 11 February 2010 at 02:21
Subject: PROBLEM: kernel 2.6.32-7 will not boot -- could not find /dev/root=
 Dell
Vostro 1000

[1.] One line summary of the problem: Upgrade to 2.6.32-7 will not boot(can=
not
recognize disk)
=C2=A0

[2.] Full description of the problem/report:
=C2=A0
I am trying to upgrade my kernel from 2.6.18-53 to 2.6.32-7, the problem i =
am
having is that the 2.6.32 kernel will not recognize my SATA disk. I have a =
Dell
Vostro 1000 & have happily been using linux(centos5) with no issues.
=C2=A0
Ive ensured the correct options have been set in .config, included libata, =
ahci
within the kernel(they are not modules) and checked various other informati=
on
sources on the net, but it still does not work.(this is the 3rd night now &
still no fix)
=C2=A0
Hence my email to you to try & fix for me please?
=C2=A0
Attached is the information you require

[3.] Keywords (i.e., modules, networking, kernel):
SATA SB600 ATI
=C2=A0
[4.] Kernel information
2.6.32-7
[4.1.] Kernel version (from /proc/version):
CURRENT_VERSION =3D=3D Linux version 2.6.18-53.el5PAE
(mockbuild@builder6.centos.org) (gcc version 4.1.2 20070626 (Red Hat 4.1.2-=
14))
#1 SMP Mon Nov 12 02:55:09 EST 2007

[4.2.] Kernel .config file:
Attached
=C2=A0
[5.] Most recent kernel version which did not have the bug:
That im using right now 2.6.18-53
=C2=A0
[6.] Output of Oops.. message (if applicable) with symbolic information
=C2=A0=C2=A0=C2=A0=C2=A0 resolved (see Documentation/oops-tracing.txt)
N/A
=C2=A0
[7.] A small shell script or example program which triggers the
=C2=A0=C2=A0=C2=A0=C2=A0 problem (if possible)
N/A
=C2=A0
[8.] Environment
=C2=A0
[8.1.] Software (add the output of the ver_linux script here)
Linux uhud 2.6.18-53.el5PAE #1 SMP Mon Nov 12 02:55:09 EST 2007 i686 athlon=
 i386
GNU/Linux

Gnu C=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4.1.2
Gnu make=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 3.81
binutils=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 2.17.50.0.6
util-linux=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 2.13-pre7
mount=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2.13-pre7
module-init-tools=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3.3-pre2
e2fsprogs=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 1.39
pcmciautils=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 014
quota-tools=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 3.13.
PPP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2.4.4
isdn4k-utils=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3.=
9
Linux C Library=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2.5
Dynamic linker (ldd)=C2=A0=C2=A0 2.5
Procps=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 3.2.7
Net-tools=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 1.60
Kbd=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.12
oprofile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 0.9.2
Sh-utils=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 5.97
udev=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 095
wireless-tools=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 28
Modules Loaded=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ndiswrapper =
bridge vboxnetflt vboxdrv hidp l2cap
bluetooth configfs sunrpc ip_conntrack_netbios_ns ipt_MASQUERADE iptable_na=
t
ip_nat ipt_LOG ipt_REJECT xt_state ip_conntrack nfnetlink xt_multiport
iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables
x_tables ipv6 cpufreq_ondemand dm_mirror dm_multipath dm_mod video sbs back=
light
i2c_ec button battery asus_acpi ac parport_pc lp parport snd_hda_intel
snd_hda_codec snd_seq_dummy snd_seq_oss joydev snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss sg snd_pcm ide_cd b44 cdrom snd_ti=
mer
snd i2c_piix4 mii k8_edac i2c_core k8temp edac_mc soundcore hwmon serio_raw
sdhci mmc_core snd_page_alloc ahci libata sd_mod scsi_mod ext3 jbd ehci_hcd
ohci_hcd uhci_hcd

=C2=A0
[8.2.] Processor information (from /proc/cpuinfo):
processor=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0
vendor_id=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : AuthenticAMD
cpu family=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 15
model=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 104
model name=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : AMD Turion(tm) 64 X2 Mobile Tech=
nology TL-60
stepping=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 2
cpu MHz=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 800.000
cache size=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 512 KB
physical id=C2=A0=C2=A0=C2=A0=C2=A0 : 0
siblings=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 2
core id=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0
cpu cores=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 2
fdiv_bug=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : no
hlt_bug=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : no
f00f_bug=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : no
coma_bug=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : no
fpu=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 : yes
fpu_exception=C2=A0=C2=A0 : yes
cpuid level=C2=A0=C2=A0=C2=A0=C2=A0 : 1
wp=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 : yes
flags=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : fpu vme=
 de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm
3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8legacy 3dnowprefe=
tch
ts fid vid ttp tm stc 100mhzsteps
bogomips=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 1601.16

processor=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 1
vendor_id=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : AuthenticAMD
cpu family=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 15
model=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 104
model name=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : AMD Turion(tm) 64 X2 Mobile Tech=
nology TL-60
stepping=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 2
cpu MHz=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 800.000
cache size=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 512 KB
physical id=C2=A0=C2=A0=C2=A0=C2=A0 : 0
siblings=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 2
core id=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 1
cpu cores=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 2
fdiv_bug=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : no
hlt_bug=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : no
f00f_bug=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : no
coma_bug=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : no
fpu=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 : yes
fpu_exception=C2=A0=C2=A0 : yes
cpuid level=C2=A0=C2=A0=C2=A0=C2=A0 : 1
wp=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 : yes
flags=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : fpu vme=
 de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm
3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8legacy 3dnowprefe=
tch
ts fid vid ttp tm stc 100mhzsteps
bogomips=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 1601.16

[8.3.] Module information (from /proc/modules):
=C2=A0
ndiswrapper 169360 0 - Live 0xf9023000
bridge 53341 0 - Live 0xf8d9b000
vboxnetflt 79400 0 - Live 0xf8d86000
vboxdrv 103208 1 vboxnetflt, Live 0xf8d6b000
hidp 23105 2 - Live 0xf8d0d000
l2cap 29633 5 hidp, Live 0xf8d04000
bluetooth 53925 2 hidp,l2cap, Live 0xf8d3e000
configfs 28753 1 - Live 0xf8cfb000
sunrpc 144253 1 - Live 0xf8d19000
ip_conntrack_netbios_ns 6977 0 - Live 0xf8c84000
ipt_MASQUERADE 7745 3 - Live 0xf8c72000
iptable_nat 11205 1 - Live 0xf8ced000
ip_nat 20973 2 ipt_MASQUERADE,iptable_nat, Live 0xf8cd5000
ipt_LOG 10177 1 - Live 0xf8c78000
ipt_REJECT 9537 8 - Live 0xf8c7c000
xt_state 6209 7 - Live 0xf8c75000
ip_conntrack 53025 5
ip_conntrack_netbios_ns,ipt_MASQUERADE,iptable_nat,ip_nat,xt_state, Live
0xf8cc7000
nfnetlink 10713 2 ip_nat,ip_conntrack, Live 0xf8c51000
xt_multiport 7233 1 - Live 0xf8c5f000
iptable_filter 7105 1 - Live 0xf8c5c000
ip_tables 17029 2 iptable_nat,iptable_filter, Live 0xf8c62000
ip6t_REJECT 9409 1 - Live 0xf8c58000
xt_tcpudp 7105 53 - Live 0xf8c55000
ip6table_filter 6849 1 - Live 0xf8c3e000
ip6_tables 18181 1 ip6table_filter, Live 0xf8c4b000
x_tables 17349 10
ipt_MASQUERADE,iptable_nat,ipt_LOG,ipt_REJECT,xt_state,xt_multiport,ip_tabl=
es,ip
6t_REJECT,xt_tcpudp,ip6_tables, Live 0xf8c45000
ipv6 251393 21 ip6t_REJECT, Live 0xf8c88000
cpufreq_ondemand 10573 1 - Live 0xf8a35000
dm_mirror 28869 0 - Live 0xf8a3a000
dm_multipath 21577 0 - Live 0xf89ee000
dm_mod 58457 2 dm_mirror,dm_multipath, Live 0xf8a43000
video 19269 0 - Live 0xf89f5000
sbs 18533 0 - Live 0xf89c2000
backlight 10049 0 - Live 0xf89ea000
i2c_ec 9025 1 sbs, Live 0xf89e6000
button 10705 0 - Live 0xf89e2000
battery 13637 0 - Live 0xf89c8000
asus_acpi 19289 0 - Live 0xf896c000
ac 9157 0 - Live 0xf8995000
parport_pc 29157 0 - Live 0xf89d9000
lp 15849 0 - Live 0xf89ad000
parport 37513 2 parport_pc,lp, Live 0xf89ce000
snd_hda_intel 24025 0 - Live 0xf89bb000
snd_hda_codec 202689 1 snd_hda_intel, Live 0xf89fd000
snd_seq_dummy 7877 0 - Live 0xf8992000
snd_seq_oss 32577 0 - Live 0xf89b2000
joydev 13313 0 - Live 0xf898d000
snd_seq_midi_event 11073 1 snd_seq_oss, Live 0xf8989000
snd_seq 49713 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event, Live 0xf89990=
00
snd_seq_device 11725 3 snd_seq_dummy,snd_seq_oss,snd_seq, Live 0xf8985000
snd_pcm_oss 42945 0 - Live 0xf893b000
snd_mixer_oss 19009 1 snd_pcm_oss, Live 0xf8966000
sg 35933 0 - Live 0xf895c000
snd_pcm 72133 3 snd_hda_intel,snd_hda_codec,snd_pcm_oss, Live 0xf8972000
ide_cd 40033 0 - Live 0xf8951000
b44 29133 0 - Live 0xf891c000
cdrom 36705 1 ide_cd, Live 0xf8947000
snd_timer 24645 2 snd_seq,snd_pcm, Live 0xf8925000
snd 52421 9
snd_hda_intel,snd_hda_codec,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,=
snd_m
ixer_oss,snd_pcm,snd_timer, Live 0xf892d000
i2c_piix4 12237 0 - Live 0xf8902000
mii 9409 1 b44, Live 0xf88fe000
k8_edac 18177 0 - Live 0xf8916000
i2c_core 23745 2 i2c_ec,i2c_piix4, Live 0xf890f000
k8temp 9537 0 - Live 0xf88db000
edac_mc 24977 1 k8_edac, Live 0xf8907000
soundcore 11553 1 snd, Live 0xf88d7000
hwmon 7365 1 k8temp, Live 0xf88d4000
serio_raw 10693 0 - Live 0xf88c8000
sdhci 21337 0 - Live 0xf8846000
mmc_core 27457 1 sdhci, Live 0xf88cc000
snd_page_alloc 13769 2 snd_hda_intel,snd_pcm, Live 0xf88be000
ahci 23621 2 - Live 0xf885f000
libata 115961 1 ahci, Live 0xf88e0000
sd_mod 24897 3 - Live 0xf8857000
scsi_mod 132685 3 sg,libata,sd_mod, Live 0xf8879000
ext3 123337 1 - Live 0xf889e000
jbd 56553 1 ext3, Live 0xf886a000
ehci_hcd 33229 0 - Live 0xf884d000
ohci_hcd 23389 0 - Live 0xf8837000
uhci_hcd 25549 0 - Live 0xf882f000

=C2=A0
[8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
01f0-01f7 : ide0
0220-022f : pnp 00:08
03c0-03df : vga+
03f6-03f6 : ide0
1080-1080 : motherboard
=C2=A0 1080-1080 : pnp 00:08
8000-805f : motherboard
=C2=A0 8000-8003 : ACPI PM1a_EVT_BLK
=C2=A0 8004-8005 : ACPI PM1a_CNT_BLK
=C2=A0 8008-800b : ACPI PM_TMR
=C2=A0 8010-8015 : ACPI CPU throttle
=C2=A0 8020-8027 : ACPI GPE0_BLK
8200-8200 : ACPI PM2_CNT_BLK
8204-8207 : ACPI PM1b_EVT_BLK
8400-840f : 0000:00:12.0
8410-841f : 0000:00:14.0
=C2=A0 8410-8417 : piix4_smbus
8420-842f : 0000:00:14.1
=C2=A0 8420-8427 : ide0
8430-8437 : 0000:00:12.0
8438-843f : 0000:00:12.0
8450-8453 : 0000:00:12.0
8454-8457 : 0000:00:12.0
9000-9fff : PCI Bus #01
=C2=A0 9000-90ff : 0000:01:05.0
################################
00000000-0009dbff : System RAM
=C2=A0 00000000-00000000 : Crash kernel
0009dc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000ccfff : Video ROM
000cd000-000cdfff : Adapter ROM
000f0000-000fffff : System ROM
00100000-a7e6ffff : System RAM
=C2=A0 00400000-006075e0 : Kernel code
=C2=A0 006075e1-006de9bb : Kernel data
a7e70000-a7e7ffff : ACPI Tables
a7e80000-a7efffff : ACPI Non-volatile Storage
a7f00000-afffffff : reserved
c0000000-c0003fff : 0000:00:14.2
=C2=A0 c0000000-c0003fff : ICH HD audio
c0004000-c00043ff : 0000:00:12.0
=C2=A0 c0004000-c00043ff : ahci
c0004400-c00044ff : 0000:00:13.5
=C2=A0 c0004400-c00044ff : ehci_hcd
c0005000-c0005fff : 0000:00:13.0
=C2=A0 c0005000-c0005fff : ohci_hcd
c0006000-c0006fff : 0000:00:13.1
=C2=A0 c0006000-c0006fff : ohci_hcd
c0007000-c0007fff : 0000:00:13.2
=C2=A0 c0007000-c0007fff : ohci_hcd
c0008000-c0008fff : 0000:00:13.3
=C2=A0 c0008000-c0008fff : ohci_hcd
c0009000-c0009fff : 0000:00:13.4
=C2=A0 c0009000-c0009fff : ohci_hcd
c0100000-c01fffff : PCI Bus #01
=C2=A0 c0100000-c010ffff : 0000:01:05.0
=C2=A0 c0120000-c013ffff : 0000:01:05.0
c0200000-c02fffff : PCI Bus #05
=C2=A0 c0200000-c0203fff : 0000:05:00.0
=C2=A0=C2=A0=C2=A0 c0200000-c0203fff : ndiswrapper
c0300000-c03fffff : PCI Bus #08
=C2=A0 c0300000-c0301fff : 0000:08:00.0
=C2=A0=C2=A0=C2=A0 c0300000-c0301fff : b44
=C2=A0 c0302800-c03028ff : 0000:08:01.0
=C2=A0=C2=A0=C2=A0 c0302800-c03028ff : sdhci:slot0
=C2=A0 c0302c00-c0302cff : 0000:08:01.1
c8000000-cfffffff : PCI Bus #01
=C2=A0 c8000000-cfffffff : 0000:01:05.0
e0000000-efffffff : reserved
fec00000-fec0ffff : reserved
fed00000-fed003ff : 0000:00:14.0
fee00000-fee00fff : reserved
fff80000-ffffffff : reserved
100000000-14fffffff : System RAM

=C2=A0
=C2=A0
[8.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: ATI Technologies Inc RS480 Host Bridge (rev 10)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown device 0=
22a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O- Mem+ BusMaster+ Sp=
ecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz+ UDF- FastB2B=
- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort+ <MAbort+ >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64

00:01.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge (prog-if 00 [Norm=
al
decode])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster+ Sp=
ecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz+ UDF- FastB2B=
- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Bus: primary=3D00, secondary=3D0=
1, subordinate=3D01, sec-latency=3D64
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 I/O behind bridge: 00009000-0000=
9fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Memory behind bridge: c0100000-c=
01fffff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Prefetchable memory behind bridg=
e: 00000000c8000000-00000000cff00000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Secondary status: 66MHz+ FastB2B=
- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BridgeCtl: Parity- SERR- NoISA+ =
VGA+ MAbort- >Reset- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [44] HyperTranspor=
t: MSI Mapping
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [b0] #0d [0000]

00:05.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge (prog-if 00 [Norm=
al
decode])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O- Mem- BusMaster+ Sp=
ecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz- UDF- FastB2B=
- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 0, Cache Line Size: 32 =
bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Bus: primary=3D00, secondary=3D0=
2, subordinate=3D04, sec-latency=3D0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 I/O behind bridge: 0000f000-0000=
0fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Memory behind bridge: fff00000-0=
00fffff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Prefetchable memory behind bridg=
e: 00000000fff00000-0000000000000000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Secondary status: 66MHz- FastB2B=
- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BridgeCtl: Parity- SERR- NoISA+ =
VGA- MAbort- >Reset- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [50] Power Managem=
ent version 3
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [58] Express Root =
Port (Slot+) IRQ 0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTa=
g+
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Device: Latency L0s <64ns, L1 <1us
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port =
247
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Link: Latency L0s <64ns, L1 <1us
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Link: Speed 2.5Gb/s, Width x16
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpis=
e+
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Slot: Number 0, PowerLimit 0.000000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Slot: AttnInd Off, PwrInd Off, Power-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Root: Correctable- Non-Fatal- Fatal- PME-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [80] Message Signa=
lled Interrupts: 64bit- Queue=3D0/0
Enable-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Address: 00000000=C2=A0 Data: 0000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [b0] #0d [0000]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [b8] HyperTranspor=
t: MSI Mapping

00:06.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge (prog-if 00 [Norm=
al
decode])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster+ Sp=
ecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz- UDF- FastB2B=
- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 0, Cache Line Size: 32 =
bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Bus: primary=3D00, secondary=3D0=
5, subordinate=3D07, sec-latency=3D0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 I/O behind bridge: 0000f000-0000=
0fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Memory behind bridge: c0200000-c=
02fffff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Prefetchable memory behind bridg=
e: 00000000fff00000-0000000000000000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Secondary status: 66MHz- FastB2B=
- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-
<MAbort+ <SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BridgeCtl: Parity- SERR- NoISA+ =
VGA- MAbort- >Reset- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [50] Power Managem=
ent version 3
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [58] Express Root =
Port (Slot+) IRQ 0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTa=
g+
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Device: Latency L0s <64ns, L1 <1us
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port =
3
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Link: Latency L0s <64ns, L1 <1us
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Link: Speed 2.5Gb/s, Width x1
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpis=
e+
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Slot: Number 0, PowerLimit 25.000000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Slot: AttnInd Off, PwrInd Off, Power-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Root: Correctable- Non-Fatal- Fatal- PME-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [80] Message Signa=
lled Interrupts: 64bit- Queue=3D0/0
Enable-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Address: 00000000=C2=A0 Data: 0000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [b0] #0d [0000]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [b8] HyperTranspor=
t: MSI Mapping

00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA (prog-i=
f 01
[AHCI 1.0])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown device 0=
22a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster+ Sp=
ecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz+ UDF- FastB2B=
- ParErr- DEVSEL=3Dmedium >TAbort+
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin A routed to IRQ 2=
09
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: I/O ports at 8438 [siz=
e=3D8]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 1: I/O ports at 8454 [siz=
e=3D4]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 2: I/O ports at 8430 [siz=
e=3D8]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 3: I/O ports at 8450 [siz=
e=3D4]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 4: I/O ports at 8400 [siz=
e=3D16]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 5: Memory at c0004000 (32=
-bit, non-prefetchable) [size=3D1K]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [60] Power Managem=
ent version 2
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0) (prog-if 10
[OHCI])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown device 0=
22a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster+ Sp=
ecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz+ UDF- FastB2B=
+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64, Cache Line Size: 32=
 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin A routed to IRQ 1=
77
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0005000 (32=
-bit, non-prefetchable) [size=3D4K]

00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1) (prog-if 10
[OHCI])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown device 0=
22a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster+ Sp=
ecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz+ UDF- FastB2B=
+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64, Cache Line Size: 32=
 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin B routed to IRQ 1=
85
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0006000 (32=
-bit, non-prefetchable) [size=3D4K]

00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2) (prog-if 10
[OHCI])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown device 0=
22a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster+ Sp=
ecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz+ UDF- FastB2B=
+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64, Cache Line Size: 32=
 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin C routed to IRQ 1=
93
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0007000 (32=
-bit, non-prefetchable) [size=3D4K]

00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3) (prog-if 10
[OHCI])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown device 0=
22a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster+ Sp=
ecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz+ UDF- FastB2B=
+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64, Cache Line Size: 32=
 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin B routed to IRQ 1=
85
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0008000 (32=
-bit, non-prefetchable) [size=3D4K]

00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4) (prog-if 10
[OHCI])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown device 0=
22a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster+ Sp=
ecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz+ UDF- FastB2B=
+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64, Cache Line Size: 32=
 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin C routed to IRQ 1=
93
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0009000 (32=
-bit, non-prefetchable) [size=3D4K]

00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI)
(prog-if 20 [EHCI])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown device 0=
22a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster+ Sp=
ecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz+ UDF- FastB2B=
+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64, Cache Line Size: 64=
 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin D routed to IRQ 2=
01
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0004400 (32=
-bit, non-prefetchable) [size=3D256]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [c0] Power Managem=
ent version 2
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Bridge: PM- B3+
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [e4] Debug port

00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 14)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown device 0=
22a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster- Sp=
ecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz+ UDF- FastB2B=
- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: I/O ports at 8410 [siz=
e=3D16]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 1: Memory at fed00000 (32=
-bit, non-prefetchable) [size=3D1K]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [b0] HyperTranspor=
t: MSI Mapping

00:14.1 IDE interface: ATI Technologies Inc SB600 IDE (prog-if 8a [Master S=
ecP
PriP])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown device 0=
22a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem- BusMaster+ Sp=
ecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz+ UDF- FastB2B=
- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin A routed to IRQ 1=
77
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: I/O ports at <ignored>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 1: I/O ports at <ignored>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 2: I/O ports at <unassign=
ed>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 3: I/O ports at <unassign=
ed>
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 4: I/O ports at 8420 [siz=
e=3D16]

00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown device 0=
22a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O- Mem+ BusMaster+ Sp=
ecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz- UDF- FastB2B=
- ParErr- DEVSEL=3Dslow >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64, Cache Line Size: 32=
 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin ? routed to IRQ 1=
77
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0000000 (64=
-bit, non-prefetchable) [size=3D16K]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [50] Power Managem=
ent version 2
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown device 0=
22a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster+ Sp=
ecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz+ UDF- FastB2B=
- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 0

00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (prog-if 0=
1
[Subtractive decode])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster+ Sp=
ecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz+ UDF- FastB2B=
+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Bus: primary=3D00, secondary=3D0=
8, subordinate=3D0a, sec-latency=3D64
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 I/O behind bridge: 0000f000-0000=
0fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Memory behind bridge: c0300000-c=
03fffff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Prefetchable memory behind bridg=
e: fff00000-000fffff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Secondary status: 66MHz- FastB2B=
+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BridgeCtl: Parity- SERR+ NoISA+ =
VGA- MAbort- >Reset- FastB2B-

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
HyperTransport Technology Configuration
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O- Mem- BusMaster- Sp=
ecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz- UDF- FastB2B=
- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [80] HyperTranspor=
t: Host or Secondary Interface
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 !!! Possibly incomplete decoding
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Command: WarmRst+ DblEnd-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRC=
Err=3D8
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Link Config: MLWI=3D16bit MLWO=3D16bit LWI=3D16bit LWO=3D16=
bit
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Revision ID: 1.02

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Add=
ress
Map
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O- Mem- BusMaster- Sp=
ecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz- UDF- FastB2B=
- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRA=
M
Controller
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O- Mem- BusMaster- Sp=
ecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap- 66MHz- UDF- FastB2B=
- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Miscellaneous Control
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O- Mem- BusMaster- Sp=
ecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz- UDF- FastB2B=
- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [f0] #0f [0010]

01:05.0 VGA compatible controller: ATI Technologies Inc RS482 [Radeon Xpres=
s
200] (prog-if 00 [VGA])
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown device 0=
22a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster+ Sp=
ecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz+ UDF- FastB2B=
+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 255 (2000ns min), Cache=
 Line Size: 32 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin A routed to IRQ 1=
0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c8000000 (32=
-bit, prefetchable) [size=3D128M]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 1: I/O ports at 9000 [siz=
e=3D256]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 2: Memory at c0100000 (32=
-bit, non-prefetchable) [size=3D64K]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [virtual] Expansion ROM at c0120=
000 [disabled] [size=3D128K]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [50] Power Managem=
ent version 2
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

05:00.0 Network controller: Broadcom Corporation BCM94311MCG wlan mini-PCI =
(rev
01)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown device 0=
007
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster+ Sp=
ecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz- UDF- FastB2B=
- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 0, Cache Line Size: 32 =
bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin A routed to IRQ 1=
93
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0200000 (32=
-bit, non-prefetchable) [size=3D16K]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [40] Power Managem=
ent version 2
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [58] Message Signa=
lled Interrupts: 64bit- Queue=3D0/0
Enable-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Address: 00000000=C2=A0 Data: 0000
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [d0] Express Legac=
y Endpoint IRQ 0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTa=
g+
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Device: Latency L0s <4us, L1 unlimited
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Device: AtnBtn- AtnInd- PwrInd-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Link: Latency L0s <4us, L1 <64us
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Link: Speed 2.5Gb/s, Width x1
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [100] Advanced Err=
or Reporting
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [13c] Virtual Chan=
nel

08:00.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX (re=
v 02)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown device 0=
22a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O- Mem+ BusMaster+ Sp=
ecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz- UDF- FastB2B=
- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin A routed to IRQ 2=
25
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0300000 (32=
-bit, non-prefetchable) [size=3D8K]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [40] Power Managem=
ent version 2
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-

08:01.0 Class 0805: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (=
rev
22)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown device 0=
22a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O- Mem+ BusMaster+ Sp=
ecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz- UDF- FastB2B=
- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64, Cache Line Size: 32=
 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin B routed to IRQ 2=
17
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0302800 (32=
-bit, non-prefetchable) [size=3D256]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [80] Power Managem=
ent version 2
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-

08:01.1 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev 12)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Dell Unknown device 0=
22a
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O- Mem+ BusMaster+ Sp=
ecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz- UDF- FastB2B=
- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 64, Cache Line Size: 32=
 bytes
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin B routed to IRQ 9
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: Memory at c0302c00 (32=
-bit, non-prefetchable) [size=3D256]
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: [80] Power Managem=
ent version 2
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-


[8.6.] SCSI information (from /proc/scsi/scsi)
=C2=A0
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
=C2=A0 Vendor: ATA=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Model: FUJITSU MHY2160B Re=
v: 0085
=C2=A0 Type:=C2=A0=C2=A0 Direct-Access=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 ANSI SCSI revision: 05

[8.7.] Other information that might be relevant to the problem
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (please look in /proc and include all =
information that you
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 think to be relevant):
[X.] Other notes, patches, fixes, workarounds:Hello
=C2=A0

=C2=A0
=C2=A0
------=_Part_181637_1538288329.1265851460627
Content-Type: application/octet-stream; name=.config
Content-Transfer-Encoding: base64
Content-Disposition: ATTACHMENT; filename=.config

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIG1ha2UgY29uZmlnOiBkb24ndCBlZGl0CiMgTGlu
dXgga2VybmVsIHZlcnNpb246IDIuNi4zMi43CiMgV2VkIEZlYiAxMCAyMzo1Mzo1NSAyMDEwCiMK
IyBDT05GSUdfNjRCSVQgaXMgbm90IHNldApDT05GSUdfWDg2XzMyPXkKIyBDT05GSUdfWDg2XzY0
IGlzIG5vdCBzZXQKQ09ORklHX1g4Nj15CkNPTkZJR19PVVRQVVRfRk9STUFUPSJlbGYzMi1pMzg2
IgpDT05GSUdfQVJDSF9ERUZDT05GSUc9ImFyY2gveDg2L2NvbmZpZ3MvaTM4Nl9kZWZjb25maWci
CkNPTkZJR19HRU5FUklDX1RJTUU9eQpDT05GSUdfR0VORVJJQ19DTU9TX1VQREFURT15CkNPTkZJ
R19DTE9DS1NPVVJDRV9XQVRDSERPRz15CkNPTkZJR19HRU5FUklDX0NMT0NLRVZFTlRTPXkKQ09O
RklHX0dFTkVSSUNfQ0xPQ0tFVkVOVFNfQlJPQURDQVNUPXkKQ09ORklHX0xPQ0tERVBfU1VQUE9S
VD15CkNPTkZJR19TVEFDS1RSQUNFX1NVUFBPUlQ9eQpDT05GSUdfSEFWRV9MQVRFTkNZVE9QX1NV
UFBPUlQ9eQpDT05GSUdfTU1VPXkKQ09ORklHX1pPTkVfRE1BPXkKQ09ORklHX0dFTkVSSUNfSVNB
X0RNQT15CkNPTkZJR19HRU5FUklDX0lPTUFQPXkKQ09ORklHX0dFTkVSSUNfQlVHPXkKQ09ORklH
X0dFTkVSSUNfSFdFSUdIVD15CkNPTkZJR19BUkNIX01BWV9IQVZFX1BDX0ZEQz15CiMgQ09ORklH
X1JXU0VNX0dFTkVSSUNfU1BJTkxPQ0sgaXMgbm90IHNldApDT05GSUdfUldTRU1fWENIR0FERF9B
TEdPUklUSE09eQpDT05GSUdfQVJDSF9IQVNfQ1BVX0lETEVfV0FJVD15CkNPTkZJR19HRU5FUklD
X0NBTElCUkFURV9ERUxBWT15CiMgQ09ORklHX0dFTkVSSUNfVElNRV9WU1lTQ0FMTCBpcyBub3Qg
c2V0CkNPTkZJR19BUkNIX0hBU19DUFVfUkVMQVg9eQpDT05GSUdfQVJDSF9IQVNfREVGQVVMVF9J
RExFPXkKQ09ORklHX0FSQ0hfSEFTX0NBQ0hFX0xJTkVfU0laRT15CkNPTkZJR19IQVZFX1NFVFVQ
X1BFUl9DUFVfQVJFQT15CkNPTkZJR19ORUVEX1BFUl9DUFVfRU1CRURfRklSU1RfQ0hVTks9eQpD
T05GSUdfTkVFRF9QRVJfQ1BVX1BBR0VfRklSU1RfQ0hVTks9eQojIENPTkZJR19IQVZFX0NQVU1B
U0tfT0ZfQ1BVX01BUCBpcyBub3Qgc2V0CkNPTkZJR19BUkNIX0hJQkVSTkFUSU9OX1BPU1NJQkxF
PXkKQ09ORklHX0FSQ0hfU1VTUEVORF9QT1NTSUJMRT15CiMgQ09ORklHX1pPTkVfRE1BMzIgaXMg
bm90IHNldApDT05GSUdfQVJDSF9QT1BVTEFURVNfTk9ERV9NQVA9eQojIENPTkZJR19BVURJVF9B
UkNIIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfU1VQUE9SVFNfT1BUSU1JWkVEX0lOTElOSU5HPXkK
Q09ORklHX0FSQ0hfU1VQUE9SVFNfREVCVUdfUEFHRUFMTE9DPXkKQ09ORklHX0dFTkVSSUNfSEFS
RElSUVM9eQpDT05GSUdfR0VORVJJQ19IQVJESVJRU19OT19fRE9fSVJRPXkKQ09ORklHX0dFTkVS
SUNfSVJRX1BST0JFPXkKQ09ORklHX0dFTkVSSUNfUEVORElOR19JUlE9eQpDT05GSUdfVVNFX0dF
TkVSSUNfU01QX0hFTFBFUlM9eQpDT05GSUdfWDg2XzMyX1NNUD15CkNPTkZJR19YODZfSFQ9eQpD
T05GSUdfWDg2X1RSQU1QT0xJTkU9eQpDT05GSUdfWDg2XzMyX0xBWllfR1M9eQpDT05GSUdfS1RJ
TUVfU0NBTEFSPXkKQ09ORklHX0RFRkNPTkZJR19MSVNUPSIvbGliL21vZHVsZXMvJFVOQU1FX1JF
TEVBU0UvLmNvbmZpZyIKQ09ORklHX0NPTlNUUlVDVE9SUz15CgojCiMgR2VuZXJhbCBzZXR1cAoj
CkNPTkZJR19FWFBFUklNRU5UQUw9eQpDT05GSUdfTE9DS19LRVJORUw9eQpDT05GSUdfSU5JVF9F
TlZfQVJHX0xJTUlUPTMyCkNPTkZJR19MT0NBTFZFUlNJT049IiIKIyBDT05GSUdfTE9DQUxWRVJT
SU9OX0FVVE8gaXMgbm90IHNldApDT05GSUdfSEFWRV9LRVJORUxfR1pJUD15CkNPTkZJR19IQVZF
X0tFUk5FTF9CWklQMj15CkNPTkZJR19IQVZFX0tFUk5FTF9MWk1BPXkKQ09ORklHX0tFUk5FTF9H
WklQPXkKIyBDT05GSUdfS0VSTkVMX0JaSVAyIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VSTkVMX0xa
TUEgaXMgbm90IHNldApDT05GSUdfU1dBUD15CkNPTkZJR19TWVNWSVBDPXkKQ09ORklHX1NZU1ZJ
UENfU1lTQ1RMPXkKQ09ORklHX1BPU0lYX01RVUVVRT15CkNPTkZJR19QT1NJWF9NUVVFVUVfU1lT
Q1RMPXkKQ09ORklHX0JTRF9QUk9DRVNTX0FDQ1Q9eQojIENPTkZJR19CU0RfUFJPQ0VTU19BQ0NU
X1YzIGlzIG5vdCBzZXQKQ09ORklHX1RBU0tTVEFUUz15CkNPTkZJR19UQVNLX0RFTEFZX0FDQ1Q9
eQojIENPTkZJR19UQVNLX1hBQ0NUIGlzIG5vdCBzZXQKQ09ORklHX0FVRElUPXkKQ09ORklHX0FV
RElUU1lTQ0FMTD15CkNPTkZJR19BVURJVF9UUkVFPXkKCiMKIyBSQ1UgU3Vic3lzdGVtCiMKQ09O
RklHX1RSRUVfUkNVPXkKIyBDT05GSUdfVFJFRV9QUkVFTVBUX1JDVSBpcyBub3Qgc2V0CiMgQ09O
RklHX1JDVV9UUkFDRSBpcyBub3Qgc2V0CkNPTkZJR19SQ1VfRkFOT1VUPTMyCiMgQ09ORklHX1JD
VV9GQU5PVVRfRVhBQ1QgaXMgbm90IHNldAojIENPTkZJR19UUkVFX1JDVV9UUkFDRSBpcyBub3Qg
c2V0CiMgQ09ORklHX0lLQ09ORklHIGlzIG5vdCBzZXQKQ09ORklHX0xPR19CVUZfU0hJRlQ9MTcK
Q09ORklHX0hBVkVfVU5TVEFCTEVfU0NIRURfQ0xPQ0s9eQojIENPTkZJR19HUk9VUF9TQ0hFRCBp
cyBub3Qgc2V0CiMgQ09ORklHX0NHUk9VUFMgaXMgbm90IHNldAojIENPTkZJR19TWVNGU19ERVBS
RUNBVEVEX1YyIGlzIG5vdCBzZXQKQ09ORklHX1JFTEFZPXkKQ09ORklHX05BTUVTUEFDRVM9eQoj
IENPTkZJR19VVFNfTlMgaXMgbm90IHNldAojIENPTkZJR19JUENfTlMgaXMgbm90IHNldAojIENP
TkZJR19VU0VSX05TIGlzIG5vdCBzZXQKIyBDT05GSUdfUElEX05TIGlzIG5vdCBzZXQKIyBDT05G
SUdfTkVUX05TIGlzIG5vdCBzZXQKQ09ORklHX0JMS19ERVZfSU5JVFJEPXkKQ09ORklHX0lOSVRS
QU1GU19TT1VSQ0U9IiIKQ09ORklHX1JEX0daSVA9eQpDT05GSUdfUkRfQlpJUDI9eQpDT05GSUdf
UkRfTFpNQT15CkNPTkZJR19DQ19PUFRJTUlaRV9GT1JfU0laRT15CkNPTkZJR19TWVNDVEw9eQpD
T05GSUdfQU5PTl9JTk9ERVM9eQojIENPTkZJR19FTUJFRERFRCBpcyBub3Qgc2V0CkNPTkZJR19V
SUQxNj15CkNPTkZJR19TWVNDVExfU1lTQ0FMTD15CkNPTkZJR19LQUxMU1lNUz15CiMgQ09ORklH
X0tBTExTWU1TX0FMTCBpcyBub3Qgc2V0CkNPTkZJR19LQUxMU1lNU19FWFRSQV9QQVNTPXkKQ09O
RklHX0hPVFBMVUc9eQpDT05GSUdfUFJJTlRLPXkKQ09ORklHX0JVRz15CkNPTkZJR19FTEZfQ09S
RT15CkNPTkZJR19QQ1NQS1JfUExBVEZPUk09eQpDT05GSUdfQkFTRV9GVUxMPXkKQ09ORklHX0ZV
VEVYPXkKQ09ORklHX0VQT0xMPXkKQ09ORklHX1NJR05BTEZEPXkKQ09ORklHX1RJTUVSRkQ9eQpD
T05GSUdfRVZFTlRGRD15CkNPTkZJR19TSE1FTT15CkNPTkZJR19BSU89eQpDT05GSUdfSEFWRV9Q
RVJGX0VWRU5UUz15CgojCiMgS2VybmVsIFBlcmZvcm1hbmNlIEV2ZW50cyBBbmQgQ291bnRlcnMK
IwpDT05GSUdfUEVSRl9FVkVOVFM9eQpDT05GSUdfRVZFTlRfUFJPRklMRT15CiMgQ09ORklHX1BF
UkZfQ09VTlRFUlMgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19QRVJGX1VTRV9WTUFMTE9DIGlz
IG5vdCBzZXQKQ09ORklHX1ZNX0VWRU5UX0NPVU5URVJTPXkKQ09ORklHX1BDSV9RVUlSS1M9eQpD
T05GSUdfQ09NUEFUX0JSSz15CkNPTkZJR19TTEFCPXkKIyBDT05GSUdfU0xVQiBpcyBub3Qgc2V0
CiMgQ09ORklHX1NMT0IgaXMgbm90IHNldApDT05GSUdfUFJPRklMSU5HPXkKQ09ORklHX1RSQUNF
UE9JTlRTPXkKQ09ORklHX09QUk9GSUxFPW0KIyBDT05GSUdfT1BST0ZJTEVfSUJTIGlzIG5vdCBz
ZXQKIyBDT05GSUdfT1BST0ZJTEVfRVZFTlRfTVVMVElQTEVYIGlzIG5vdCBzZXQKQ09ORklHX0hB
VkVfT1BST0ZJTEU9eQpDT05GSUdfS1BST0JFUz15CkNPTkZJR19IQVZFX0VGRklDSUVOVF9VTkFM
SUdORURfQUNDRVNTPXkKQ09ORklHX0tSRVRQUk9CRVM9eQpDT05GSUdfSEFWRV9JT1JFTUFQX1BS
T1Q9eQpDT05GSUdfSEFWRV9LUFJPQkVTPXkKQ09ORklHX0hBVkVfS1JFVFBST0JFUz15CkNPTkZJ
R19IQVZFX0FSQ0hfVFJBQ0VIT09LPXkKQ09ORklHX0hBVkVfRE1BX0FUVFJTPXkKQ09ORklHX0hB
VkVfRE1BX0FQSV9ERUJVRz15CgojCiMgR0NPVi1iYXNlZCBrZXJuZWwgcHJvZmlsaW5nCiMKIyBD
T05GSUdfR0NPVl9LRVJORUwgaXMgbm90IHNldApDT05GSUdfU0xPV19XT1JLPXkKIyBDT05GSUdf
U0xPV19XT1JLX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfR0VORVJJQ19ETUFfQ09IRVJF
TlQ9eQpDT05GSUdfU0xBQklORk89eQpDT05GSUdfUlRfTVVURVhFUz15CkNPTkZJR19CQVNFX1NN
QUxMPTAKQ09ORklHX01PRFVMRVM9eQojIENPTkZJR19NT0RVTEVfRk9SQ0VfTE9BRCBpcyBub3Qg
c2V0CkNPTkZJR19NT0RVTEVfVU5MT0FEPXkKIyBDT05GSUdfTU9EVUxFX0ZPUkNFX1VOTE9BRCBp
cyBub3Qgc2V0CkNPTkZJR19NT0RWRVJTSU9OUz15CkNPTkZJR19NT0RVTEVfU1JDVkVSU0lPTl9B
TEw9eQpDT05GSUdfU1RPUF9NQUNISU5FPXkKQ09ORklHX0JMT0NLPXkKQ09ORklHX0xCREFGPXkK
Q09ORklHX0JMS19ERVZfQlNHPXkKIyBDT05GSUdfQkxLX0RFVl9JTlRFR1JJVFkgaXMgbm90IHNl
dAoKIwojIElPIFNjaGVkdWxlcnMKIwpDT05GSUdfSU9TQ0hFRF9OT09QPXkKQ09ORklHX0lPU0NI
RURfQVM9eQpDT05GSUdfSU9TQ0hFRF9ERUFETElORT15CkNPTkZJR19JT1NDSEVEX0NGUT15CiMg
Q09ORklHX0RFRkFVTFRfQVMgaXMgbm90IHNldAojIENPTkZJR19ERUZBVUxUX0RFQURMSU5FIGlz
IG5vdCBzZXQKQ09ORklHX0RFRkFVTFRfQ0ZRPXkKIyBDT05GSUdfREVGQVVMVF9OT09QIGlzIG5v
dCBzZXQKQ09ORklHX0RFRkFVTFRfSU9TQ0hFRD0iY2ZxIgojIENPTkZJR19GUkVFWkVSIGlzIG5v
dCBzZXQKCiMKIyBQcm9jZXNzb3IgdHlwZSBhbmQgZmVhdHVyZXMKIwojIENPTkZJR19OT19IWiBp
cyBub3Qgc2V0CiMgQ09ORklHX0hJR0hfUkVTX1RJTUVSUyBpcyBub3Qgc2V0CkNPTkZJR19HRU5F
UklDX0NMT0NLRVZFTlRTX0JVSUxEPXkKQ09ORklHX1NNUD15CiMgQ09ORklHX1NQQVJTRV9JUlEg
aXMgbm90IHNldApDT05GSUdfWDg2X01QUEFSU0U9eQojIENPTkZJR19YODZfQklHU01QIGlzIG5v
dCBzZXQKQ09ORklHX1g4Nl9FWFRFTkRFRF9QTEFURk9STT15CiMgQ09ORklHX1g4Nl9FTEFOIGlz
IG5vdCBzZXQKIyBDT05GSUdfWDg2X01SU1QgaXMgbm90IHNldAojIENPTkZJR19YODZfUkRDMzIx
WCBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl8zMl9OT05fU1RBTkRBUkQgaXMgbm90IHNldApDT05G
SUdfWDg2X1NVUFBPUlRTX01FTU9SWV9GQUlMVVJFPXkKQ09ORklHX1NDSEVEX09NSVRfRlJBTUVf
UE9JTlRFUj15CiMgQ09ORklHX1BBUkFWSVJUX0dVRVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfTUVN
VEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX00zODYgaXMgbm90IHNldAojIENPTkZJR19NNDg2IGlz
IG5vdCBzZXQKIyBDT05GSUdfTTU4NiBpcyBub3Qgc2V0CiMgQ09ORklHX001ODZUU0MgaXMgbm90
IHNldAojIENPTkZJR19NNTg2TU1YIGlzIG5vdCBzZXQKIyBDT05GSUdfTTY4NiBpcyBub3Qgc2V0
CiMgQ09ORklHX01QRU5USVVNSUkgaXMgbm90IHNldAojIENPTkZJR19NUEVOVElVTUlJSSBpcyBu
b3Qgc2V0CiMgQ09ORklHX01QRU5USVVNTSBpcyBub3Qgc2V0CiMgQ09ORklHX01QRU5USVVNNCBp
cyBub3Qgc2V0CiMgQ09ORklHX01LNiBpcyBub3Qgc2V0CiMgQ09ORklHX01LNyBpcyBub3Qgc2V0
CkNPTkZJR19NSzg9eQojIENPTkZJR19NQ1JVU09FIGlzIG5vdCBzZXQKIyBDT05GSUdfTUVGRklD
RU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfTVdJTkNISVBDNiBpcyBub3Qgc2V0CiMgQ09ORklHX01X
SU5DSElQM0QgaXMgbm90IHNldAojIENPTkZJR19NR0VPREVHWDEgaXMgbm90IHNldAojIENPTkZJ
R19NR0VPREVfTFggaXMgbm90IHNldAojIENPTkZJR19NQ1lSSVhJSUkgaXMgbm90IHNldAojIENP
TkZJR19NVklBQzNfMiBpcyBub3Qgc2V0CiMgQ09ORklHX01WSUFDNyBpcyBub3Qgc2V0CiMgQ09O
RklHX01QU0MgaXMgbm90IHNldAojIENPTkZJR19NQ09SRTIgaXMgbm90IHNldAojIENPTkZJR19N
QVRPTSBpcyBub3Qgc2V0CiMgQ09ORklHX0dFTkVSSUNfQ1BVIGlzIG5vdCBzZXQKQ09ORklHX1g4
Nl9HRU5FUklDPXkKQ09ORklHX1g4Nl9DUFU9eQpDT05GSUdfWDg2X0wxX0NBQ0hFX0JZVEVTPTY0
CkNPTkZJR19YODZfSU5URVJOT0RFX0NBQ0hFX0JZVEVTPTY0CkNPTkZJR19YODZfQ01QWENIRz15
CkNPTkZJR19YODZfTDFfQ0FDSEVfU0hJRlQ9NgpDT05GSUdfWDg2X1hBREQ9eQpDT05GSUdfWDg2
X1dQX1dPUktTX09LPXkKQ09ORklHX1g4Nl9JTlZMUEc9eQpDT05GSUdfWDg2X0JTV0FQPXkKQ09O
RklHX1g4Nl9QT1BBRF9PSz15CkNPTkZJR19YODZfSU5URUxfVVNFUkNPUFk9eQpDT05GSUdfWDg2
X1VTRV9QUFJPX0NIRUNLU1VNPXkKQ09ORklHX1g4Nl9UU0M9eQpDT05GSUdfWDg2X0NNT1Y9eQpD
T05GSUdfWDg2X01JTklNVU1fQ1BVX0ZBTUlMWT00CkNPTkZJR19YODZfREVCVUdDVExNU1I9eQpD
T05GSUdfQ1BVX1NVUF9JTlRFTD15CkNPTkZJR19DUFVfU1VQX0NZUklYXzMyPXkKQ09ORklHX0NQ
VV9TVVBfQU1EPXkKQ09ORklHX0NQVV9TVVBfQ0VOVEFVUj15CkNPTkZJR19DUFVfU1VQX1RSQU5T
TUVUQV8zMj15CkNPTkZJR19DUFVfU1VQX1VNQ18zMj15CiMgQ09ORklHX1g4Nl9EUyBpcyBub3Qg
c2V0CkNPTkZJR19IUEVUX1RJTUVSPXkKQ09ORklHX0hQRVRfRU1VTEFURV9SVEM9eQpDT05GSUdf
RE1JPXkKIyBDT05GSUdfSU9NTVVfSEVMUEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfSU9NTVVfQVBJ
IGlzIG5vdCBzZXQKQ09ORklHX05SX0NQVVM9OApDT05GSUdfU0NIRURfU01UPXkKQ09ORklHX1ND
SEVEX01DPXkKIyBDT05GSUdfUFJFRU1QVF9OT05FIGlzIG5vdCBzZXQKQ09ORklHX1BSRUVNUFRf
Vk9MVU5UQVJZPXkKIyBDT05GSUdfUFJFRU1QVCBpcyBub3Qgc2V0CkNPTkZJR19YODZfTE9DQUxf
QVBJQz15CkNPTkZJR19YODZfSU9fQVBJQz15CiMgQ09ORklHX1g4Nl9SRVJPVVRFX0ZPUl9CUk9L
RU5fQk9PVF9JUlFTIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9NQ0U9eQpDT05GSUdfWDg2X01DRV9J
TlRFTD15CkNPTkZJR19YODZfTUNFX0FNRD15CiMgQ09ORklHX1g4Nl9BTkNJRU5UX01DRSBpcyBu
b3Qgc2V0CkNPTkZJR19YODZfTUNFX1RIUkVTSE9MRD15CiMgQ09ORklHX1g4Nl9NQ0VfSU5KRUNU
IGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9USEVSTUFMX1ZFQ1RPUj15CkNPTkZJR19WTTg2PXkKQ09O
RklHX1RPU0hJQkE9bQpDT05GSUdfSThLPW0KIyBDT05GSUdfWDg2X1JFQk9PVEZJWFVQUyBpcyBu
b3Qgc2V0CkNPTkZJR19NSUNST0NPREU9bQpDT05GSUdfTUlDUk9DT0RFX0lOVEVMPXkKIyBDT05G
SUdfTUlDUk9DT0RFX0FNRCBpcyBub3Qgc2V0CkNPTkZJR19NSUNST0NPREVfT0xEX0lOVEVSRkFD
RT15CkNPTkZJR19YODZfTVNSPW0KQ09ORklHX1g4Nl9DUFVJRD1tCiMgQ09ORklHX1g4Nl9DUFVf
REVCVUcgaXMgbm90IHNldAojIENPTkZJR19OT0hJR0hNRU0gaXMgbm90IHNldApDT05GSUdfSElH
SE1FTTRHPXkKIyBDT05GSUdfSElHSE1FTTY0RyBpcyBub3Qgc2V0CkNPTkZJR19QQUdFX09GRlNF
VD0weEMwMDAwMDAwCkNPTkZJR19ISUdITUVNPXkKIyBDT05GSUdfQVJDSF9QSFlTX0FERFJfVF82
NEJJVCBpcyBub3Qgc2V0CkNPTkZJR19BUkNIX0ZMQVRNRU1fRU5BQkxFPXkKQ09ORklHX0FSQ0hf
U1BBUlNFTUVNX0VOQUJMRT15CkNPTkZJR19BUkNIX1NFTEVDVF9NRU1PUllfTU9ERUw9eQpDT05G
SUdfU0VMRUNUX01FTU9SWV9NT0RFTD15CkNPTkZJR19GTEFUTUVNX01BTlVBTD15CiMgQ09ORklH
X0RJU0NPTlRJR01FTV9NQU5VQUwgaXMgbm90IHNldAojIENPTkZJR19TUEFSU0VNRU1fTUFOVUFM
IGlzIG5vdCBzZXQKQ09ORklHX0ZMQVRNRU09eQpDT05GSUdfRkxBVF9OT0RFX01FTV9NQVA9eQpD
T05GSUdfU1BBUlNFTUVNX1NUQVRJQz15CkNPTkZJR19QQUdFRkxBR1NfRVhURU5ERUQ9eQpDT05G
SUdfU1BMSVRfUFRMT0NLX0NQVVM9NAojIENPTkZJR19QSFlTX0FERFJfVF82NEJJVCBpcyBub3Qg
c2V0CkNPTkZJR19aT05FX0RNQV9GTEFHPTEKQ09ORklHX0JPVU5DRT15CkNPTkZJR19WSVJUX1RP
X0JVUz15CkNPTkZJR19IQVZFX01MT0NLPXkKQ09ORklHX0hBVkVfTUxPQ0tFRF9QQUdFX0JJVD15
CiMgQ09ORklHX0tTTSBpcyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX01NQVBfTUlOX0FERFI9NDA5
NgpDT05GSUdfQVJDSF9TVVBQT1JUU19NRU1PUllfRkFJTFVSRT15CiMgQ09ORklHX01FTU9SWV9G
QUlMVVJFIGlzIG5vdCBzZXQKQ09ORklHX0hJR0hQVEU9eQojIENPTkZJR19YODZfQ0hFQ0tfQklP
U19DT1JSVVBUSU9OIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9SRVNFUlZFX0xPV182NEs9eQojIENP
TkZJR19NQVRIX0VNVUxBVElPTiBpcyBub3Qgc2V0CkNPTkZJR19NVFJSPXkKQ09ORklHX01UUlJf
U0FOSVRJWkVSPXkKQ09ORklHX01UUlJfU0FOSVRJWkVSX0VOQUJMRV9ERUZBVUxUPTAKQ09ORklH
X01UUlJfU0FOSVRJWkVSX1NQQVJFX1JFR19OUl9ERUZBVUxUPTEKIyBDT05GSUdfWDg2X1BBVCBp
cyBub3Qgc2V0CkNPTkZJR19FRkk9eQojIENPTkZJR19TRUNDT01QIGlzIG5vdCBzZXQKIyBDT05G
SUdfQ0NfU1RBQ0tQUk9URUNUT1IgaXMgbm90IHNldAojIENPTkZJR19IWl8xMDAgaXMgbm90IHNl
dAojIENPTkZJR19IWl8yNTAgaXMgbm90IHNldAojIENPTkZJR19IWl8zMDAgaXMgbm90IHNldApD
T05GSUdfSFpfMTAwMD15CkNPTkZJR19IWj0xMDAwCiMgQ09ORklHX1NDSEVEX0hSVElDSyBpcyBu
b3Qgc2V0CkNPTkZJR19LRVhFQz15CkNPTkZJR19DUkFTSF9EVU1QPXkKQ09ORklHX1BIWVNJQ0FM
X1NUQVJUPTB4MTAwMDAwMApDT05GSUdfUkVMT0NBVEFCTEU9eQpDT05GSUdfWDg2X05FRURfUkVM
T0NTPXkKQ09ORklHX1BIWVNJQ0FMX0FMSUdOPTB4NDAwMDAwCkNPTkZJR19IT1RQTFVHX0NQVT15
CiMgQ09ORklHX0NPTVBBVF9WRFNPIGlzIG5vdCBzZXQKIyBDT05GSUdfQ01ETElORV9CT09MIGlz
IG5vdCBzZXQKQ09ORklHX0FSQ0hfRU5BQkxFX01FTU9SWV9IT1RQTFVHPXkKCiMKIyBQb3dlciBt
YW5hZ2VtZW50IGFuZCBBQ1BJIG9wdGlvbnMKIwpDT05GSUdfUE09eQojIENPTkZJR19QTV9ERUJV
RyBpcyBub3Qgc2V0CiMgQ09ORklHX1NVU1BFTkQgaXMgbm90IHNldAojIENPTkZJR19ISUJFUk5B
VElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX1BNX1JVTlRJTUUgaXMgbm90IHNldApDT05GSUdfQUNQ
ST15CiMgQ09ORklHX0FDUElfUFJPQ0ZTIGlzIG5vdCBzZXQKQ09ORklHX0FDUElfUFJPQ0ZTX1BP
V0VSPXkKQ09ORklHX0FDUElfUE9XRVJfTUVURVI9bQpDT05GSUdfQUNQSV9TWVNGU19QT1dFUj15
CkNPTkZJR19BQ1BJX1BST0NfRVZFTlQ9eQpDT05GSUdfQUNQSV9BQz1tCkNPTkZJR19BQ1BJX0JB
VFRFUlk9bQpDT05GSUdfQUNQSV9CVVRUT049bQpDT05GSUdfQUNQSV9WSURFTz1tCkNPTkZJR19B
Q1BJX0ZBTj15CkNPTkZJR19BQ1BJX0RPQ0s9eQpDT05GSUdfQUNQSV9QUk9DRVNTT1I9eQpDT05G
SUdfQUNQSV9IT1RQTFVHX0NQVT15CiMgQ09ORklHX0FDUElfUFJPQ0VTU09SX0FHR1JFR0FUT1Ig
aXMgbm90IHNldApDT05GSUdfQUNQSV9USEVSTUFMPXkKIyBDT05GSUdfQUNQSV9DVVNUT01fRFNE
VCBpcyBub3Qgc2V0CkNPTkZJR19BQ1BJX0JMQUNLTElTVF9ZRUFSPTE5OTkKIyBDT05GSUdfQUNQ
SV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX0FDUElfUENJX1NMT1QgaXMgbm90IHNldApDT05G
SUdfWDg2X1BNX1RJTUVSPXkKQ09ORklHX0FDUElfQ09OVEFJTkVSPXkKQ09ORklHX0FDUElfU0JT
PW0KIyBDT05GSUdfU0ZJIGlzIG5vdCBzZXQKCiMKIyBDUFUgRnJlcXVlbmN5IHNjYWxpbmcKIwpD
T05GSUdfQ1BVX0ZSRVE9eQpDT05GSUdfQ1BVX0ZSRVFfVEFCTEU9eQpDT05GSUdfQ1BVX0ZSRVFf
REVCVUc9eQpDT05GSUdfQ1BVX0ZSRVFfU1RBVD1tCkNPTkZJR19DUFVfRlJFUV9TVEFUX0RFVEFJ
TFM9eQojIENPTkZJR19DUFVfRlJFUV9ERUZBVUxUX0dPVl9QRVJGT1JNQU5DRSBpcyBub3Qgc2V0
CiMgQ09ORklHX0NQVV9GUkVRX0RFRkFVTFRfR09WX1BPV0VSU0FWRSBpcyBub3Qgc2V0CkNPTkZJ
R19DUFVfRlJFUV9ERUZBVUxUX0dPVl9VU0VSU1BBQ0U9eQojIENPTkZJR19DUFVfRlJFUV9ERUZB
VUxUX0dPVl9PTkRFTUFORCBpcyBub3Qgc2V0CiMgQ09ORklHX0NQVV9GUkVRX0RFRkFVTFRfR09W
X0NPTlNFUlZBVElWRSBpcyBub3Qgc2V0CkNPTkZJR19DUFVfRlJFUV9HT1ZfUEVSRk9STUFOQ0U9
eQpDT05GSUdfQ1BVX0ZSRVFfR09WX1BPV0VSU0FWRT1tCkNPTkZJR19DUFVfRlJFUV9HT1ZfVVNF
UlNQQUNFPXkKQ09ORklHX0NQVV9GUkVRX0dPVl9PTkRFTUFORD1tCkNPTkZJR19DUFVfRlJFUV9H
T1ZfQ09OU0VSVkFUSVZFPW0KCiMKIyBDUFVGcmVxIHByb2Nlc3NvciBkcml2ZXJzCiMKQ09ORklH
X1g4Nl9BQ1BJX0NQVUZSRVE9bQojIENPTkZJR19YODZfUE9XRVJOT1dfSzYgaXMgbm90IHNldApD
T05GSUdfWDg2X1BPV0VSTk9XX0s3PXkKQ09ORklHX1g4Nl9QT1dFUk5PV19LN19BQ1BJPXkKQ09O
RklHX1g4Nl9QT1dFUk5PV19LOD15CiMgQ09ORklHX1g4Nl9HWF9TVVNQTU9EIGlzIG5vdCBzZXQK
Q09ORklHX1g4Nl9TUEVFRFNURVBfQ0VOVFJJTk89eQpDT05GSUdfWDg2X1NQRUVEU1RFUF9DRU5U
UklOT19UQUJMRT15CkNPTkZJR19YODZfU1BFRURTVEVQX0lDSD15CkNPTkZJR19YODZfU1BFRURT
VEVQX1NNST15CkNPTkZJR19YODZfUDRfQ0xPQ0tNT0Q9bQojIENPTkZJR19YODZfQ1BVRlJFUV9O
Rk9SQ0UyIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9MT05HUlVOPXkKIyBDT05GSUdfWDg2X0xPTkdI
QVVMIGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X0VfUE9XRVJTQVZFUiBpcyBub3Qgc2V0CgojCiMg
c2hhcmVkIG9wdGlvbnMKIwpDT05GSUdfWDg2X1NQRUVEU1RFUF9MSUI9eQojIENPTkZJR19YODZf
U1BFRURTVEVQX1JFTEFYRURfQ0FQX0NIRUNLIGlzIG5vdCBzZXQKQ09ORklHX0NQVV9JRExFPXkK
Q09ORklHX0NQVV9JRExFX0dPVl9MQURERVI9eQoKIwojIEJ1cyBvcHRpb25zIChQQ0kgZXRjLikK
IwpDT05GSUdfUENJPXkKIyBDT05GSUdfUENJX0dPQklPUyBpcyBub3Qgc2V0CiMgQ09ORklHX1BD
SV9HT01NQ09ORklHIGlzIG5vdCBzZXQKIyBDT05GSUdfUENJX0dPRElSRUNUIGlzIG5vdCBzZXQK
IyBDT05GSUdfUENJX0dPT0xQQyBpcyBub3Qgc2V0CkNPTkZJR19QQ0lfR09BTlk9eQpDT05GSUdf
UENJX0JJT1M9eQpDT05GSUdfUENJX0RJUkVDVD15CkNPTkZJR19QQ0lfTU1DT05GSUc9eQpDT05G
SUdfUENJX0RPTUFJTlM9eQojIENPTkZJR19ETUFSIGlzIG5vdCBzZXQKQ09ORklHX1BDSUVQT1JU
QlVTPXkKQ09ORklHX0hPVFBMVUdfUENJX1BDSUU9bQpDT05GSUdfUENJRUFFUj15CiMgQ09ORklH
X1BDSUVfRUNSQyBpcyBub3Qgc2V0CiMgQ09ORklHX1BDSUVBRVJfSU5KRUNUIGlzIG5vdCBzZXQK
IyBDT05GSUdfUENJRUFTUE0gaXMgbm90IHNldApDT05GSUdfQVJDSF9TVVBQT1JUU19NU0k9eQpD
T05GSUdfUENJX01TST15CkNPTkZJR19QQ0lfTEVHQUNZPXkKIyBDT05GSUdfUENJX0RFQlVHIGlz
IG5vdCBzZXQKIyBDT05GSUdfUENJX1NUVUIgaXMgbm90IHNldApDT05GSUdfSFRfSVJRPXkKIyBD
T05GSUdfUENJX0lPViBpcyBub3Qgc2V0CkNPTkZJR19JU0FfRE1BX0FQST15CiMgQ09ORklHX0lT
QSBpcyBub3Qgc2V0CiMgQ09ORklHX01DQSBpcyBub3Qgc2V0CiMgQ09ORklHX1NDeDIwMCBpcyBu
b3Qgc2V0CiMgQ09ORklHX09MUEMgaXMgbm90IHNldApDT05GSUdfSzhfTkI9eQpDT05GSUdfUEND
QVJEPXkKIyBDT05GSUdfUENNQ0lBX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX1BDTUNJQT15CkNP
TkZJR19QQ01DSUFfTE9BRF9DSVM9eQpDT05GSUdfUENNQ0lBX0lPQ1RMPXkKQ09ORklHX0NBUkRC
VVM9eQoKIwojIFBDLWNhcmQgYnJpZGdlcwojCkNPTkZJR19ZRU5UQT15CkNPTkZJR19ZRU5UQV9P
Mj15CkNPTkZJR19ZRU5UQV9SSUNPSD15CkNPTkZJR19ZRU5UQV9UST15CkNPTkZJR19ZRU5UQV9F
TkVfVFVORT15CkNPTkZJR19ZRU5UQV9UT1NISUJBPXkKQ09ORklHX1BENjcyOT1tCiMgQ09ORklH
X0k4MjA5MiBpcyBub3Qgc2V0CkNPTkZJR19QQ0NBUkRfTk9OU1RBVElDPXkKQ09ORklHX0hPVFBM
VUdfUENJPXkKQ09ORklHX0hPVFBMVUdfUENJX0ZBS0U9bQpDT05GSUdfSE9UUExVR19QQ0lfQ09N
UEFRPW0KIyBDT05GSUdfSE9UUExVR19QQ0lfQ09NUEFRX05WUkFNIGlzIG5vdCBzZXQKQ09ORklH
X0hPVFBMVUdfUENJX0lCTT1tCkNPTkZJR19IT1RQTFVHX1BDSV9BQ1BJPW0KQ09ORklHX0hPVFBM
VUdfUENJX0FDUElfSUJNPW0KIyBDT05GSUdfSE9UUExVR19QQ0lfQ1BDSSBpcyBub3Qgc2V0CiMg
Q09ORklHX0hPVFBMVUdfUENJX1NIUEMgaXMgbm90IHNldAoKIwojIEV4ZWN1dGFibGUgZmlsZSBm
b3JtYXRzIC8gRW11bGF0aW9ucwojCkNPTkZJR19CSU5GTVRfRUxGPXkKIyBDT05GSUdfQ09SRV9E
VU1QX0RFRkFVTFRfRUxGX0hFQURFUlMgaXMgbm90IHNldApDT05GSUdfSEFWRV9BT1VUPXkKIyBD
T05GSUdfQklORk1UX0FPVVQgaXMgbm90IHNldApDT05GSUdfQklORk1UX01JU0M9eQpDT05GSUdf
SEFWRV9BVE9NSUNfSU9NQVA9eQpDT05GSUdfTkVUPXkKCiMKIyBOZXR3b3JraW5nIG9wdGlvbnMK
IwpDT05GSUdfUEFDS0VUPXkKQ09ORklHX1BBQ0tFVF9NTUFQPXkKQ09ORklHX1VOSVg9eQpDT05G
SUdfWEZSTT15CkNPTkZJR19YRlJNX1VTRVI9eQojIENPTkZJR19YRlJNX1NVQl9QT0xJQ1kgaXMg
bm90IHNldAojIENPTkZJR19YRlJNX01JR1JBVEUgaXMgbm90IHNldAojIENPTkZJR19YRlJNX1NU
QVRJU1RJQ1MgaXMgbm90IHNldApDT05GSUdfWEZSTV9JUENPTVA9bQpDT05GSUdfTkVUX0tFWT1t
CiMgQ09ORklHX05FVF9LRVlfTUlHUkFURSBpcyBub3Qgc2V0CkNPTkZJR19JTkVUPXkKQ09ORklH
X0lQX01VTFRJQ0FTVD15CkNPTkZJR19JUF9BRFZBTkNFRF9ST1VURVI9eQpDT05GSUdfQVNLX0lQ
X0ZJQl9IQVNIPXkKIyBDT05GSUdfSVBfRklCX1RSSUUgaXMgbm90IHNldApDT05GSUdfSVBfRklC
X0hBU0g9eQpDT05GSUdfSVBfTVVMVElQTEVfVEFCTEVTPXkKQ09ORklHX0lQX1JPVVRFX01VTFRJ
UEFUSD15CkNPTkZJR19JUF9ST1VURV9WRVJCT1NFPXkKIyBDT05GSUdfSVBfUE5QIGlzIG5vdCBz
ZXQKQ09ORklHX05FVF9JUElQPW0KQ09ORklHX05FVF9JUEdSRT1tCkNPTkZJR19ORVRfSVBHUkVf
QlJPQURDQVNUPXkKQ09ORklHX0lQX01ST1VURT15CkNPTkZJR19JUF9QSU1TTV9WMT15CkNPTkZJ
R19JUF9QSU1TTV9WMj15CiMgQ09ORklHX0FSUEQgaXMgbm90IHNldApDT05GSUdfU1lOX0NPT0tJ
RVM9eQpDT05GSUdfSU5FVF9BSD1tCkNPTkZJR19JTkVUX0VTUD1tCkNPTkZJR19JTkVUX0lQQ09N
UD1tCkNPTkZJR19JTkVUX1hGUk1fVFVOTkVMPW0KQ09ORklHX0lORVRfVFVOTkVMPW0KQ09ORklH
X0lORVRfWEZSTV9NT0RFX1RSQU5TUE9SVD1tCkNPTkZJR19JTkVUX1hGUk1fTU9ERV9UVU5ORUw9
bQpDT05GSUdfSU5FVF9YRlJNX01PREVfQkVFVD15CkNPTkZJR19JTkVUX0xSTz15CkNPTkZJR19J
TkVUX0RJQUc9bQpDT05GSUdfSU5FVF9UQ1BfRElBRz1tCkNPTkZJR19UQ1BfQ09OR19BRFZBTkNF
RD15CkNPTkZJR19UQ1BfQ09OR19CSUM9eQpDT05GSUdfVENQX0NPTkdfQ1VCSUM9bQpDT05GSUdf
VENQX0NPTkdfV0VTVFdPT0Q9bQpDT05GSUdfVENQX0NPTkdfSFRDUD1tCkNPTkZJR19UQ1BfQ09O
R19IU1RDUD1tCkNPTkZJR19UQ1BfQ09OR19IWUJMQT1tCkNPTkZJR19UQ1BfQ09OR19WRUdBUz1t
CkNPTkZJR19UQ1BfQ09OR19TQ0FMQUJMRT1tCkNPTkZJR19UQ1BfQ09OR19MUD1tCkNPTkZJR19U
Q1BfQ09OR19WRU5PPW0KIyBDT05GSUdfVENQX0NPTkdfWUVBSCBpcyBub3Qgc2V0CiMgQ09ORklH
X1RDUF9DT05HX0lMTElOT0lTIGlzIG5vdCBzZXQKQ09ORklHX0RFRkFVTFRfQklDPXkKIyBDT05G
SUdfREVGQVVMVF9DVUJJQyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFRkFVTFRfSFRDUCBpcyBub3Qg
c2V0CiMgQ09ORklHX0RFRkFVTFRfVkVHQVMgaXMgbm90IHNldAojIENPTkZJR19ERUZBVUxUX1dF
U1RXT09EIGlzIG5vdCBzZXQKIyBDT05GSUdfREVGQVVMVF9SRU5PIGlzIG5vdCBzZXQKQ09ORklH
X0RFRkFVTFRfVENQX0NPTkc9ImJpYyIKIyBDT05GSUdfVENQX01ENVNJRyBpcyBub3Qgc2V0CkNP
TkZJR19JUFY2PW0KQ09ORklHX0lQVjZfUFJJVkFDWT15CkNPTkZJR19JUFY2X1JPVVRFUl9QUkVG
PXkKQ09ORklHX0lQVjZfUk9VVEVfSU5GTz15CiMgQ09ORklHX0lQVjZfT1BUSU1JU1RJQ19EQUQg
aXMgbm90IHNldApDT05GSUdfSU5FVDZfQUg9bQpDT05GSUdfSU5FVDZfRVNQPW0KQ09ORklHX0lO
RVQ2X0lQQ09NUD1tCiMgQ09ORklHX0lQVjZfTUlQNiBpcyBub3Qgc2V0CkNPTkZJR19JTkVUNl9Y
RlJNX1RVTk5FTD1tCkNPTkZJR19JTkVUNl9UVU5ORUw9bQpDT05GSUdfSU5FVDZfWEZSTV9NT0RF
X1RSQU5TUE9SVD1tCkNPTkZJR19JTkVUNl9YRlJNX01PREVfVFVOTkVMPW0KQ09ORklHX0lORVQ2
X1hGUk1fTU9ERV9CRUVUPW0KIyBDT05GSUdfSU5FVDZfWEZSTV9NT0RFX1JPVVRFT1BUSU1JWkFU
SU9OIGlzIG5vdCBzZXQKQ09ORklHX0lQVjZfU0lUPW0KQ09ORklHX0lQVjZfTkRJU0NfTk9ERVRZ
UEU9eQpDT05GSUdfSVBWNl9UVU5ORUw9bQpDT05GSUdfSVBWNl9NVUxUSVBMRV9UQUJMRVM9eQoj
IENPTkZJR19JUFY2X1NVQlRSRUVTIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBWNl9NUk9VVEUgaXMg
bm90IHNldApDT05GSUdfTkVUTEFCRUw9eQpDT05GSUdfTkVUV09SS19TRUNNQVJLPXkKQ09ORklH
X05FVEZJTFRFUj15CiMgQ09ORklHX05FVEZJTFRFUl9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19O
RVRGSUxURVJfQURWQU5DRUQ9eQpDT05GSUdfQlJJREdFX05FVEZJTFRFUj15CgojCiMgQ29yZSBO
ZXRmaWx0ZXIgQ29uZmlndXJhdGlvbgojCkNPTkZJR19ORVRGSUxURVJfTkVUTElOSz1tCkNPTkZJ
R19ORVRGSUxURVJfTkVUTElOS19RVUVVRT1tCkNPTkZJR19ORVRGSUxURVJfTkVUTElOS19MT0c9
bQojIENPTkZJR19ORl9DT05OVFJBQ0sgaXMgbm90IHNldAojIENPTkZJR19ORVRGSUxURVJfVFBS
T1hZIGlzIG5vdCBzZXQKQ09ORklHX05FVEZJTFRFUl9YVEFCTEVTPW0KQ09ORklHX05FVEZJTFRF
Ul9YVF9UQVJHRVRfQ0xBU1NJRlk9bQojIENPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX0RTQ1Ag
aXMgbm90IHNldApDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9ITD1tCiMgQ09ORklHX05FVEZJ
TFRFUl9YVF9UQVJHRVRfTEVEIGlzIG5vdCBzZXQKQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRf
TUFSSz1tCiMgQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfTkZMT0cgaXMgbm90IHNldApDT05G
SUdfTkVURklMVEVSX1hUX1RBUkdFVF9ORlFVRVVFPW0KIyBDT05GSUdfTkVURklMVEVSX1hUX1RB
UkdFVF9SQVRFRVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9UUkFD
RSBpcyBub3Qgc2V0CkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX1NFQ01BUks9bQojIENPTkZJ
R19ORVRGSUxURVJfWFRfVEFSR0VUX1RDUE1TUyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVEZJTFRF
Ul9YVF9UQVJHRVRfVENQT1BUU1RSSVAgaXMgbm90IHNldApDT05GSUdfTkVURklMVEVSX1hUX01B
VENIX0NPTU1FTlQ9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0RDQ1A9bQojIENPTkZJR19O
RVRGSUxURVJfWFRfTUFUQ0hfRFNDUCBpcyBub3Qgc2V0CkNPTkZJR19ORVRGSUxURVJfWFRfTUFU
Q0hfRVNQPW0KIyBDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0hBU0hMSU1JVCBpcyBub3Qgc2V0
CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfSEw9bQojIENPTkZJR19ORVRGSUxURVJfWFRfTUFU
Q0hfSVBSQU5HRSBpcyBub3Qgc2V0CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfTEVOR1RIPW0K
Q09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9MSU1JVD1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFU
Q0hfTUFDPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9NQVJLPW0KQ09ORklHX05FVEZJTFRF
Ul9YVF9NQVRDSF9NVUxUSVBPUlQ9bQojIENPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfT1dORVIg
aXMgbm90IHNldApDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1BPTElDWT1tCkNPTkZJR19ORVRG
SUxURVJfWFRfTUFUQ0hfUEhZU0RFVj1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfUEtUVFlQ
RT1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfUVVPVEE9bQojIENPTkZJR19ORVRGSUxURVJf
WFRfTUFUQ0hfUkFURUVTVCBpcyBub3Qgc2V0CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfUkVB
TE09bQojIENPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfUkVDRU5UIGlzIG5vdCBzZXQKQ09ORklH
X05FVEZJTFRFUl9YVF9NQVRDSF9TQ1RQPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9TVEFU
SVNUSUM9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1NUUklORz1tCkNPTkZJR19ORVRGSUxU
RVJfWFRfTUFUQ0hfVENQTVNTPW0KIyBDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1RJTUUgaXMg
bm90IHNldAojIENPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfVTMyIGlzIG5vdCBzZXQKIyBDT05G
SUdfTkVURklMVEVSX1hUX01BVENIX09TRiBpcyBub3Qgc2V0CkNPTkZJR19JUF9WUz1tCiMgQ09O
RklHX0lQX1ZTX0lQVjYgaXMgbm90IHNldAojIENPTkZJR19JUF9WU19ERUJVRyBpcyBub3Qgc2V0
CkNPTkZJR19JUF9WU19UQUJfQklUUz0xMgoKIwojIElQVlMgdHJhbnNwb3J0IHByb3RvY29sIGxv
YWQgYmFsYW5jaW5nIHN1cHBvcnQKIwpDT05GSUdfSVBfVlNfUFJPVE9fVENQPXkKQ09ORklHX0lQ
X1ZTX1BST1RPX1VEUD15CkNPTkZJR19JUF9WU19QUk9UT19BSF9FU1A9eQpDT05GSUdfSVBfVlNf
UFJPVE9fRVNQPXkKQ09ORklHX0lQX1ZTX1BST1RPX0FIPXkKCiMKIyBJUFZTIHNjaGVkdWxlcgoj
CkNPTkZJR19JUF9WU19SUj1tCkNPTkZJR19JUF9WU19XUlI9bQpDT05GSUdfSVBfVlNfTEM9bQpD
T05GSUdfSVBfVlNfV0xDPW0KQ09ORklHX0lQX1ZTX0xCTEM9bQpDT05GSUdfSVBfVlNfTEJMQ1I9
bQpDT05GSUdfSVBfVlNfREg9bQpDT05GSUdfSVBfVlNfU0g9bQpDT05GSUdfSVBfVlNfU0VEPW0K
Q09ORklHX0lQX1ZTX05RPW0KCiMKIyBJUFZTIGFwcGxpY2F0aW9uIGhlbHBlcgojCkNPTkZJR19J
UF9WU19GVFA9bQoKIwojIElQOiBOZXRmaWx0ZXIgQ29uZmlndXJhdGlvbgojCiMgQ09ORklHX05G
X0RFRlJBR19JUFY0IGlzIG5vdCBzZXQKQ09ORklHX0lQX05GX1FVRVVFPW0KQ09ORklHX0lQX05G
X0lQVEFCTEVTPW0KQ09ORklHX0lQX05GX01BVENIX0FERFJUWVBFPW0KQ09ORklHX0lQX05GX01B
VENIX0FIPW0KQ09ORklHX0lQX05GX01BVENIX0VDTj1tCkNPTkZJR19JUF9ORl9NQVRDSF9UVEw9
bQpDT05GSUdfSVBfTkZfRklMVEVSPW0KQ09ORklHX0lQX05GX1RBUkdFVF9SRUpFQ1Q9bQpDT05G
SUdfSVBfTkZfVEFSR0VUX0xPRz1tCkNPTkZJR19JUF9ORl9UQVJHRVRfVUxPRz1tCkNPTkZJR19J
UF9ORl9NQU5HTEU9bQpDT05GSUdfSVBfTkZfVEFSR0VUX0VDTj1tCkNPTkZJR19JUF9ORl9UQVJH
RVRfVFRMPW0KQ09ORklHX0lQX05GX1JBVz1tCiMgQ09ORklHX0lQX05GX1NFQ1VSSVRZIGlzIG5v
dCBzZXQKQ09ORklHX0lQX05GX0FSUFRBQkxFUz1tCkNPTkZJR19JUF9ORl9BUlBGSUxURVI9bQpD
T05GSUdfSVBfTkZfQVJQX01BTkdMRT1tCgojCiMgSVB2NjogTmV0ZmlsdGVyIENvbmZpZ3VyYXRp
b24KIwpDT05GSUdfSVA2X05GX1FVRVVFPW0KQ09ORklHX0lQNl9ORl9JUFRBQkxFUz1tCkNPTkZJ
R19JUDZfTkZfTUFUQ0hfQUg9bQpDT05GSUdfSVA2X05GX01BVENIX0VVSTY0PW0KQ09ORklHX0lQ
Nl9ORl9NQVRDSF9GUkFHPW0KQ09ORklHX0lQNl9ORl9NQVRDSF9PUFRTPW0KQ09ORklHX0lQNl9O
Rl9NQVRDSF9ITD1tCkNPTkZJR19JUDZfTkZfTUFUQ0hfSVBWNkhFQURFUj1tCiMgQ09ORklHX0lQ
Nl9ORl9NQVRDSF9NSCBpcyBub3Qgc2V0CkNPTkZJR19JUDZfTkZfTUFUQ0hfUlQ9bQpDT05GSUdf
SVA2X05GX1RBUkdFVF9ITD1tCkNPTkZJR19JUDZfTkZfVEFSR0VUX0xPRz1tCkNPTkZJR19JUDZf
TkZfRklMVEVSPW0KQ09ORklHX0lQNl9ORl9UQVJHRVRfUkVKRUNUPW0KQ09ORklHX0lQNl9ORl9N
QU5HTEU9bQpDT05GSUdfSVA2X05GX1JBVz1tCiMgQ09ORklHX0lQNl9ORl9TRUNVUklUWSBpcyBu
b3Qgc2V0CkNPTkZJR19CUklER0VfTkZfRUJUQUJMRVM9bQpDT05GSUdfQlJJREdFX0VCVF9CUk9V
VEU9bQpDT05GSUdfQlJJREdFX0VCVF9UX0ZJTFRFUj1tCkNPTkZJR19CUklER0VfRUJUX1RfTkFU
PW0KQ09ORklHX0JSSURHRV9FQlRfODAyXzM9bQpDT05GSUdfQlJJREdFX0VCVF9BTU9ORz1tCkNP
TkZJR19CUklER0VfRUJUX0FSUD1tCkNPTkZJR19CUklER0VfRUJUX0lQPW0KIyBDT05GSUdfQlJJ
REdFX0VCVF9JUDYgaXMgbm90IHNldApDT05GSUdfQlJJREdFX0VCVF9MSU1JVD1tCkNPTkZJR19C
UklER0VfRUJUX01BUks9bQpDT05GSUdfQlJJREdFX0VCVF9QS1RUWVBFPW0KQ09ORklHX0JSSURH
RV9FQlRfU1RQPW0KQ09ORklHX0JSSURHRV9FQlRfVkxBTj1tCkNPTkZJR19CUklER0VfRUJUX0FS
UFJFUExZPW0KQ09ORklHX0JSSURHRV9FQlRfRE5BVD1tCkNPTkZJR19CUklER0VfRUJUX01BUktf
VD1tCkNPTkZJR19CUklER0VfRUJUX1JFRElSRUNUPW0KQ09ORklHX0JSSURHRV9FQlRfU05BVD1t
CkNPTkZJR19CUklER0VfRUJUX0xPRz1tCkNPTkZJR19CUklER0VfRUJUX1VMT0c9bQojIENPTkZJ
R19CUklER0VfRUJUX05GTE9HIGlzIG5vdCBzZXQKQ09ORklHX0lQX0RDQ1A9bQpDT05GSUdfSU5F
VF9EQ0NQX0RJQUc9bQoKIwojIERDQ1AgQ0NJRHMgQ29uZmlndXJhdGlvbiAoRVhQRVJJTUVOVEFM
KQojCiMgQ09ORklHX0lQX0RDQ1BfQ0NJRDJfREVCVUcgaXMgbm90IHNldApDT05GSUdfSVBfREND
UF9DQ0lEMz15CiMgQ09ORklHX0lQX0RDQ1BfQ0NJRDNfREVCVUcgaXMgbm90IHNldApDT05GSUdf
SVBfRENDUF9DQ0lEM19SVE89MTAwCkNPTkZJR19JUF9EQ0NQX1RGUkNfTElCPXkKCiMKIyBEQ0NQ
IEtlcm5lbCBIYWNraW5nCiMKIyBDT05GSUdfSVBfRENDUF9ERUJVRyBpcyBub3Qgc2V0CiMgQ09O
RklHX05FVF9EQ0NQUFJPQkUgaXMgbm90IHNldApDT05GSUdfSVBfU0NUUD1tCiMgQ09ORklHX1ND
VFBfREJHX01TRyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDVFBfREJHX09CSkNOVCBpcyBub3Qgc2V0
CiMgQ09ORklHX1NDVFBfSE1BQ19OT05FIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NUUF9ITUFDX1NI
QTEgaXMgbm90IHNldApDT05GSUdfU0NUUF9ITUFDX01ENT15CiMgQ09ORklHX1JEUyBpcyBub3Qg
c2V0CkNPTkZJR19USVBDPW0KIyBDT05GSUdfVElQQ19BRFZBTkNFRCBpcyBub3Qgc2V0CiMgQ09O
RklHX1RJUENfREVCVUcgaXMgbm90IHNldApDT05GSUdfQVRNPW0KQ09ORklHX0FUTV9DTElQPW0K
IyBDT05GSUdfQVRNX0NMSVBfTk9fSUNNUCBpcyBub3Qgc2V0CkNPTkZJR19BVE1fTEFORT1tCiMg
Q09ORklHX0FUTV9NUE9BIGlzIG5vdCBzZXQKQ09ORklHX0FUTV9CUjI2ODQ9bQojIENPTkZJR19B
VE1fQlIyNjg0X0lQRklMVEVSIGlzIG5vdCBzZXQKQ09ORklHX1NUUD1tCkNPTkZJR19CUklER0U9
bQojIENPTkZJR19ORVRfRFNBIGlzIG5vdCBzZXQKQ09ORklHX1ZMQU5fODAyMVE9bQojIENPTkZJ
R19WTEFOXzgwMjFRX0dWUlAgaXMgbm90IHNldAojIENPTkZJR19ERUNORVQgaXMgbm90IHNldApD
T05GSUdfTExDPXkKIyBDT05GSUdfTExDMiBpcyBub3Qgc2V0CiMgQ09ORklHX0lQWCBpcyBub3Qg
c2V0CiMgQ09ORklHX0FUQUxLIGlzIG5vdCBzZXQKIyBDT05GSUdfWDI1IGlzIG5vdCBzZXQKIyBD
T05GSUdfTEFQQiBpcyBub3Qgc2V0CiMgQ09ORklHX0VDT05FVCBpcyBub3Qgc2V0CiMgQ09ORklH
X1dBTl9ST1VURVIgaXMgbm90IHNldAojIENPTkZJR19QSE9ORVQgaXMgbm90IHNldAojIENPTkZJ
R19JRUVFODAyMTU0IGlzIG5vdCBzZXQKQ09ORklHX05FVF9TQ0hFRD15CgojCiMgUXVldWVpbmcv
U2NoZWR1bGluZwojCkNPTkZJR19ORVRfU0NIX0NCUT1tCkNPTkZJR19ORVRfU0NIX0hUQj1tCkNP
TkZJR19ORVRfU0NIX0hGU0M9bQpDT05GSUdfTkVUX1NDSF9BVE09bQpDT05GSUdfTkVUX1NDSF9Q
UklPPW0KIyBDT05GSUdfTkVUX1NDSF9NVUxUSVEgaXMgbm90IHNldApDT05GSUdfTkVUX1NDSF9S
RUQ9bQpDT05GSUdfTkVUX1NDSF9TRlE9bQpDT05GSUdfTkVUX1NDSF9URVFMPW0KQ09ORklHX05F
VF9TQ0hfVEJGPW0KQ09ORklHX05FVF9TQ0hfR1JFRD1tCkNPTkZJR19ORVRfU0NIX0RTTUFSSz1t
CkNPTkZJR19ORVRfU0NIX05FVEVNPW0KIyBDT05GSUdfTkVUX1NDSF9EUlIgaXMgbm90IHNldApD
T05GSUdfTkVUX1NDSF9JTkdSRVNTPW0KCiMKIyBDbGFzc2lmaWNhdGlvbgojCkNPTkZJR19ORVRf
Q0xTPXkKQ09ORklHX05FVF9DTFNfQkFTSUM9bQpDT05GSUdfTkVUX0NMU19UQ0lOREVYPW0KQ09O
RklHX05FVF9DTFNfUk9VVEU0PW0KQ09ORklHX05FVF9DTFNfUk9VVEU9eQpDT05GSUdfTkVUX0NM
U19GVz1tCkNPTkZJR19ORVRfQ0xTX1UzMj1tCkNPTkZJR19DTFNfVTMyX1BFUkY9eQpDT05GSUdf
Q0xTX1UzMl9NQVJLPXkKQ09ORklHX05FVF9DTFNfUlNWUD1tCkNPTkZJR19ORVRfQ0xTX1JTVlA2
PW0KIyBDT05GSUdfTkVUX0NMU19GTE9XIGlzIG5vdCBzZXQKQ09ORklHX05FVF9FTUFUQ0g9eQpD
T05GSUdfTkVUX0VNQVRDSF9TVEFDSz0zMgpDT05GSUdfTkVUX0VNQVRDSF9DTVA9bQpDT05GSUdf
TkVUX0VNQVRDSF9OQllURT1tCkNPTkZJR19ORVRfRU1BVENIX1UzMj1tCkNPTkZJR19ORVRfRU1B
VENIX01FVEE9bQpDT05GSUdfTkVUX0VNQVRDSF9URVhUPW0KQ09ORklHX05FVF9DTFNfQUNUPXkK
Q09ORklHX05FVF9BQ1RfUE9MSUNFPW0KQ09ORklHX05FVF9BQ1RfR0FDVD1tCkNPTkZJR19HQUNU
X1BST0I9eQpDT05GSUdfTkVUX0FDVF9NSVJSRUQ9bQpDT05GSUdfTkVUX0FDVF9JUFQ9bQojIENP
TkZJR19ORVRfQUNUX05BVCBpcyBub3Qgc2V0CkNPTkZJR19ORVRfQUNUX1BFRElUPW0KQ09ORklH
X05FVF9BQ1RfU0lNUD1tCiMgQ09ORklHX05FVF9BQ1RfU0tCRURJVCBpcyBub3Qgc2V0CkNPTkZJ
R19ORVRfQ0xTX0lORD15CkNPTkZJR19ORVRfU0NIX0ZJRk89eQojIENPTkZJR19EQ0IgaXMgbm90
IHNldAoKIwojIE5ldHdvcmsgdGVzdGluZwojCkNPTkZJR19ORVRfUEtUR0VOPW0KIyBDT05GSUdf
TkVUX1RDUFBST0JFIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0RST1BfTU9OSVRPUiBpcyBub3Qg
c2V0CiMgQ09ORklHX0hBTVJBRElPIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0FOIGlzIG5vdCBzZXQK
IyBDT05GSUdfSVJEQSBpcyBub3Qgc2V0CkNPTkZJR19CVD1tCkNPTkZJR19CVF9MMkNBUD1tCkNP
TkZJR19CVF9TQ089bQpDT05GSUdfQlRfUkZDT01NPW0KQ09ORklHX0JUX1JGQ09NTV9UVFk9eQpD
T05GSUdfQlRfQk5FUD1tCkNPTkZJR19CVF9CTkVQX01DX0ZJTFRFUj15CkNPTkZJR19CVF9CTkVQ
X1BST1RPX0ZJTFRFUj15CkNPTkZJR19CVF9ISURQPW0KCiMKIyBCbHVldG9vdGggZGV2aWNlIGRy
aXZlcnMKIwojIENPTkZJR19CVF9IQ0lCVFVTQiBpcyBub3Qgc2V0CiMgQ09ORklHX0JUX0hDSUJU
U0RJTyBpcyBub3Qgc2V0CkNPTkZJR19CVF9IQ0lVQVJUPW0KQ09ORklHX0JUX0hDSVVBUlRfSDQ9
eQpDT05GSUdfQlRfSENJVUFSVF9CQ1NQPXkKIyBDT05GSUdfQlRfSENJVUFSVF9MTCBpcyBub3Qg
c2V0CkNPTkZJR19CVF9IQ0lCQ00yMDNYPW0KQ09ORklHX0JUX0hDSUJQQTEwWD1tCkNPTkZJR19C
VF9IQ0lCRlVTQj1tCkNPTkZJR19CVF9IQ0lEVEwxPW0KQ09ORklHX0JUX0hDSUJUM0M9bQpDT05G
SUdfQlRfSENJQkxVRUNBUkQ9bQpDT05GSUdfQlRfSENJQlRVQVJUPW0KQ09ORklHX0JUX0hDSVZI
Q0k9bQojIENPTkZJR19CVF9NUlZMIGlzIG5vdCBzZXQKIyBDT05GSUdfQUZfUlhSUEMgaXMgbm90
IHNldApDT05GSUdfRklCX1JVTEVTPXkKQ09ORklHX1dJUkVMRVNTPXkKQ09ORklHX0NGRzgwMjEx
PW0KIyBDT05GSUdfTkw4MDIxMV9URVNUTU9ERSBpcyBub3Qgc2V0CiMgQ09ORklHX0NGRzgwMjEx
X0RFVkVMT1BFUl9XQVJOSU5HUyBpcyBub3Qgc2V0CiMgQ09ORklHX0NGRzgwMjExX1JFR19ERUJV
RyBpcyBub3Qgc2V0CiMgQ09ORklHX0NGRzgwMjExX0RFRkFVTFRfUFMgaXMgbm90IHNldApDT05G
SUdfQ0ZHODAyMTFfREVGQVVMVF9QU19WQUxVRT0wCiMgQ09ORklHX0NGRzgwMjExX0RFQlVHRlMg
aXMgbm90IHNldAojIENPTkZJR19XSVJFTEVTU19PTERfUkVHVUxBVE9SWSBpcyBub3Qgc2V0CkNP
TkZJR19XSVJFTEVTU19FWFQ9eQpDT05GSUdfV0lSRUxFU1NfRVhUX1NZU0ZTPXkKIyBDT05GSUdf
TElCODAyMTEgaXMgbm90IHNldApDT05GSUdfTUFDODAyMTE9bQpDT05GSUdfTUFDODAyMTFfUkNf
TUlOU1RSRUw9eQojIENPTkZJR19NQUM4MDIxMV9SQ19ERUZBVUxUX1BJRCBpcyBub3Qgc2V0CkNP
TkZJR19NQUM4MDIxMV9SQ19ERUZBVUxUX01JTlNUUkVMPXkKQ09ORklHX01BQzgwMjExX1JDX0RF
RkFVTFQ9Im1pbnN0cmVsIgpDT05GSUdfTUFDODAyMTFfTUVTSD15CkNPTkZJR19NQUM4MDIxMV9M
RURTPXkKIyBDT05GSUdfTUFDODAyMTFfREVCVUdGUyBpcyBub3Qgc2V0CiMgQ09ORklHX01BQzgw
MjExX0RFQlVHX01FTlUgaXMgbm90IHNldAojIENPTkZJR19XSU1BWCBpcyBub3Qgc2V0CiMgQ09O
RklHX1JGS0lMTCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF85UCBpcyBub3Qgc2V0CgojCiMgRGV2
aWNlIERyaXZlcnMKIwoKIwojIEdlbmVyaWMgRHJpdmVyIE9wdGlvbnMKIwpDT05GSUdfVUVWRU5U
X0hFTFBFUl9QQVRIPSIvc2Jpbi9ob3RwbHVnIgojIENPTkZJR19ERVZUTVBGUyBpcyBub3Qgc2V0
CkNPTkZJR19TVEFOREFMT05FPXkKQ09ORklHX1BSRVZFTlRfRklSTVdBUkVfQlVJTEQ9eQpDT05G
SUdfRldfTE9BREVSPXkKQ09ORklHX0ZJUk1XQVJFX0lOX0tFUk5FTD15CkNPTkZJR19FWFRSQV9G
SVJNV0FSRT0iIgojIENPTkZJR19ERUJVR19EUklWRVIgaXMgbm90IHNldAojIENPTkZJR19ERUJV
R19ERVZSRVMgaXMgbm90IHNldAojIENPTkZJR19TWVNfSFlQRVJWSVNPUiBpcyBub3Qgc2V0CkNP
TkZJR19DT05ORUNUT1I9eQpDT05GSUdfUFJPQ19FVkVOVFM9eQpDT05GSUdfTVREPW0KIyBDT05G
SUdfTVREX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX1RFU1RTIGlzIG5vdCBzZXQKQ09O
RklHX01URF9DT05DQVQ9bQpDT05GSUdfTVREX1BBUlRJVElPTlM9eQpDT05GSUdfTVREX1JFREJP
T1RfUEFSVFM9bQpDT05GSUdfTVREX1JFREJPT1RfRElSRUNUT1JZX0JMT0NLPS0xCiMgQ09ORklH
X01URF9SRURCT09UX1BBUlRTX1VOQUxMT0NBVEVEIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX1JF
REJPT1RfUEFSVFNfUkVBRE9OTFkgaXMgbm90IHNldAojIENPTkZJR19NVERfQVI3X1BBUlRTIGlz
IG5vdCBzZXQKCiMKIyBVc2VyIE1vZHVsZXMgQW5kIFRyYW5zbGF0aW9uIExheWVycwojCkNPTkZJ
R19NVERfQ0hBUj1tCkNPTkZJR19NVERfQkxLREVWUz1tCkNPTkZJR19NVERfQkxPQ0s9bQpDT05G
SUdfTVREX0JMT0NLX1JPPW0KQ09ORklHX0ZUTD1tCkNPTkZJR19ORlRMPW0KQ09ORklHX05GVExf
Ulc9eQojIENPTkZJR19JTkZUTCBpcyBub3Qgc2V0CkNPTkZJR19SRkRfRlRMPW0KIyBDT05GSUdf
U1NGREMgaXMgbm90IHNldAojIENPTkZJR19NVERfT09QUyBpcyBub3Qgc2V0CgojCiMgUkFNL1JP
TS9GbGFzaCBjaGlwIGRyaXZlcnMKIwpDT05GSUdfTVREX0NGST1tCkNPTkZJR19NVERfSkVERUNQ
Uk9CRT1tCkNPTkZJR19NVERfR0VOX1BST0JFPW0KIyBDT05GSUdfTVREX0NGSV9BRFZfT1BUSU9O
UyBpcyBub3Qgc2V0CkNPTkZJR19NVERfTUFQX0JBTktfV0lEVEhfMT15CkNPTkZJR19NVERfTUFQ
X0JBTktfV0lEVEhfMj15CkNPTkZJR19NVERfTUFQX0JBTktfV0lEVEhfND15CiMgQ09ORklHX01U
RF9NQVBfQkFOS19XSURUSF84IGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX01BUF9CQU5LX1dJRFRI
XzE2IGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX01BUF9CQU5LX1dJRFRIXzMyIGlzIG5vdCBzZXQK
Q09ORklHX01URF9DRklfSTE9eQpDT05GSUdfTVREX0NGSV9JMj15CiMgQ09ORklHX01URF9DRklf
STQgaXMgbm90IHNldAojIENPTkZJR19NVERfQ0ZJX0k4IGlzIG5vdCBzZXQKQ09ORklHX01URF9D
RklfSU5URUxFWFQ9bQpDT05GSUdfTVREX0NGSV9BTURTVEQ9bQpDT05GSUdfTVREX0NGSV9TVEFB
PW0KQ09ORklHX01URF9DRklfVVRJTD1tCkNPTkZJR19NVERfUkFNPW0KQ09ORklHX01URF9ST009
bQpDT05GSUdfTVREX0FCU0VOVD1tCgojCiMgTWFwcGluZyBkcml2ZXJzIGZvciBjaGlwIGFjY2Vz
cwojCiMgQ09ORklHX01URF9DT01QTEVYX01BUFBJTkdTIGlzIG5vdCBzZXQKIyBDT05GSUdfTVRE
X1BIWVNNQVAgaXMgbm90IHNldApDT05GSUdfTVREX1NDNTIwQ0RQPW0KQ09ORklHX01URF9ORVRT
QzUyMD1tCkNPTkZJR19NVERfVFM1NTAwPW0KIyBDT05GSUdfTVREX0FNRDc2WFJPTSBpcyBub3Qg
c2V0CiMgQ09ORklHX01URF9JQ0hYUk9NIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX0VTQjJST00g
aXMgbm90IHNldAojIENPTkZJR19NVERfQ0s4MDRYUk9NIGlzIG5vdCBzZXQKQ09ORklHX01URF9T
Q0IyX0ZMQVNIPW0KIyBDT05GSUdfTVREX05FVHRlbCBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9M
NDQwR1ggaXMgbm90IHNldAojIENPTkZJR19NVERfSU5URUxfVlJfTk9SIGlzIG5vdCBzZXQKIyBD
T05GSUdfTVREX1BMQVRSQU0gaXMgbm90IHNldAoKIwojIFNlbGYtY29udGFpbmVkIE1URCBkZXZp
Y2UgZHJpdmVycwojCiMgQ09ORklHX01URF9QTUM1NTEgaXMgbm90IHNldAojIENPTkZJR19NVERf
U0xSQU0gaXMgbm90IHNldAojIENPTkZJR19NVERfUEhSQU0gaXMgbm90IHNldApDT05GSUdfTVRE
X01URFJBTT1tCkNPTkZJR19NVERSQU1fVE9UQUxfU0laRT00MDk2CkNPTkZJR19NVERSQU1fRVJB
U0VfU0laRT0xMjgKQ09ORklHX01URF9CTE9DSzJNVEQ9bQoKIwojIERpc2stT24tQ2hpcCBEZXZp
Y2UgRHJpdmVycwojCiMgQ09ORklHX01URF9ET0MyMDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfTVRE
X0RPQzIwMDEgaXMgbm90IHNldAojIENPTkZJR19NVERfRE9DMjAwMVBMVVMgaXMgbm90IHNldApD
T05GSUdfTVREX05BTkQ9bQojIENPTkZJR19NVERfTkFORF9WRVJJRllfV1JJVEUgaXMgbm90IHNl
dApDT05GSUdfTVREX05BTkRfRUNDX1NNQz15CiMgQ09ORklHX01URF9OQU5EX01VU0VVTV9JRFMg
aXMgbm90IHNldApDT05GSUdfTVREX05BTkRfSURTPW0KQ09ORklHX01URF9OQU5EX0RJU0tPTkNI
SVA9bQojIENPTkZJR19NVERfTkFORF9ESVNLT05DSElQX1BST0JFX0FEVkFOQ0VEIGlzIG5vdCBz
ZXQKQ09ORklHX01URF9OQU5EX0RJU0tPTkNISVBfUFJPQkVfQUREUkVTUz0wCiMgQ09ORklHX01U
RF9OQU5EX0RJU0tPTkNISVBfQkJUV1JJVEUgaXMgbm90IHNldAojIENPTkZJR19NVERfTkFORF9D
QUZFIGlzIG5vdCBzZXQKQ09ORklHX01URF9OQU5EX0NTNTUzWD1tCkNPTkZJR19NVERfTkFORF9O
QU5EU0lNPW0KIyBDT05GSUdfTVREX05BTkRfUExBVEZPUk0gaXMgbm90IHNldAojIENPTkZJR19N
VERfQUxBVURBIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX09ORU5BTkQgaXMgbm90IHNldAoKIwoj
IExQRERSIGZsYXNoIG1lbW9yeSBkcml2ZXJzCiMKIyBDT05GSUdfTVREX0xQRERSIGlzIG5vdCBz
ZXQKCiMKIyBVQkkgLSBVbnNvcnRlZCBibG9jayBpbWFnZXMKIwojIENPTkZJR19NVERfVUJJIGlz
IG5vdCBzZXQKQ09ORklHX1BBUlBPUlQ9eQpDT05GSUdfUEFSUE9SVF9QQz1tCkNPTkZJR19QQVJQ
T1JUX1NFUklBTD1tCiMgQ09ORklHX1BBUlBPUlRfUENfRklGTyBpcyBub3Qgc2V0CiMgQ09ORklH
X1BBUlBPUlRfUENfU1VQRVJJTyBpcyBub3Qgc2V0CkNPTkZJR19QQVJQT1JUX1BDX1BDTUNJQT1t
CiMgQ09ORklHX1BBUlBPUlRfR1NDIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFSUE9SVF9BWDg4Nzk2
IGlzIG5vdCBzZXQKQ09ORklHX1BBUlBPUlRfMTI4ND15CkNPTkZJR19QQVJQT1JUX05PVF9QQz15
CkNPTkZJR19QTlA9eQpDT05GSUdfUE5QX0RFQlVHX01FU1NBR0VTPXkKCiMKIyBQcm90b2NvbHMK
IwpDT05GSUdfUE5QQUNQST15CkNPTkZJR19CTEtfREVWPXkKQ09ORklHX0JMS19ERVZfRkQ9bQpD
T05GSUdfUEFSSURFPW0KCiMKIyBQYXJhbGxlbCBJREUgaGlnaC1sZXZlbCBkcml2ZXJzCiMKQ09O
RklHX1BBUklERV9QRD1tCkNPTkZJR19QQVJJREVfUENEPW0KQ09ORklHX1BBUklERV9QRj1tCkNP
TkZJR19QQVJJREVfUFQ9bQpDT05GSUdfUEFSSURFX1BHPW0KCiMKIyBQYXJhbGxlbCBJREUgcHJv
dG9jb2wgbW9kdWxlcwojCkNPTkZJR19QQVJJREVfQVRFTj1tCkNPTkZJR19QQVJJREVfQlBDSz1t
CkNPTkZJR19QQVJJREVfQlBDSzY9bQpDT05GSUdfUEFSSURFX0NPTU09bQpDT05GSUdfUEFSSURF
X0RTVFI9bQpDT05GSUdfUEFSSURFX0ZJVDI9bQpDT05GSUdfUEFSSURFX0ZJVDM9bQpDT05GSUdf
UEFSSURFX0VQQVQ9bQpDT05GSUdfUEFSSURFX0VQQVRDOD15CkNPTkZJR19QQVJJREVfRVBJQT1t
CkNPTkZJR19QQVJJREVfRlJJUT1tCkNPTkZJR19QQVJJREVfRlJQVz1tCkNPTkZJR19QQVJJREVf
S0JJQz1tCkNPTkZJR19QQVJJREVfS1RUST1tCkNPTkZJR19QQVJJREVfT04yMD1tCkNPTkZJR19Q
QVJJREVfT04yNj1tCkNPTkZJR19CTEtfQ1BRX0RBPW0KQ09ORklHX0JMS19DUFFfQ0lTU19EQT1t
CkNPTkZJR19DSVNTX1NDU0lfVEFQRT15CkNPTkZJR19CTEtfREVWX0RBQzk2MD1tCiMgQ09ORklH
X0JMS19ERVZfVU1FTSBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfQ09XX0NPTU1PTiBpcyBu
b3Qgc2V0CkNPTkZJR19CTEtfREVWX0xPT1A9bQpDT05GSUdfQkxLX0RFVl9DUllQVE9MT09QPW0K
Q09ORklHX0JMS19ERVZfTkJEPW0KQ09ORklHX0JMS19ERVZfU1g4PW0KIyBDT05GSUdfQkxLX0RF
Vl9VQiBpcyBub3Qgc2V0CkNPTkZJR19CTEtfREVWX1JBTT15CkNPTkZJR19CTEtfREVWX1JBTV9D
T1VOVD0xNgpDT05GSUdfQkxLX0RFVl9SQU1fU0laRT0xNjM4NAojIENPTkZJR19CTEtfREVWX1hJ
UCBpcyBub3Qgc2V0CkNPTkZJR19DRFJPTV9QS1RDRFZEPW0KQ09ORklHX0NEUk9NX1BLVENEVkRf
QlVGRkVSUz04CiMgQ09ORklHX0NEUk9NX1BLVENEVkRfV0NBQ0hFIGlzIG5vdCBzZXQKQ09ORklH
X0FUQV9PVkVSX0VUSD1tCiMgQ09ORklHX0JMS19ERVZfSEQgaXMgbm90IHNldApDT05GSUdfTUlT
Q19ERVZJQ0VTPXkKQ09ORklHX0lCTV9BU009bQojIENPTkZJR19QSEFOVE9NIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0dJX0lPQzQgaXMgbm90IHNldAojIENPTkZJR19USUZNX0NPUkUgaXMgbm90IHNl
dAojIENPTkZJR19JQ1M5MzJTNDAxIGlzIG5vdCBzZXQKIyBDT05GSUdfRU5DTE9TVVJFX1NFUlZJ
Q0VTIGlzIG5vdCBzZXQKIyBDT05GSUdfSFBfSUxPIGlzIG5vdCBzZXQKIyBDT05GSUdfREVMTF9M
QVBUT1AgaXMgbm90IHNldAojIENPTkZJR19JU0wyOTAwMyBpcyBub3Qgc2V0CiMgQ09ORklHX0My
UE9SVCBpcyBub3Qgc2V0CgojCiMgRUVQUk9NIHN1cHBvcnQKIwojIENPTkZJR19FRVBST01fQVQy
NCBpcyBub3Qgc2V0CiMgQ09ORklHX0VFUFJPTV9MRUdBQ1kgaXMgbm90IHNldAojIENPTkZJR19F
RVBST01fTUFYNjg3NSBpcyBub3Qgc2V0CiMgQ09ORklHX0VFUFJPTV85M0NYNiBpcyBub3Qgc2V0
CiMgQ09ORklHX0NCNzEwX0NPUkUgaXMgbm90IHNldApDT05GSUdfSEFWRV9JREU9eQpDT05GSUdf
SURFPXkKCiMKIyBQbGVhc2Ugc2VlIERvY3VtZW50YXRpb24vaWRlL2lkZS50eHQgZm9yIGhlbHAv
aW5mbyBvbiBJREUgZHJpdmVzCiMKQ09ORklHX0lERV9YRkVSX01PREU9eQpDT05GSUdfSURFX1RJ
TUlOR1M9eQpDT05GSUdfSURFX0FUQVBJPXkKIyBDT05GSUdfQkxLX0RFVl9JREVfU0FUQSBpcyBu
b3Qgc2V0CkNPTkZJR19JREVfR0Q9eQpDT05GSUdfSURFX0dEX0FUQT15CiMgQ09ORklHX0lERV9H
RF9BVEFQSSBpcyBub3Qgc2V0CkNPTkZJR19CTEtfREVWX0lERUNTPW0KIyBDT05GSUdfQkxLX0RF
Vl9ERUxLSU4gaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl9JREVDRD1tCkNPTkZJR19CTEtfREVW
X0lERUNEX1ZFUkJPU0VfRVJST1JTPXkKQ09ORklHX0JMS19ERVZfSURFVEFQRT1tCkNPTkZJR19C
TEtfREVWX0lERUFDUEk9eQpDT05GSUdfSURFX1RBU0tfSU9DVEw9eQpDT05GSUdfSURFX1BST0Nf
RlM9eQoKIwojIElERSBjaGlwc2V0IHN1cHBvcnQvYnVnZml4ZXMKIwpDT05GSUdfSURFX0dFTkVS
SUM9eQojIENPTkZJR19CTEtfREVWX1BMQVRGT1JNIGlzIG5vdCBzZXQKQ09ORklHX0JMS19ERVZf
Q01ENjQwPXkKQ09ORklHX0JMS19ERVZfQ01ENjQwX0VOSEFOQ0VEPXkKQ09ORklHX0JMS19ERVZf
SURFUE5QPXkKQ09ORklHX0JMS19ERVZfSURFRE1BX1NGRj15CgojCiMgUENJIElERSBjaGlwc2V0
cyBzdXBwb3J0CiMKQ09ORklHX0JMS19ERVZfSURFUENJPXkKQ09ORklHX0lERVBDSV9QQ0lCVVNf
T1JERVI9eQojIENPTkZJR19CTEtfREVWX09GRkJPQVJEIGlzIG5vdCBzZXQKQ09ORklHX0JMS19E
RVZfR0VORVJJQz15CiMgQ09ORklHX0JMS19ERVZfT1BUSTYyMSBpcyBub3Qgc2V0CkNPTkZJR19C
TEtfREVWX1JaMTAwMD15CkNPTkZJR19CTEtfREVWX0lERURNQV9QQ0k9eQpDT05GSUdfQkxLX0RF
Vl9BRUM2MlhYPXkKQ09ORklHX0JMS19ERVZfQUxJMTVYMz15CkNPTkZJR19CTEtfREVWX0FNRDc0
WFg9eQpDT05GSUdfQkxLX0RFVl9BVElJWFA9eQpDT05GSUdfQkxLX0RFVl9DTUQ2NFg9eQpDT05G
SUdfQkxLX0RFVl9UUklGTEVYPXkKQ09ORklHX0JMS19ERVZfQ1M1NTIwPXkKQ09ORklHX0JMS19E
RVZfQ1M1NTMwPXkKQ09ORklHX0JMS19ERVZfQ1M1NTM1PXkKIyBDT05GSUdfQkxLX0RFVl9DUzU1
MzYgaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl9IUFQzNjY9eQojIENPTkZJR19CTEtfREVWX0pN
SUNST04gaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX1NDMTIwMCBpcyBub3Qgc2V0CkNPTkZJ
R19CTEtfREVWX1BJSVg9eQojIENPTkZJR19CTEtfREVWX0lUODE3MiBpcyBub3Qgc2V0CiMgQ09O
RklHX0JMS19ERVZfSVQ4MjEzIGlzIG5vdCBzZXQKQ09ORklHX0JMS19ERVZfSVQ4MjFYPXkKIyBD
T05GSUdfQkxLX0RFVl9OUzg3NDE1IGlzIG5vdCBzZXQKQ09ORklHX0JMS19ERVZfUERDMjAyWFhf
T0xEPXkKQ09ORklHX0JMS19ERVZfUERDMjAyWFhfTkVXPXkKQ09ORklHX0JMS19ERVZfU1ZXS1M9
eQpDT05GSUdfQkxLX0RFVl9TSUlNQUdFPXkKQ09ORklHX0JMS19ERVZfU0lTNTUxMz15CiMgQ09O
RklHX0JMS19ERVZfU0xDOTBFNjYgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX1RSTTI5MCBp
cyBub3Qgc2V0CkNPTkZJR19CTEtfREVWX1ZJQTgyQ1hYWD15CiMgQ09ORklHX0JMS19ERVZfVEM4
NkMwMDEgaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl9JREVETUE9eQoKIwojIFNDU0kgZGV2aWNl
IHN1cHBvcnQKIwpDT05GSUdfUkFJRF9BVFRSUz15CkNPTkZJR19TQ1NJPXkKQ09ORklHX1NDU0lf
RE1BPXkKQ09ORklHX1NDU0lfVEdUPXkKQ09ORklHX1NDU0lfTkVUTElOSz15CkNPTkZJR19TQ1NJ
X1BST0NfRlM9eQoKIwojIFNDU0kgc3VwcG9ydCB0eXBlIChkaXNrLCB0YXBlLCBDRC1ST00pCiMK
Q09ORklHX0JMS19ERVZfU0Q9eQpDT05GSUdfQ0hSX0RFVl9TVD15CkNPTkZJR19DSFJfREVWX09T
U1Q9eQpDT05GSUdfQkxLX0RFVl9TUj15CkNPTkZJR19CTEtfREVWX1NSX1ZFTkRPUj15CkNPTkZJ
R19DSFJfREVWX1NHPXkKQ09ORklHX0NIUl9ERVZfU0NIPXkKQ09ORklHX1NDU0lfTVVMVElfTFVO
PXkKQ09ORklHX1NDU0lfQ09OU1RBTlRTPXkKQ09ORklHX1NDU0lfTE9HR0lORz15CkNPTkZJR19T
Q1NJX1NDQU5fQVNZTkM9eQpDT05GSUdfU0NTSV9XQUlUX1NDQU49bQoKIwojIFNDU0kgVHJhbnNw
b3J0cwojCkNPTkZJR19TQ1NJX1NQSV9BVFRSUz1tCkNPTkZJR19TQ1NJX0ZDX0FUVFJTPW0KIyBD
T05GSUdfU0NTSV9GQ19UR1RfQVRUUlMgaXMgbm90IHNldApDT05GSUdfU0NTSV9JU0NTSV9BVFRS
Uz1tCkNPTkZJR19TQ1NJX1NBU19BVFRSUz1tCkNPTkZJR19TQ1NJX1NBU19MSUJTQVM9bQojIENP
TkZJR19TQ1NJX1NBU19BVEEgaXMgbm90IHNldApDT05GSUdfU0NTSV9TQVNfSE9TVF9TTVA9eQoj
IENPTkZJR19TQ1NJX1NBU19MSUJTQVNfREVCVUcgaXMgbm90IHNldApDT05GSUdfU0NTSV9TUlBf
QVRUUlM9bQojIENPTkZJR19TQ1NJX1NSUF9UR1RfQVRUUlMgaXMgbm90IHNldApDT05GSUdfU0NT
SV9MT1dMRVZFTD15CkNPTkZJR19JU0NTSV9UQ1A9bQojIENPTkZJR19TQ1NJX0NYR0IzX0lTQ1NJ
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9CTlgyX0lTQ1NJIGlzIG5vdCBzZXQKIyBDT05GSUdf
QkUySVNDU0kgaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl8zV19YWFhYX1JBSUQ9bQpDT05GSUdf
U0NTSV8zV185WFhYPW0KQ09ORklHX1NDU0lfQUNBUkQ9bQpDT05GSUdfU0NTSV9BQUNSQUlEPW0K
Q09ORklHX1NDU0lfQUlDN1hYWD1tCkNPTkZJR19BSUM3WFhYX0NNRFNfUEVSX0RFVklDRT00CkNP
TkZJR19BSUM3WFhYX1JFU0VUX0RFTEFZX01TPTE1MDAwCiMgQ09ORklHX0FJQzdYWFhfREVCVUdf
RU5BQkxFIGlzIG5vdCBzZXQKQ09ORklHX0FJQzdYWFhfREVCVUdfTUFTSz0wCiMgQ09ORklHX0FJ
QzdYWFhfUkVHX1BSRVRUWV9QUklOVCBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJX0FJQzdYWFhfT0xE
PW0KQ09ORklHX1NDU0lfQUlDNzlYWD1tCkNPTkZJR19BSUM3OVhYX0NNRFNfUEVSX0RFVklDRT00
CkNPTkZJR19BSUM3OVhYX1JFU0VUX0RFTEFZX01TPTE1MDAwCiMgQ09ORklHX0FJQzc5WFhfREVC
VUdfRU5BQkxFIGlzIG5vdCBzZXQKQ09ORklHX0FJQzc5WFhfREVCVUdfTUFTSz0wCiMgQ09ORklH
X0FJQzc5WFhfUkVHX1BSRVRUWV9QUklOVCBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJX0FJQzk0WFg9
bQojIENPTkZJR19BSUM5NFhYX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9NVlNBUyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfRFBUX0kyTyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lf
QURWQU5TWVMgaXMgbm90IHNldApDT05GSUdfU0NTSV9BUkNNU1I9bQojIENPTkZJR19TQ1NJX0FS
Q01TUl9BRVIgaXMgbm90IHNldApDT05GSUdfTUVHQVJBSURfTkVXR0VOPXkKQ09ORklHX01FR0FS
QUlEX01NPW0KQ09ORklHX01FR0FSQUlEX01BSUxCT1g9bQpDT05GSUdfTUVHQVJBSURfTEVHQUNZ
PW0KQ09ORklHX01FR0FSQUlEX1NBUz1tCiMgQ09ORklHX1NDU0lfTVBUMlNBUyBpcyBub3Qgc2V0
CkNPTkZJR19TQ1NJX0hQVElPUD1tCiMgQ09ORklHX1NDU0lfQlVTTE9HSUMgaXMgbm90IHNldAoj
IENPTkZJR19MSUJGQyBpcyBub3Qgc2V0CiMgQ09ORklHX0xJQkZDT0UgaXMgbm90IHNldAojIENP
TkZJR19GQ09FIGlzIG5vdCBzZXQKIyBDT05GSUdfRkNPRV9GTklDIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0NTSV9ETVgzMTkxRCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfRUFUQSBpcyBub3Qgc2V0
CiMgQ09ORklHX1NDU0lfRlVUVVJFX0RPTUFJTiBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJX0dEVEg9
bQpDT05GSUdfU0NTSV9JUFM9bQpDT05GSUdfU0NTSV9JTklUSU89bQojIENPTkZJR19TQ1NJX0lO
SUExMDAgaXMgbm90IHNldApDT05GSUdfU0NTSV9QUEE9bQpDT05GSUdfU0NTSV9JTU09bQojIENP
TkZJR19TQ1NJX0laSVBfRVBQMTYgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0laSVBfU0xPV19D
VFIgaXMgbm90IHNldApDT05GSUdfU0NTSV9TVEVYPW0KQ09ORklHX1NDU0lfU1lNNTNDOFhYXzI9
bQpDT05GSUdfU0NTSV9TWU01M0M4WFhfRE1BX0FERFJFU1NJTkdfTU9ERT0xCkNPTkZJR19TQ1NJ
X1NZTTUzQzhYWF9ERUZBVUxUX1RBR1M9MTYKQ09ORklHX1NDU0lfU1lNNTNDOFhYX01BWF9UQUdT
PTY0CkNPTkZJR19TQ1NJX1NZTTUzQzhYWF9NTUlPPXkKIyBDT05GSUdfU0NTSV9JUFIgaXMgbm90
IHNldApDT05GSUdfU0NTSV9RTE9HSUNfMTI4MD1tCkNPTkZJR19TQ1NJX1FMQV9GQz1tCkNPTkZJ
R19TQ1NJX1FMQV9JU0NTST1tCkNPTkZJR19TQ1NJX0xQRkM9bQojIENPTkZJR19TQ1NJX0xQRkNf
REVCVUdfRlMgaXMgbm90IHNldApDT05GSUdfU0NTSV9EQzM5NXg9bQojIENPTkZJR19TQ1NJX0RD
MzkwVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfTlNQMzIgaXMgbm90IHNldAojIENPTkZJR19T
Q1NJX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9QTUNSQUlEIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0NTSV9TUlAgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0JGQV9GQyBpcyBub3Qgc2V0
CiMgQ09ORklHX1NDU0lfTE9XTEVWRUxfUENNQ0lBIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9E
SCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfT1NEX0lOSVRJQVRPUiBpcyBub3Qgc2V0CkNPTkZJ
R19BVEE9eQojIENPTkZJR19BVEFfTk9OU1RBTkRBUkQgaXMgbm90IHNldApDT05GSUdfQVRBX1ZF
UkJPU0VfRVJST1I9eQpDT05GSUdfQVRBX0FDUEk9eQpDT05GSUdfU0FUQV9QTVA9eQpDT05GSUdf
U0FUQV9BSENJPXkKQ09ORklHX1NBVEFfU0lMMjQ9eQpDT05GSUdfQVRBX1NGRj15CkNPTkZJR19T
QVRBX1NWVz1tCkNPTkZJR19BVEFfUElJWD1tCkNPTkZJR19TQVRBX01WPW0KQ09ORklHX1NBVEFf
TlY9bQpDT05GSUdfUERDX0FETUE9bQpDT05GSUdfU0FUQV9RU1RPUj1tCkNPTkZJR19TQVRBX1BS
T01JU0U9bQpDT05GSUdfU0FUQV9TWDQ9bQpDT05GSUdfU0FUQV9TSUw9bQpDT05GSUdfU0FUQV9T
SVM9bQpDT05GSUdfU0FUQV9VTEk9bQpDT05GSUdfU0FUQV9WSUE9bQpDT05GSUdfU0FUQV9WSVRF
U1NFPW0KQ09ORklHX1NBVEFfSU5JQzE2Mlg9bQpDT05GSUdfUEFUQV9BQ1BJPW0KIyBDT05GSUdf
UEFUQV9BTEkgaXMgbm90IHNldApDT05GSUdfUEFUQV9BTUQ9eQojIENPTkZJR19QQVRBX0FSVE9Q
IGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9BVFA4NjdYIGlzIG5vdCBzZXQKQ09ORklHX1BBVEFf
QVRJSVhQPXkKIyBDT05GSUdfUEFUQV9DTUQ2NDBfUENJIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFU
QV9DTUQ2NFggaXMgbm90IHNldAojIENPTkZJR19QQVRBX0NTNTUyMCBpcyBub3Qgc2V0CiMgQ09O
RklHX1BBVEFfQ1M1NTMwIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9DUzU1MzUgaXMgbm90IHNl
dAojIENPTkZJR19QQVRBX0NTNTUzNiBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfQ1lQUkVTUyBp
cyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfRUZBUiBpcyBub3Qgc2V0CkNPTkZJR19BVEFfR0VORVJJ
Qz15CiMgQ09ORklHX1BBVEFfSFBUMzY2IGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9IUFQzN1gg
aXMgbm90IHNldAojIENPTkZJR19QQVRBX0hQVDNYMk4gaXMgbm90IHNldAojIENPTkZJR19QQVRB
X0hQVDNYMyBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfSVQ4MjFYIGlzIG5vdCBzZXQKIyBDT05G
SUdfUEFUQV9JVDgyMTMgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0pNSUNST04gaXMgbm90IHNl
dAojIENPTkZJR19QQVRBX1RSSUZMRVggaXMgbm90IHNldApDT05GSUdfUEFUQV9NQVJWRUxMPXkK
Q09ORklHX1BBVEFfTVBJSVg9eQpDT05GSUdfUEFUQV9PTERQSUlYPXkKIyBDT05GSUdfUEFUQV9O
RVRDRUxMIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9OSU5KQTMyIGlzIG5vdCBzZXQKIyBDT05G
SUdfUEFUQV9OUzg3NDEwIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9OUzg3NDE1IGlzIG5vdCBz
ZXQKIyBDT05GSUdfUEFUQV9PUFRJIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9PUFRJRE1BIGlz
IG5vdCBzZXQKIyBDT05GSUdfUEFUQV9QQ01DSUEgaXMgbm90IHNldAojIENPTkZJR19QQVRBX1BE
Q19PTEQgaXMgbm90IHNldAojIENPTkZJR19QQVRBX1JBRElTWVMgaXMgbm90IHNldAojIENPTkZJ
R19QQVRBX1JEQyBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfUloxMDAwIGlzIG5vdCBzZXQKIyBD
T05GSUdfUEFUQV9TQzEyMDAgaXMgbm90IHNldAojIENPTkZJR19QQVRBX1NFUlZFUldPUktTIGlz
IG5vdCBzZXQKIyBDT05GSUdfUEFUQV9QREMyMDI3WCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFf
U0lMNjgwIGlzIG5vdCBzZXQKQ09ORklHX1BBVEFfU0lTPW0KIyBDT05GSUdfUEFUQV9WSUEgaXMg
bm90IHNldAojIENPTkZJR19QQVRBX1dJTkJPTkQgaXMgbm90IHNldApDT05GSUdfUEFUQV9TQ0g9
bQpDT05GSUdfTUQ9eQpDT05GSUdfQkxLX0RFVl9NRD15CkNPTkZJR19NRF9BVVRPREVURUNUPXkK
Q09ORklHX01EX0xJTkVBUj1tCkNPTkZJR19NRF9SQUlEMD1tCkNPTkZJR19NRF9SQUlEMT1tCkNP
TkZJR19NRF9SQUlEMTA9bQpDT05GSUdfTURfUkFJRDQ1Nj1tCiMgQ09ORklHX01VTFRJQ09SRV9S
QUlENDU2IGlzIG5vdCBzZXQKQ09ORklHX01EX1JBSUQ2X1BRPW0KIyBDT05GSUdfQVNZTkNfUkFJ
RDZfVEVTVCBpcyBub3Qgc2V0CkNPTkZJR19NRF9NVUxUSVBBVEg9bQpDT05GSUdfTURfRkFVTFRZ
PW0KQ09ORklHX0JMS19ERVZfRE09bQojIENPTkZJR19ETV9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJ
R19ETV9DUllQVD1tCkNPTkZJR19ETV9TTkFQU0hPVD1tCkNPTkZJR19ETV9NSVJST1I9bQojIENP
TkZJR19ETV9MT0dfVVNFUlNQQUNFIGlzIG5vdCBzZXQKQ09ORklHX0RNX1pFUk89bQpDT05GSUdf
RE1fTVVMVElQQVRIPW0KIyBDT05GSUdfRE1fTVVMVElQQVRIX1FMIGlzIG5vdCBzZXQKIyBDT05G
SUdfRE1fTVVMVElQQVRIX1NUIGlzIG5vdCBzZXQKIyBDT05GSUdfRE1fREVMQVkgaXMgbm90IHNl
dAojIENPTkZJR19ETV9VRVZFTlQgaXMgbm90IHNldApDT05GSUdfRlVTSU9OPXkKQ09ORklHX0ZV
U0lPTl9TUEk9bQpDT05GSUdfRlVTSU9OX0ZDPW0KQ09ORklHX0ZVU0lPTl9TQVM9bQpDT05GSUdf
RlVTSU9OX01BWF9TR0U9NDAKQ09ORklHX0ZVU0lPTl9DVEw9bQpDT05GSUdfRlVTSU9OX0xBTj1t
CiMgQ09ORklHX0ZVU0lPTl9MT0dHSU5HIGlzIG5vdCBzZXQKCiMKIyBJRUVFIDEzOTQgKEZpcmVX
aXJlKSBzdXBwb3J0CiMKCiMKIyBZb3UgY2FuIGVuYWJsZSBvbmUgb3IgYm90aCBGaXJlV2lyZSBk
cml2ZXIgc3RhY2tzLgojCgojCiMgU2VlIHRoZSBoZWxwIHRleHRzIGZvciBtb3JlIGluZm9ybWF0
aW9uLgojCkNPTkZJR19GSVJFV0lSRT1tCkNPTkZJR19GSVJFV0lSRV9PSENJPW0KQ09ORklHX0ZJ
UkVXSVJFX09IQ0lfREVCVUc9eQpDT05GSUdfRklSRVdJUkVfU0JQMj1tCiMgQ09ORklHX0ZJUkVX
SVJFX05FVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lFRUUxMzk0IGlzIG5vdCBzZXQKQ09ORklHX0ky
Tz1tCiMgQ09ORklHX0kyT19MQ1RfTk9USUZZX09OX0NIQU5HRVMgaXMgbm90IHNldApDT05GSUdf
STJPX0VYVF9BREFQVEVDPXkKQ09ORklHX0kyT19DT05GSUc9bQpDT05GSUdfSTJPX0NPTkZJR19P
TERfSU9DVEw9eQpDT05GSUdfSTJPX0JVUz1tCkNPTkZJR19JMk9fQkxPQ0s9bQpDT05GSUdfSTJP
X1NDU0k9bQpDT05GSUdfSTJPX1BST0M9bQojIENPTkZJR19NQUNJTlRPU0hfRFJJVkVSUyBpcyBu
b3Qgc2V0CkNPTkZJR19ORVRERVZJQ0VTPXkKQ09ORklHX0lGQj1tCkNPTkZJR19EVU1NWT1tCkNP
TkZJR19CT05ESU5HPW0KIyBDT05GSUdfTUFDVkxBTiBpcyBub3Qgc2V0CiMgQ09ORklHX0VRVUFM
SVpFUiBpcyBub3Qgc2V0CkNPTkZJR19UVU49bQojIENPTkZJR19WRVRIIGlzIG5vdCBzZXQKIyBD
T05GSUdfTkVUX1NCMTAwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ05FVCBpcyBub3Qgc2V0CkNP
TkZJR19QSFlMSUI9bQoKIwojIE1JSSBQSFkgZGV2aWNlIGRyaXZlcnMKIwpDT05GSUdfTUFSVkVM
TF9QSFk9bQpDT05GSUdfREFWSUNPTV9QSFk9bQpDT05GSUdfUVNFTUlfUEhZPW0KQ09ORklHX0xY
VF9QSFk9bQpDT05GSUdfQ0lDQURBX1BIWT1tCkNPTkZJR19WSVRFU1NFX1BIWT1tCkNPTkZJR19T
TVNDX1BIWT1tCiMgQ09ORklHX0JST0FEQ09NX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX0lDUExV
U19QSFkgaXMgbm90IHNldAojIENPTkZJR19SRUFMVEVLX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklH
X05BVElPTkFMX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX1NURTEwWFAgaXMgbm90IHNldAojIENP
TkZJR19MU0lfRVQxMDExQ19QSFkgaXMgbm90IHNldAojIENPTkZJR19NRElPX0JJVEJBTkcgaXMg
bm90IHNldApDT05GSUdfTkVUX0VUSEVSTkVUPXkKQ09ORklHX01JST1tCkNPTkZJR19IQVBQWU1F
QUw9bQpDT05GSUdfU1VOR0VNPW0KQ09ORklHX0NBU1NJTkk9bQpDT05GSUdfTkVUX1ZFTkRPUl8z
Q09NPXkKQ09ORklHX1ZPUlRFWD1tCkNPTkZJR19UWVBIT09OPW0KIyBDT05GSUdfRVRIT0MgaXMg
bm90IHNldAojIENPTkZJR19ETkVUIGlzIG5vdCBzZXQKQ09ORklHX05FVF9UVUxJUD15CkNPTkZJ
R19ERTIxMDRYPW0KQ09ORklHX0RFMjEwNFhfRFNMPTAKQ09ORklHX1RVTElQPW0KIyBDT05GSUdf
VFVMSVBfTVdJIGlzIG5vdCBzZXQKQ09ORklHX1RVTElQX01NSU89eQojIENPTkZJR19UVUxJUF9O
QVBJIGlzIG5vdCBzZXQKQ09ORklHX0RFNFg1PW0KQ09ORklHX1dJTkJPTkRfODQwPW0KQ09ORklH
X0RNOTEwMj1tCkNPTkZJR19VTEk1MjZYPW0KQ09ORklHX1BDTUNJQV9YSVJDT009bQojIENPTkZJ
R19IUDEwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0lCTV9ORVdfRU1BQ19aTUlJIGlzIG5vdCBzZXQK
IyBDT05GSUdfSUJNX05FV19FTUFDX1JHTUlJIGlzIG5vdCBzZXQKIyBDT05GSUdfSUJNX05FV19F
TUFDX1RBSCBpcyBub3Qgc2V0CiMgQ09ORklHX0lCTV9ORVdfRU1BQ19FTUFDNCBpcyBub3Qgc2V0
CiMgQ09ORklHX0lCTV9ORVdfRU1BQ19OT19GTE9XX0NUUkwgaXMgbm90IHNldAojIENPTkZJR19J
Qk1fTkVXX0VNQUNfTUFMX0NMUl9JQ0lOVFNUQVQgaXMgbm90IHNldAojIENPTkZJR19JQk1fTkVX
X0VNQUNfTUFMX0NPTU1PTl9FUlIgaXMgbm90IHNldApDT05GSUdfTkVUX1BDST15CkNPTkZJR19Q
Q05FVDMyPW0KQ09ORklHX0FNRDgxMTFfRVRIPW0KQ09ORklHX0FEQVBURUNfU1RBUkZJUkU9bQpD
T05GSUdfQjQ0PW0KQ09ORklHX0I0NF9QQ0lfQVVUT1NFTEVDVD15CkNPTkZJR19CNDRfUENJQ09S
RV9BVVRPU0VMRUNUPXkKQ09ORklHX0I0NF9QQ0k9eQpDT05GSUdfRk9SQ0VERVRIPW0KIyBDT05G
SUdfRk9SQ0VERVRIX05BUEkgaXMgbm90IHNldApDT05GSUdfRTEwMD1tCkNPTkZJR19GRUFMTlg9
bQpDT05GSUdfTkFUU0VNST1tCkNPTkZJR19ORTJLX1BDST1tCkNPTkZJR184MTM5Q1A9bQpDT05G
SUdfODEzOVRPTz1tCiMgQ09ORklHXzgxMzlUT09fUElPIGlzIG5vdCBzZXQKIyBDT05GSUdfODEz
OVRPT19UVU5FX1RXSVNURVIgaXMgbm90IHNldApDT05GSUdfODEzOVRPT184MTI5PXkKIyBDT05G
SUdfODEzOV9PTERfUlhfUkVTRVQgaXMgbm90IHNldAojIENPTkZJR19SNjA0MCBpcyBub3Qgc2V0
CkNPTkZJR19TSVM5MDA9bQpDT05GSUdfRVBJQzEwMD1tCiMgQ09ORklHX1NNU0M5NDIwIGlzIG5v
dCBzZXQKIyBDT05GSUdfU1VOREFOQ0UgaXMgbm90IHNldApDT05GSUdfVExBTj1tCiMgQ09ORklH
X0tTODg0MiBpcyBub3Qgc2V0CiMgQ09ORklHX0tTODg1MV9NTEwgaXMgbm90IHNldApDT05GSUdf
VklBX1JISU5FPW0KQ09ORklHX1ZJQV9SSElORV9NTUlPPXkKIyBDT05GSUdfU0M5MjAzMSBpcyBu
b3Qgc2V0CkNPTkZJR19ORVRfUE9DS0VUPXkKIyBDT05GSUdfQVRQIGlzIG5vdCBzZXQKIyBDT05G
SUdfREU2MDAgaXMgbm90IHNldAojIENPTkZJR19ERTYyMCBpcyBub3Qgc2V0CiMgQ09ORklHX0FU
TDIgaXMgbm90IHNldApDT05GSUdfTkVUREVWXzEwMDA9eQpDT05GSUdfQUNFTklDPW0KIyBDT05G
SUdfQUNFTklDX09NSVRfVElHT05fSSBpcyBub3Qgc2V0CkNPTkZJR19ETDJLPW0KQ09ORklHX0Ux
MDAwPW0KQ09ORklHX0UxMDAwRT1tCiMgQ09ORklHX0lQMTAwMCBpcyBub3Qgc2V0CkNPTkZJR19J
R0I9bQojIENPTkZJR19JR0JWRiBpcyBub3Qgc2V0CkNPTkZJR19OUzgzODIwPW0KIyBDT05GSUdf
SEFNQUNISSBpcyBub3Qgc2V0CiMgQ09ORklHX1lFTExPV0ZJTiBpcyBub3Qgc2V0CkNPTkZJR19S
ODE2OT1tCkNPTkZJR19SODE2OV9WTEFOPXkKQ09ORklHX1NJUzE5MD1tCkNPTkZJR19TS0dFPW0K
IyBDT05GSUdfU0tHRV9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19TS1kyPW0KIyBDT05GSUdfU0tZ
Ml9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19WSUFfVkVMT0NJVFk9bQpDT05GSUdfVElHT04zPW0K
Q09ORklHX0JOWDI9bQojIENPTkZJR19DTklDIGlzIG5vdCBzZXQKQ09ORklHX1FMQTNYWFg9bQoj
IENPTkZJR19BVEwxIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRMMUUgaXMgbm90IHNldAojIENPTkZJ
R19BVEwxQyBpcyBub3Qgc2V0CiMgQ09ORklHX0pNRSBpcyBub3Qgc2V0CkNPTkZJR19ORVRERVZf
MTAwMDA9eQpDT05GSUdfTURJTz1tCkNPTkZJR19DSEVMU0lPX1QxPW0KIyBDT05GSUdfQ0hFTFNJ
T19UMV8xRyBpcyBub3Qgc2V0CkNPTkZJR19DSEVMU0lPX1QzX0RFUEVORFM9eQpDT05GSUdfQ0hF
TFNJT19UMz1tCiMgQ09ORklHX0VOSUMgaXMgbm90IHNldAojIENPTkZJR19JWEdCRSBpcyBub3Qg
c2V0CkNPTkZJR19JWEdCPW0KQ09ORklHX1MySU89bQojIENPTkZJR19WWEdFIGlzIG5vdCBzZXQK
Q09ORklHX01ZUkkxMEdFPW0KQ09ORklHX05FVFhFTl9OSUM9bQojIENPTkZJR19OSVUgaXMgbm90
IHNldAojIENPTkZJR19NTFg0X0VOIGlzIG5vdCBzZXQKIyBDT05GSUdfTUxYNF9DT1JFIGlzIG5v
dCBzZXQKIyBDT05GSUdfVEVIVVRJIGlzIG5vdCBzZXQKIyBDT05GSUdfQk5YMlggaXMgbm90IHNl
dAojIENPTkZJR19RTEdFIGlzIG5vdCBzZXQKIyBDT05GSUdfU0ZDIGlzIG5vdCBzZXQKIyBDT05G
SUdfQkUyTkVUIGlzIG5vdCBzZXQKQ09ORklHX1RSPXkKQ09ORklHX0lCTU9MPW0KQ09ORklHX0lC
TUxTPW0KQ09ORklHXzNDMzU5PW0KIyBDT05GSUdfVE1TMzgwVFIgaXMgbm90IHNldApDT05GSUdf
V0xBTj15CiMgQ09ORklHX1dMQU5fUFJFODAyMTEgaXMgbm90IHNldAojIENPTkZJR19XTEFOXzgw
MjExIGlzIG5vdCBzZXQKCiMKIyBFbmFibGUgV2lNQVggKE5ldHdvcmtpbmcgb3B0aW9ucykgdG8g
c2VlIHRoZSBXaU1BWCBkcml2ZXJzCiMKCiMKIyBVU0IgTmV0d29yayBBZGFwdGVycwojCkNPTkZJ
R19VU0JfQ0FUQz1tCkNPTkZJR19VU0JfS0FXRVRIPW0KQ09ORklHX1VTQl9QRUdBU1VTPW0KQ09O
RklHX1VTQl9SVEw4MTUwPW0KQ09ORklHX1VTQl9VU0JORVQ9bQpDT05GSUdfVVNCX05FVF9BWDg4
MTdYPW0KQ09ORklHX1VTQl9ORVRfQ0RDRVRIRVI9bQojIENPTkZJR19VU0JfTkVUX0NEQ19FRU0g
aXMgbm90IHNldAojIENPTkZJR19VU0JfTkVUX0RNOTYwMSBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9ORVRfU01TQzk1WFggaXMgbm90IHNldApDT05GSUdfVVNCX05FVF9HTDYyMEE9bQpDT05GSUdf
VVNCX05FVF9ORVQxMDgwPW0KQ09ORklHX1VTQl9ORVRfUExVU0I9bQojIENPTkZJR19VU0JfTkVU
X01DUzc4MzAgaXMgbm90IHNldApDT05GSUdfVVNCX05FVF9STkRJU19IT1NUPW0KQ09ORklHX1VT
Ql9ORVRfQ0RDX1NVQlNFVD1tCkNPTkZJR19VU0JfQUxJX001NjMyPXkKQ09ORklHX1VTQl9BTjI3
MjA9eQpDT05GSUdfVVNCX0JFTEtJTj15CkNPTkZJR19VU0JfQVJNTElOVVg9eQpDT05GSUdfVVNC
X0VQU09OMjg4OD15CiMgQ09ORklHX1VTQl9LQzIxOTAgaXMgbm90IHNldApDT05GSUdfVVNCX05F
VF9aQVVSVVM9bQojIENPTkZJR19VU0JfTkVUX0lOVDUxWDEgaXMgbm90IHNldApDT05GSUdfTkVU
X1BDTUNJQT15CkNPTkZJR19QQ01DSUFfM0M1ODk9bQpDT05GSUdfUENNQ0lBXzNDNTc0PW0KQ09O
RklHX1BDTUNJQV9GTVZKMThYPW0KQ09ORklHX1BDTUNJQV9QQ05FVD1tCkNPTkZJR19QQ01DSUFf
Tk1DTEFOPW0KQ09ORklHX1BDTUNJQV9TTUM5MUM5Mj1tCkNPTkZJR19QQ01DSUFfWElSQzJQUz1t
CkNPTkZJR19QQ01DSUFfQVhORVQ9bQpDT05GSUdfUENNQ0lBX0lCTVRSPW0KIyBDT05GSUdfV0FO
IGlzIG5vdCBzZXQKQ09ORklHX0FUTV9EUklWRVJTPXkKIyBDT05GSUdfQVRNX0RVTU1ZIGlzIG5v
dCBzZXQKQ09ORklHX0FUTV9UQ1A9bQpDT05GSUdfQVRNX0xBTkFJPW0KQ09ORklHX0FUTV9FTkk9
bQojIENPTkZJR19BVE1fRU5JX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRNX0VOSV9UVU5F
X0JVUlNUIGlzIG5vdCBzZXQKQ09ORklHX0FUTV9GSVJFU1RSRUFNPW0KIyBDT05GSUdfQVRNX1pB
VE0gaXMgbm90IHNldApDT05GSUdfQVRNX05JQ1NUQVI9bQojIENPTkZJR19BVE1fTklDU1RBUl9V
U0VfU1VOSSBpcyBub3Qgc2V0CiMgQ09ORklHX0FUTV9OSUNTVEFSX1VTRV9JRFQ3NzEwNSBpcyBu
b3Qgc2V0CkNPTkZJR19BVE1fSURUNzcyNTI9bQojIENPTkZJR19BVE1fSURUNzcyNTJfREVCVUcg
aXMgbm90IHNldAojIENPTkZJR19BVE1fSURUNzcyNTJfUkNWX0FMTCBpcyBub3Qgc2V0CkNPTkZJ
R19BVE1fSURUNzcyNTJfVVNFX1NVTkk9eQpDT05GSUdfQVRNX0FNQkFTU0FET1I9bQojIENPTkZJ
R19BVE1fQU1CQVNTQURPUl9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19BVE1fSE9SSVpPTj1tCiMg
Q09ORklHX0FUTV9IT1JJWk9OX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRNX0lBIGlzIG5v
dCBzZXQKIyBDT05GSUdfQVRNX0ZPUkUyMDBFIGlzIG5vdCBzZXQKQ09ORklHX0FUTV9IRT1tCiMg
Q09ORklHX0FUTV9IRV9VU0VfU1VOSSBpcyBub3Qgc2V0CiMgQ09ORklHX0FUTV9TT0xPUyBpcyBu
b3Qgc2V0CkNPTkZJR19GRERJPXkKIyBDT05GSUdfREVGWFggaXMgbm90IHNldAojIENPTkZJR19T
S0ZQIGlzIG5vdCBzZXQKIyBDT05GSUdfSElQUEkgaXMgbm90IHNldAojIENPTkZJR19QTElQIGlz
IG5vdCBzZXQKQ09ORklHX1BQUD1tCkNPTkZJR19QUFBfTVVMVElMSU5LPXkKQ09ORklHX1BQUF9G
SUxURVI9eQpDT05GSUdfUFBQX0FTWU5DPW0KQ09ORklHX1BQUF9TWU5DX1RUWT1tCkNPTkZJR19Q
UFBfREVGTEFURT1tCiMgQ09ORklHX1BQUF9CU0RDT01QIGlzIG5vdCBzZXQKQ09ORklHX1BQUF9N
UFBFPW0KQ09ORklHX1BQUE9FPW0KQ09ORklHX1BQUE9BVE09bQojIENPTkZJR19QUFBPTDJUUCBp
cyBub3Qgc2V0CkNPTkZJR19TTElQPW0KQ09ORklHX1NMSVBfQ09NUFJFU1NFRD15CkNPTkZJR19T
TEhDPW0KQ09ORklHX1NMSVBfU01BUlQ9eQojIENPTkZJR19TTElQX01PREVfU0xJUDYgaXMgbm90
IHNldApDT05GSUdfTkVUX0ZDPXkKQ09ORklHX05FVENPTlNPTEU9bQojIENPTkZJR19ORVRDT05T
T0xFX0RZTkFNSUMgaXMgbm90IHNldApDT05GSUdfTkVUUE9MTD15CkNPTkZJR19ORVRQT0xMX1RS
QVA9eQpDT05GSUdfTkVUX1BPTExfQ09OVFJPTExFUj15CiMgQ09ORklHX1ZNWE5FVDMgaXMgbm90
IHNldAojIENPTkZJR19JU0ROIGlzIG5vdCBzZXQKIyBDT05GSUdfUEhPTkUgaXMgbm90IHNldAoK
IwojIElucHV0IGRldmljZSBzdXBwb3J0CiMKQ09ORklHX0lOUFVUPXkKQ09ORklHX0lOUFVUX0ZG
X01FTUxFU1M9eQpDT05GSUdfSU5QVVRfUE9MTERFVj1tCgojCiMgVXNlcmxhbmQgaW50ZXJmYWNl
cwojCkNPTkZJR19JTlBVVF9NT1VTRURFVj15CiMgQ09ORklHX0lOUFVUX01PVVNFREVWX1BTQVVY
IGlzIG5vdCBzZXQKQ09ORklHX0lOUFVUX01PVVNFREVWX1NDUkVFTl9YPTEwMjQKQ09ORklHX0lO
UFVUX01PVVNFREVWX1NDUkVFTl9ZPTc2OApDT05GSUdfSU5QVVRfSk9ZREVWPW0KQ09ORklHX0lO
UFVUX0VWREVWPXkKIyBDT05GSUdfSU5QVVRfRVZCVUcgaXMgbm90IHNldAoKIwojIElucHV0IERl
dmljZSBEcml2ZXJzCiMKQ09ORklHX0lOUFVUX0tFWUJPQVJEPXkKIyBDT05GSUdfS0VZQk9BUkRf
QURQNTU4OCBpcyBub3Qgc2V0CkNPTkZJR19LRVlCT0FSRF9BVEtCRD15CiMgQ09ORklHX1FUMjE2
MCBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX0xLS0JEIGlzIG5vdCBzZXQKIyBDT05GSUdf
S0VZQk9BUkRfTE04MzIzIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfTUFYNzM1OSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX05FV1RPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJP
QVJEX09QRU5DT1JFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX1NUT1dBV0FZIGlzIG5v
dCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfU1VOS0JEIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9B
UkRfWFRLQkQgaXMgbm90IHNldApDT05GSUdfSU5QVVRfTU9VU0U9eQpDT05GSUdfTU9VU0VfUFMy
PXkKQ09ORklHX01PVVNFX1BTMl9BTFBTPXkKQ09ORklHX01PVVNFX1BTMl9MT0dJUFMyUFA9eQpD
T05GSUdfTU9VU0VfUFMyX1NZTkFQVElDUz15CkNPTkZJR19NT1VTRV9QUzJfTElGRUJPT0s9eQpD
T05GSUdfTU9VU0VfUFMyX1RSQUNLUE9JTlQ9eQojIENPTkZJR19NT1VTRV9QUzJfRUxBTlRFQ0gg
aXMgbm90IHNldAojIENPTkZJR19NT1VTRV9QUzJfU0VOVEVMSUMgaXMgbm90IHNldAojIENPTkZJ
R19NT1VTRV9QUzJfVE9VQ0hLSVQgaXMgbm90IHNldApDT05GSUdfTU9VU0VfU0VSSUFMPW0KIyBD
T05GSUdfTU9VU0VfQVBQTEVUT1VDSCBpcyBub3Qgc2V0CiMgQ09ORklHX01PVVNFX0JDTTU5NzQg
aXMgbm90IHNldApDT05GSUdfTU9VU0VfVlNYWFhBQT1tCiMgQ09ORklHX01PVVNFX1NZTkFQVElD
U19JMkMgaXMgbm90IHNldApDT05GSUdfSU5QVVRfSk9ZU1RJQ0s9eQojIENPTkZJR19KT1lTVElD
S19BTkFMT0cgaXMgbm90IHNldAojIENPTkZJR19KT1lTVElDS19BM0QgaXMgbm90IHNldAojIENP
TkZJR19KT1lTVElDS19BREkgaXMgbm90IHNldAojIENPTkZJR19KT1lTVElDS19DT0JSQSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0pPWVNUSUNLX0dGMksgaXMgbm90IHNldAojIENPTkZJR19KT1lTVElD
S19HUklQIGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfR1JJUF9NUCBpcyBub3Qgc2V0CiMg
Q09ORklHX0pPWVNUSUNLX0dVSUxMRU1PVCBpcyBub3Qgc2V0CiMgQ09ORklHX0pPWVNUSUNLX0lO
VEVSQUNUIGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfU0lERVdJTkRFUiBpcyBub3Qgc2V0
CiMgQ09ORklHX0pPWVNUSUNLX1RNREMgaXMgbm90IHNldAojIENPTkZJR19KT1lTVElDS19JRk9S
Q0UgaXMgbm90IHNldAojIENPTkZJR19KT1lTVElDS19XQVJSSU9SIGlzIG5vdCBzZXQKIyBDT05G
SUdfSk9ZU1RJQ0tfTUFHRUxMQU4gaXMgbm90IHNldAojIENPTkZJR19KT1lTVElDS19TUEFDRU9S
QiBpcyBub3Qgc2V0CiMgQ09ORklHX0pPWVNUSUNLX1NQQUNFQkFMTCBpcyBub3Qgc2V0CiMgQ09O
RklHX0pPWVNUSUNLX1NUSU5HRVIgaXMgbm90IHNldApDT05GSUdfSk9ZU1RJQ0tfVFdJREpPWT1t
CiMgQ09ORklHX0pPWVNUSUNLX1pIRU5IVUEgaXMgbm90IHNldAojIENPTkZJR19KT1lTVElDS19E
QjkgaXMgbm90IHNldAojIENPTkZJR19KT1lTVElDS19HQU1FQ09OIGlzIG5vdCBzZXQKIyBDT05G
SUdfSk9ZU1RJQ0tfVFVSQk9HUkFGWCBpcyBub3Qgc2V0CkNPTkZJR19KT1lTVElDS19KT1lEVU1Q
PW0KIyBDT05GSUdfSk9ZU1RJQ0tfWFBBRCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX1RBQkxF
VCBpcyBub3Qgc2V0CkNPTkZJR19JTlBVVF9UT1VDSFNDUkVFTj15CiMgQ09ORklHX1RPVUNIU0NS
RUVOX0FENzg3OV9JMkMgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9BRDc4NzkgaXMg
bm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9FRVRJIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9V
Q0hTQ1JFRU5fRlVKSVRTVSBpcyBub3Qgc2V0CkNPTkZJR19UT1VDSFNDUkVFTl9HVU5aRT1tCkNP
TkZJR19UT1VDSFNDUkVFTl9FTE89bQojIENPTkZJR19UT1VDSFNDUkVFTl9XQUNPTV9XODAwMSBp
cyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX01DUzUwMDAgaXMgbm90IHNldApDT05GSUdf
VE9VQ0hTQ1JFRU5fTVRPVUNIPW0KIyBDT05GSUdfVE9VQ0hTQ1JFRU5fSU5FWElPIGlzIG5vdCBz
ZXQKQ09ORklHX1RPVUNIU0NSRUVOX01LNzEyPW0KIyBDT05GSUdfVE9VQ0hTQ1JFRU5fUEVOTU9V
TlQgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9UT1VDSFJJR0hUIGlzIG5vdCBzZXQK
IyBDT05GSUdfVE9VQ0hTQ1JFRU5fVE9VQ0hXSU4gaXMgbm90IHNldAojIENPTkZJR19UT1VDSFND
UkVFTl9XTTk3WFggaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9VU0JfQ09NUE9TSVRF
IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fVE9VQ0hJVDIxMyBpcyBub3Qgc2V0CiMg
Q09ORklHX1RPVUNIU0NSRUVOX1RTQzIwMDcgaXMgbm90IHNldApDT05GSUdfSU5QVVRfTUlTQz15
CkNPTkZJR19JTlBVVF9QQ1NQS1I9bQojIENPTkZJR19JTlBVVF9BUEFORUwgaXMgbm90IHNldApD
T05GSUdfSU5QVVRfV0lTVFJPTl9CVE5TPW0KIyBDT05GSUdfSU5QVVRfQVRMQVNfQlROUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0lOUFVUX0FUSV9SRU1PVEUgaXMgbm90IHNldAojIENPTkZJR19JTlBV
VF9BVElfUkVNT1RFMiBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0tFWVNQQU5fUkVNT1RFIGlz
IG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfUE9XRVJNQVRFIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5Q
VVRfWUVBTElOSyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0NNMTA5IGlzIG5vdCBzZXQKQ09O
RklHX0lOUFVUX1VJTlBVVD1tCiMgQ09ORklHX0lOUFVUX1dJTkJPTkRfQ0lSIGlzIG5vdCBzZXQK
CiMKIyBIYXJkd2FyZSBJL08gcG9ydHMKIwpDT05GSUdfU0VSSU89eQpDT05GSUdfU0VSSU9fSTgw
NDI9eQpDT05GSUdfU0VSSU9fU0VSUE9SVD15CiMgQ09ORklHX1NFUklPX0NUODJDNzEwIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VSSU9fUEFSS0JEIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSU9fUENJ
UFMyIGlzIG5vdCBzZXQKQ09ORklHX1NFUklPX0xJQlBTMj15CkNPTkZJR19TRVJJT19SQVc9bQpD
T05GSUdfR0FNRVBPUlQ9bQpDT05GSUdfR0FNRVBPUlRfTlM1NTg9bQpDT05GSUdfR0FNRVBPUlRf
TDQ9bQpDT05GSUdfR0FNRVBPUlRfRU1VMTBLMT1tCkNPTkZJR19HQU1FUE9SVF9GTTgwMT1tCgoj
CiMgQ2hhcmFjdGVyIGRldmljZXMKIwpDT05GSUdfVlQ9eQpDT05GSUdfQ09OU09MRV9UUkFOU0xB
VElPTlM9eQpDT05GSUdfVlRfQ09OU09MRT15CkNPTkZJR19IV19DT05TT0xFPXkKQ09ORklHX1ZU
X0hXX0NPTlNPTEVfQklORElORz15CkNPTkZJR19ERVZLTUVNPXkKQ09ORklHX1NFUklBTF9OT05T
VEFOREFSRD15CiMgQ09ORklHX0NPTVBVVE9ORSBpcyBub3Qgc2V0CiMgQ09ORklHX1JPQ0tFVFBP
UlQgaXMgbm90IHNldApDT05GSUdfQ1lDTEFERVM9bQojIENPTkZJR19DWVpfSU5UUiBpcyBub3Qg
c2V0CiMgQ09ORklHX0RJR0lFUENBIGlzIG5vdCBzZXQKIyBDT05GSUdfTU9YQV9JTlRFTExJTyBp
cyBub3Qgc2V0CiMgQ09ORklHX01PWEFfU01BUlRJTyBpcyBub3Qgc2V0CiMgQ09ORklHX0lTSSBp
cyBub3Qgc2V0CkNPTkZJR19TWU5DTElOSz1tCkNPTkZJR19TWU5DTElOS01QPW0KQ09ORklHX1NZ
TkNMSU5LX0dUPW0KQ09ORklHX05fSERMQz1tCiMgQ09ORklHX1JJU0NPTTggaXMgbm90IHNldAoj
IENPTkZJR19TUEVDSUFMSVggaXMgbm90IHNldAojIENPTkZJR19TVEFMRFJWIGlzIG5vdCBzZXQK
IyBDT05GSUdfTk9aT01JIGlzIG5vdCBzZXQKCiMKIyBTZXJpYWwgZHJpdmVycwojCkNPTkZJR19T
RVJJQUxfODI1MD15CkNPTkZJR19TRVJJQUxfODI1MF9DT05TT0xFPXkKQ09ORklHX0ZJWF9FQVJM
WUNPTl9NRU09eQpDT05GSUdfU0VSSUFMXzgyNTBfUENJPXkKQ09ORklHX1NFUklBTF84MjUwX1BO
UD15CkNPTkZJR19TRVJJQUxfODI1MF9DUz1tCkNPTkZJR19TRVJJQUxfODI1MF9OUl9VQVJUUz0z
MgpDT05GSUdfU0VSSUFMXzgyNTBfUlVOVElNRV9VQVJUUz00CkNPTkZJR19TRVJJQUxfODI1MF9F
WFRFTkRFRD15CkNPTkZJR19TRVJJQUxfODI1MF9NQU5ZX1BPUlRTPXkKQ09ORklHX1NFUklBTF84
MjUwX1NIQVJFX0lSUT15CkNPTkZJR19TRVJJQUxfODI1MF9ERVRFQ1RfSVJRPXkKQ09ORklHX1NF
UklBTF84MjUwX1JTQT15CgojCiMgTm9uLTgyNTAgc2VyaWFsIHBvcnQgc3VwcG9ydAojCkNPTkZJ
R19TRVJJQUxfQ09SRT15CkNPTkZJR19TRVJJQUxfQ09SRV9DT05TT0xFPXkKQ09ORklHX1NFUklB
TF9KU009bQpDT05GSUdfVU5JWDk4X1BUWVM9eQojIENPTkZJR19ERVZQVFNfTVVMVElQTEVfSU5T
VEFOQ0VTIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVHQUNZX1BUWVMgaXMgbm90IHNldApDT05GSUdf
UFJJTlRFUj1tCkNPTkZJR19MUF9DT05TT0xFPXkKQ09ORklHX1BQREVWPW0KQ09ORklHX0lQTUlf
SEFORExFUj1tCiMgQ09ORklHX0lQTUlfUEFOSUNfRVZFTlQgaXMgbm90IHNldApDT05GSUdfSVBN
SV9ERVZJQ0VfSU5URVJGQUNFPW0KQ09ORklHX0lQTUlfU0k9bQpDT05GSUdfSVBNSV9XQVRDSERP
Rz1tCkNPTkZJR19JUE1JX1BPV0VST0ZGPW0KQ09ORklHX0hXX1JBTkRPTT15CiMgQ09ORklHX0hX
X1JBTkRPTV9USU1FUklPTUVNIGlzIG5vdCBzZXQKQ09ORklHX0hXX1JBTkRPTV9JTlRFTD1tCkNP
TkZJR19IV19SQU5ET01fQU1EPW0KQ09ORklHX0hXX1JBTkRPTV9HRU9ERT1tCkNPTkZJR19IV19S
QU5ET01fVklBPW0KQ09ORklHX05WUkFNPXkKIyBDT05GSUdfUjM5NjQgaXMgbm90IHNldAojIENP
TkZJR19BUFBMSUNPTSBpcyBub3Qgc2V0CkNPTkZJR19TT05ZUEk9bQoKIwojIFBDTUNJQSBjaGFy
YWN0ZXIgZGV2aWNlcwojCiMgQ09ORklHX1NZTkNMSU5LX0NTIGlzIG5vdCBzZXQKQ09ORklHX0NB
UkRNQU5fNDAwMD1tCkNPTkZJR19DQVJETUFOXzQwNDA9bQojIENPTkZJR19JUFdJUkVMRVNTIGlz
IG5vdCBzZXQKIyBDT05GSUdfTVdBVkUgaXMgbm90IHNldApDT05GSUdfUEM4NzM2eF9HUElPPW0K
Q09ORklHX05TQ19HUElPPW0KQ09ORklHX0NTNTUzNV9HUElPPW0KQ09ORklHX1JBV19EUklWRVI9
eQpDT05GSUdfTUFYX1JBV19ERVZTPTgxOTIKQ09ORklHX0hQRVQ9eQojIENPTkZJR19IUEVUX01N
QVAgaXMgbm90IHNldApDT05GSUdfSEFOR0NIRUNLX1RJTUVSPW0KIyBDT05GSUdfVENHX1RQTSBp
cyBub3Qgc2V0CiMgQ09ORklHX1RFTENMT0NLIGlzIG5vdCBzZXQKQ09ORklHX0RFVlBPUlQ9eQpD
T05GSUdfSTJDPW0KQ09ORklHX0kyQ19CT0FSRElORk89eQpDT05GSUdfSTJDX0NPTVBBVD15CkNP
TkZJR19JMkNfQ0hBUkRFVj1tCkNPTkZJR19JMkNfSEVMUEVSX0FVVE89eQpDT05GSUdfSTJDX0FM
R09CSVQ9bQoKIwojIEkyQyBIYXJkd2FyZSBCdXMgc3VwcG9ydAojCgojCiMgUEMgU01CdXMgaG9z
dCBjb250cm9sbGVyIGRyaXZlcnMKIwpDT05GSUdfSTJDX0FMSTE1MzU9bQpDT05GSUdfSTJDX0FM
STE1NjM9bQpDT05GSUdfSTJDX0FMSTE1WDM9bQpDT05GSUdfSTJDX0FNRDc1Nj1tCkNPTkZJR19J
MkNfQU1ENzU2X1M0ODgyPW0KQ09ORklHX0kyQ19BTUQ4MTExPW0KQ09ORklHX0kyQ19JODAxPW0K
IyBDT05GSUdfSTJDX0lTQ0ggaXMgbm90IHNldApDT05GSUdfSTJDX1BJSVg0PW0KQ09ORklHX0ky
Q19ORk9SQ0UyPW0KIyBDT05GSUdfSTJDX05GT1JDRTJfUzQ5ODUgaXMgbm90IHNldApDT05GSUdf
STJDX1NJUzU1OTU9bQpDT05GSUdfSTJDX1NJUzYzMD1tCkNPTkZJR19JMkNfU0lTOTZYPW0KQ09O
RklHX0kyQ19WSUE9bQpDT05GSUdfSTJDX1ZJQVBSTz1tCgojCiMgQUNQSSBkcml2ZXJzCiMKIyBD
T05GSUdfSTJDX1NDTUkgaXMgbm90IHNldAoKIwojIEkyQyBzeXN0ZW0gYnVzIGRyaXZlcnMgKG1v
c3RseSBlbWJlZGRlZCAvIHN5c3RlbS1vbi1jaGlwKQojCiMgQ09ORklHX0kyQ19PQ09SRVMgaXMg
bm90IHNldAojIENPTkZJR19JMkNfU0lNVEVDIGlzIG5vdCBzZXQKCiMKIyBFeHRlcm5hbCBJMkMv
U01CdXMgYWRhcHRlciBkcml2ZXJzCiMKQ09ORklHX0kyQ19QQVJQT1JUPW0KQ09ORklHX0kyQ19Q
QVJQT1JUX0xJR0hUPW0KIyBDT05GSUdfSTJDX1RBT1NfRVZNIGlzIG5vdCBzZXQKIyBDT05GSUdf
STJDX1RJTllfVVNCIGlzIG5vdCBzZXQKCiMKIyBHcmFwaGljcyBhZGFwdGVyIEkyQy9EREMgY2hh
bm5lbCBkcml2ZXJzCiMKQ09ORklHX0kyQ19WT09ET08zPW0KCiMKIyBPdGhlciBJMkMvU01CdXMg
YnVzIGRyaXZlcnMKIwojIENPTkZJR19JMkNfUENBX1BMQVRGT1JNIGlzIG5vdCBzZXQKQ09ORklH
X0kyQ19TVFVCPW0KIyBDT05GSUdfU0N4MjAwX0FDQiBpcyBub3Qgc2V0CgojCiMgTWlzY2VsbGFu
ZW91cyBJMkMgQ2hpcCBzdXBwb3J0CiMKIyBDT05GSUdfRFMxNjgyIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0VOU09SU19UU0wyNTUwIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0RFQlVHX0NPUkUgaXMg
bm90IHNldAojIENPTkZJR19JMkNfREVCVUdfQUxHTyBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19E
RUJVR19CVVMgaXMgbm90IHNldAojIENPTkZJR19JMkNfREVCVUdfQ0hJUCBpcyBub3Qgc2V0CiMg
Q09ORklHX1NQSSBpcyBub3Qgc2V0CgojCiMgUFBTIHN1cHBvcnQKIwojIENPTkZJR19QUFMgaXMg
bm90IHNldApDT05GSUdfQVJDSF9XQU5UX09QVElPTkFMX0dQSU9MSUI9eQojIENPTkZJR19HUElP
TElCIGlzIG5vdCBzZXQKIyBDT05GSUdfVzEgaXMgbm90IHNldApDT05GSUdfUE9XRVJfU1VQUExZ
PXkKIyBDT05GSUdfUE9XRVJfU1VQUExZX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfUERBX1BP
V0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFUVEVSWV9EUzI3NjAgaXMgbm90IHNldAojIENPTkZJ
R19CQVRURVJZX0RTMjc4MiBpcyBub3Qgc2V0CiMgQ09ORklHX0JBVFRFUllfQlEyN3gwMCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0JBVFRFUllfTUFYMTcwNDAgaXMgbm90IHNldApDT05GSUdfSFdNT049
bQpDT05GSUdfSFdNT05fVklEPW0KIyBDT05GSUdfSFdNT05fREVCVUdfQ0hJUCBpcyBub3Qgc2V0
CgojCiMgTmF0aXZlIGRyaXZlcnMKIwpDT05GSUdfU0VOU09SU19BQklUVUdVUlU9bQojIENPTkZJ
R19TRU5TT1JTX0FCSVRVR1VSVTMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FENzQxNCBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQUQ3NDE4IGlzIG5vdCBzZXQKQ09ORklHX1NFTlNP
UlNfQURNMTAyMT1tCkNPTkZJR19TRU5TT1JTX0FETTEwMjU9bQpDT05GSUdfU0VOU09SU19BRE0x
MDI2PW0KIyBDT05GSUdfU0VOU09SU19BRE0xMDI5IGlzIG5vdCBzZXQKQ09ORklHX1NFTlNPUlNf
QURNMTAzMT1tCkNPTkZJR19TRU5TT1JTX0FETTkyNDA9bQojIENPTkZJR19TRU5TT1JTX0FEVDc0
NjIgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FEVDc0NzAgaXMgbm90IHNldAojIENPTkZJ
R19TRU5TT1JTX0FEVDc0NzMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FEVDc0NzUgaXMg
bm90IHNldApDT05GSUdfU0VOU09SU19LOFRFTVA9bQpDT05GSUdfU0VOU09SU19BU0IxMDA9bQpD
T05GSUdfU0VOU09SU19BVFhQMT1tCkNPTkZJR19TRU5TT1JTX0RTMTYyMT1tCiMgQ09ORklHX1NF
TlNPUlNfSTVLX0FNQiBpcyBub3Qgc2V0CkNPTkZJR19TRU5TT1JTX0Y3MTgwNUY9bQojIENPTkZJ
R19TRU5TT1JTX0Y3MTg4MkZHIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19GNzUzNzVTIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19GU0NITUQgaXMgbm90IHNldAojIENPTkZJR19TRU5T
T1JTX0c3NjBBIGlzIG5vdCBzZXQKQ09ORklHX1NFTlNPUlNfR0w1MThTTT1tCkNPTkZJR19TRU5T
T1JTX0dMNTIwU009bQojIENPTkZJR19TRU5TT1JTX0NPUkVURU1QIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0VOU09SU19JQk1BRU0gaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0lCTVBFWCBpcyBu
b3Qgc2V0CkNPTkZJR19TRU5TT1JTX0lUODc9bQpDT05GSUdfU0VOU09SU19MTTYzPW0KQ09ORklH
X1NFTlNPUlNfTE03NT1tCkNPTkZJR19TRU5TT1JTX0xNNzc9bQpDT05GSUdfU0VOU09SU19MTTc4
PW0KQ09ORklHX1NFTlNPUlNfTE04MD1tCkNPTkZJR19TRU5TT1JTX0xNODM9bQpDT05GSUdfU0VO
U09SU19MTTg1PW0KQ09ORklHX1NFTlNPUlNfTE04Nz1tCkNPTkZJR19TRU5TT1JTX0xNOTA9bQpD
T05GSUdfU0VOU09SU19MTTkyPW0KIyBDT05GSUdfU0VOU09SU19MTTkzIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VOU09SU19MVEM0MjE1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MVEM0MjQ1
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MTTk1MjQxIGlzIG5vdCBzZXQKQ09ORklHX1NF
TlNPUlNfTUFYMTYxOT1tCiMgQ09ORklHX1NFTlNPUlNfTUFYNjY1MCBpcyBub3Qgc2V0CkNPTkZJ
R19TRU5TT1JTX1BDODczNjA9bQojIENPTkZJR19TRU5TT1JTX1BDODc0MjcgaXMgbm90IHNldApD
T05GSUdfU0VOU09SU19QQ0Y4NTkxPW0KQ09ORklHX1NFTlNPUlNfU0lTNTU5NT1tCiMgQ09ORklH
X1NFTlNPUlNfRE1FMTczNyBpcyBub3Qgc2V0CkNPTkZJR19TRU5TT1JTX1NNU0M0N00xPW0KQ09O
RklHX1NFTlNPUlNfU01TQzQ3TTE5Mj1tCkNPTkZJR19TRU5TT1JTX1NNU0M0N0IzOTc9bQojIENP
TkZJR19TRU5TT1JTX0FEUzc4MjggaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1RITUM1MCBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVE1QNDAxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VO
U09SU19UTVA0MjEgaXMgbm90IHNldApDT05GSUdfU0VOU09SU19WSUE2ODZBPW0KIyBDT05GSUdf
U0VOU09SU19WVDEyMTEgaXMgbm90IHNldApDT05GSUdfU0VOU09SU19WVDgyMzE9bQpDT05GSUdf
U0VOU09SU19XODM3ODFEPW0KQ09ORklHX1NFTlNPUlNfVzgzNzkxRD1tCkNPTkZJR19TRU5TT1JT
X1c4Mzc5MkQ9bQojIENPTkZJR19TRU5TT1JTX1c4Mzc5MyBpcyBub3Qgc2V0CkNPTkZJR19TRU5T
T1JTX1c4M0w3ODVUUz1tCiMgQ09ORklHX1NFTlNPUlNfVzgzTDc4Nk5HIGlzIG5vdCBzZXQKQ09O
RklHX1NFTlNPUlNfVzgzNjI3SEY9bQpDT05GSUdfU0VOU09SU19XODM2MjdFSEY9bQpDT05GSUdf
U0VOU09SU19IREFQUz1tCiMgQ09ORklHX1NFTlNPUlNfQVBQTEVTTUMgaXMgbm90IHNldAoKIwoj
IEFDUEkgZHJpdmVycwojCiMgQ09ORklHX1NFTlNPUlNfQVRLMDExMCBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfTElTM0xWMDJEIGlzIG5vdCBzZXQKQ09ORklHX1RIRVJNQUw9eQpDT05GSUdf
V0FUQ0hET0c9eQojIENPTkZJR19XQVRDSERPR19OT1dBWU9VVCBpcyBub3Qgc2V0CgojCiMgV2F0
Y2hkb2cgRGV2aWNlIERyaXZlcnMKIwpDT05GSUdfU09GVF9XQVRDSERPRz1tCiMgQ09ORklHX0FD
UVVJUkVfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfQURWQU5URUNIX1dEVCBpcyBub3Qgc2V0CkNP
TkZJR19BTElNMTUzNV9XRFQ9bQpDT05GSUdfQUxJTTcxMDFfV0RUPW0KIyBDT05GSUdfU0M1MjBf
V0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfU0JDX0ZJVFBDMl9XQVRDSERPRyBpcyBub3Qgc2V0CiMg
Q09ORklHX0VVUk9URUNIX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lCNzAwX1dEVCBpcyBub3Qg
c2V0CkNPTkZJR19JQk1BU1I9bQojIENPTkZJR19XQUZFUl9XRFQgaXMgbm90IHNldApDT05GSUdf
STYzMDBFU0JfV0RUPW0KIyBDT05GSUdfSVRDT19XRFQgaXMgbm90IHNldAojIENPTkZJR19JVDg3
MTJGX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lUODdfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdf
SFBfV0FUQ0hET0cgaXMgbm90IHNldAojIENPTkZJR19TQzEyMDBfV0RUIGlzIG5vdCBzZXQKIyBD
T05GSUdfUEM4NzQxM19XRFQgaXMgbm90IHNldAojIENPTkZJR182MFhYX1dEVCBpcyBub3Qgc2V0
CiMgQ09ORklHX1NCQzgzNjBfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfU0JDNzI0MF9XRFQgaXMg
bm90IHNldAojIENPTkZJR19DUFU1X1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NNU0NfU0NIMzEx
WF9XRFQgaXMgbm90IHNldAojIENPTkZJR19TTVNDMzdCNzg3X1dEVCBpcyBub3Qgc2V0CkNPTkZJ
R19XODM2MjdIRl9XRFQ9bQojIENPTkZJR19XODM2OTdIRl9XRFQgaXMgbm90IHNldAojIENPTkZJ
R19XODM2OTdVR19XRFQgaXMgbm90IHNldApDT05GSUdfVzgzODc3Rl9XRFQ9bQpDT05GSUdfVzgz
OTc3Rl9XRFQ9bQpDT05GSUdfTUFDSFpfV0RUPW0KIyBDT05GSUdfU0JDX0VQWF9DM19XQVRDSERP
RyBpcyBub3Qgc2V0CgojCiMgUENJLWJhc2VkIFdhdGNoZG9nIENhcmRzCiMKQ09ORklHX1BDSVBD
V0FUQ0hET0c9bQpDT05GSUdfV0RUUENJPW0KCiMKIyBVU0ItYmFzZWQgV2F0Y2hkb2cgQ2FyZHMK
IwpDT05GSUdfVVNCUENXQVRDSERPRz1tCkNPTkZJR19TU0JfUE9TU0lCTEU9eQoKIwojIFNvbmlj
cyBTaWxpY29uIEJhY2twbGFuZQojCkNPTkZJR19TU0I9bQpDT05GSUdfU1NCX1NQUk9NPXkKQ09O
RklHX1NTQl9QQ0lIT1NUX1BPU1NJQkxFPXkKQ09ORklHX1NTQl9QQ0lIT1NUPXkKIyBDT05GSUdf
U1NCX0I0M19QQ0lfQlJJREdFIGlzIG5vdCBzZXQKQ09ORklHX1NTQl9QQ01DSUFIT1NUX1BPU1NJ
QkxFPXkKIyBDT05GSUdfU1NCX1BDTUNJQUhPU1QgaXMgbm90IHNldApDT05GSUdfU1NCX1NESU9I
T1NUX1BPU1NJQkxFPXkKIyBDT05GSUdfU1NCX1NESU9IT1NUIGlzIG5vdCBzZXQKIyBDT05GSUdf
U1NCX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX1NTQl9EUklWRVJfUENJQ09SRV9QT1NTSUJMRT15
CkNPTkZJR19TU0JfRFJJVkVSX1BDSUNPUkU9eQoKIwojIE11bHRpZnVuY3Rpb24gZGV2aWNlIGRy
aXZlcnMKIwojIENPTkZJR19NRkRfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9TTTUwMSBp
cyBub3Qgc2V0CiMgQ09ORklHX0hUQ19QQVNJQzMgaXMgbm90IHNldAojIENPTkZJR19NRkRfVE1J
TyBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9XTTg0MDAgaXMgbm90IHNldAojIENPTkZJR19NRkRf
V004MzFYIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1dNODM1MF9JMkMgaXMgbm90IHNldAojIENP
TkZJR19NRkRfUENGNTA2MzMgaXMgbm90IHNldAojIENPTkZJR19BQjMxMDBfQ09SRSBpcyBub3Qg
c2V0CiMgQ09ORklHX1JFR1VMQVRPUiBpcyBub3Qgc2V0CkNPTkZJR19NRURJQV9TVVBQT1JUPW0K
CiMKIyBNdWx0aW1lZGlhIGNvcmUgc3VwcG9ydAojCkNPTkZJR19WSURFT19ERVY9bQpDT05GSUdf
VklERU9fVjRMMl9DT01NT049bQpDT05GSUdfVklERU9fQUxMT1dfVjRMMT15CkNPTkZJR19WSURF
T19WNEwxX0NPTVBBVD15CkNPTkZJR19EVkJfQ09SRT1tCkNPTkZJR19WSURFT19NRURJQT1tCgoj
CiMgTXVsdGltZWRpYSBkcml2ZXJzCiMKQ09ORklHX01FRElBX0FUVEFDSD15CkNPTkZJR19NRURJ
QV9UVU5FUj1tCkNPTkZJR19NRURJQV9UVU5FUl9DVVNUT01JU0U9eQpDT05GSUdfTUVESUFfVFVO
RVJfU0lNUExFPW0KQ09ORklHX01FRElBX1RVTkVSX1REQTgyOTA9bQpDT05GSUdfTUVESUFfVFVO
RVJfVERBODI3WD1tCkNPTkZJR19NRURJQV9UVU5FUl9UREExODI3MT1tCkNPTkZJR19NRURJQV9U
VU5FUl9UREE5ODg3PW0KQ09ORklHX01FRElBX1RVTkVSX1RFQTU3NjE9bQpDT05GSUdfTUVESUFf
VFVORVJfVEVBNTc2Nz1tCkNPTkZJR19NRURJQV9UVU5FUl9NVDIwWFg9bQpDT05GSUdfTUVESUFf
VFVORVJfTVQyMDYwPW0KQ09ORklHX01FRElBX1RVTkVSX01UMjI2Nj1tCkNPTkZJR19NRURJQV9U
VU5FUl9NVDIxMzE9bQpDT05GSUdfTUVESUFfVFVORVJfUVQxMDEwPW0KQ09ORklHX01FRElBX1RV
TkVSX1hDMjAyOD1tCkNPTkZJR19NRURJQV9UVU5FUl9YQzUwMDA9bQpDT05GSUdfTUVESUFfVFVO
RVJfTVhMNTAwNVM9bQpDT05GSUdfTUVESUFfVFVORVJfTVhMNTAwN1Q9bQpDT05GSUdfTUVESUFf
VFVORVJfTUM0NFM4MDM9bQpDT05GSUdfVklERU9fVjRMMj1tCkNPTkZJR19WSURFT19WNEwxPW0K
Q09ORklHX1ZJREVPX0NBUFRVUkVfRFJJVkVSUz15CiMgQ09ORklHX1ZJREVPX0FEVl9ERUJVRyBp
cyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX0ZJWEVEX01JTk9SX1JBTkdFUyBpcyBub3Qgc2V0CkNP
TkZJR19WSURFT19IRUxQRVJfQ0hJUFNfQVVUTz15CiMgQ09ORklHX1ZJREVPX1ZJVkkgaXMgbm90
IHNldAojIENPTkZJR19WSURFT19CVDg0OCBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX0JXUUNB
TSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX0NRQ0FNIGlzIG5vdCBzZXQKIyBDT05GSUdfVklE
RU9fVzk5NjYgaXMgbm90IHNldAojIENPTkZJR19WSURFT19DUElBIGlzIG5vdCBzZXQKIyBDT05G
SUdfVklERU9fQ1BJQTIgaXMgbm90IHNldAojIENPTkZJR19WSURFT19TQUE1MjQ2QSBpcyBub3Qg
c2V0CiMgQ09ORklHX1ZJREVPX1NBQTUyNDkgaXMgbm90IHNldAojIENPTkZJR19WSURFT19TVFJB
RElTIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fWk9SQU4gaXMgbm90IHNldAojIENPTkZJR19W
SURFT19TQUE3MTM0IGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fTVhCIGlzIG5vdCBzZXQKIyBD
T05GSUdfVklERU9fSEVYSVVNX09SSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fSEVYSVVN
X0dFTUlOSSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX0NYODggaXMgbm90IHNldAojIENPTkZJ
R19WSURFT19DWDIzODg1IGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fQVUwODI4IGlzIG5vdCBz
ZXQKIyBDT05GSUdfVklERU9fSVZUViBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX0NYMTggaXMg
bm90IHNldAojIENPTkZJR19WSURFT19TQUE3MTY0IGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9f
Q0FGRV9DQ0lDIGlzIG5vdCBzZXQKIyBDT05GSUdfU09DX0NBTUVSQSBpcyBub3Qgc2V0CkNPTkZJ
R19WNExfVVNCX0RSSVZFUlM9eQojIENPTkZJR19VU0JfVklERU9fQ0xBU1MgaXMgbm90IHNldApD
T05GSUdfVVNCX1ZJREVPX0NMQVNTX0lOUFVUX0VWREVWPXkKQ09ORklHX1VTQl9HU1BDQT1tCiMg
Q09ORklHX1VTQl9NNTYwMiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVFYwNlhYIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVVNCX0dMODYwIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0dTUENBX0NPTkVY
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0dTUENBX0VUT01TIGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX0dTUENBX0ZJTkVQSVggaXMgbm90IHNldAojIENPTkZJR19VU0JfR1NQQ0FfSkVJTElOSiBp
cyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HU1BDQV9NQVJTIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNC
X0dTUENBX01SOTczMTBBIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0dTUENBX09WNTE5IGlzIG5v
dCBzZXQKIyBDT05GSUdfVVNCX0dTUENBX09WNTM0IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0dT
UENBX1BBQzIwNyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HU1BDQV9QQUM3MzExIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVVNCX0dTUENBX1NOOUMyMFggaXMgbm90IHNldAojIENPTkZJR19VU0JfR1NQ
Q0FfU09OSVhCIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0dTUENBX1NPTklYSiBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9HU1BDQV9TUENBNTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0dTUENB
X1NQQ0E1MDEgaXMgbm90IHNldAojIENPTkZJR19VU0JfR1NQQ0FfU1BDQTUwNSBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9HU1BDQV9TUENBNTA2IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0dTUENB
X1NQQ0E1MDggaXMgbm90IHNldAojIENPTkZJR19VU0JfR1NQQ0FfU1BDQTU2MSBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9HU1BDQV9TUTkwNSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HU1BDQV9T
UTkwNUMgaXMgbm90IHNldAojIENPTkZJR19VU0JfR1NQQ0FfU1RLMDE0IGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNCX0dTUENBX1NVTlBMVVMgaXMgbm90IHNldAojIENPTkZJR19VU0JfR1NQQ0FfVDYx
MyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HU1BDQV9UVjg1MzIgaXMgbm90IHNldAojIENPTkZJ
R19VU0JfR1NQQ0FfVkMwMzJYIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0dTUENBX1pDM1hYIGlz
IG5vdCBzZXQKIyBDT05GSUdfVklERU9fUFZSVVNCMiBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVP
X0hEUFZSIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fRU0yOFhYIGlzIG5vdCBzZXQKIyBDT05G
SUdfVklERU9fQ1gyMzFYWCBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1VTQlZJU0lPTiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1VTQl9WSUNBTSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JQk1DQU0g
aXMgbm90IHNldAojIENPTkZJR19VU0JfS09OSUNBV0MgaXMgbm90IHNldAojIENPTkZJR19VU0Jf
UVVJQ0tDQU1fTUVTU0VOR0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0VUNjFYMjUxIGlzIG5v
dCBzZXQKIyBDT05GSUdfVklERU9fT1ZDQU1DSElQIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX09W
NTExIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFNDAxIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNC
X1NOOUMxMDIgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RWNjgwIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX1pDMDMwMSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9QV0MgaXMgbm90IHNldApDT05G
SUdfVVNCX1BXQ19JTlBVVF9FVkRFVj15CiMgQ09ORklHX1VTQl9aUjM2NFhYIGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX1NUS1dFQkNBTSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TMjI1NSBpcyBu
b3Qgc2V0CkNPTkZJR19SQURJT19BREFQVEVSUz15CiMgQ09ORklHX1JBRElPX0dFTVRFS19QQ0kg
aXMgbm90IHNldAojIENPTkZJR19SQURJT19NQVhJUkFESU8gaXMgbm90IHNldAojIENPTkZJR19S
QURJT19NQUVTVFJPIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1NJNDcxMyBpcyBub3Qgc2V0CiMg
Q09ORklHX1JBRElPX1NJNDcxMyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9EU0JSIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUkFESU9fU0k0NzBYIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX01SODAwIGlz
IG5vdCBzZXQKIyBDT05GSUdfUkFESU9fVEVBNTc2NCBpcyBub3Qgc2V0CkNPTkZJR19EVkJfTUFY
X0FEQVBURVJTPTgKQ09ORklHX0RWQl9EWU5BTUlDX01JTk9SUz15CkNPTkZJR19EVkJfQ0FQVFVS
RV9EUklWRVJTPXkKCiMKIyBTdXBwb3J0ZWQgU0FBNzE0NiBiYXNlZCBQQ0kgQWRhcHRlcnMKIwoj
IENPTkZJR19UVFBDSV9FRVBST00gaXMgbm90IHNldAojIENPTkZJR19EVkJfQVY3MTEwIGlzIG5v
dCBzZXQKIyBDT05GSUdfRFZCX0JVREdFVF9DT1JFIGlzIG5vdCBzZXQKCiMKIyBTdXBwb3J0ZWQg
VVNCIEFkYXB0ZXJzCiMKIyBDT05GSUdfRFZCX1VTQiBpcyBub3Qgc2V0CiMgQ09ORklHX0RWQl9U
VFVTQl9CVURHRVQgaXMgbm90IHNldAojIENPTkZJR19EVkJfVFRVU0JfREVDIGlzIG5vdCBzZXQK
IyBDT05GSUdfU01TX1NJQU5PX01EVFYgaXMgbm90IHNldAoKIwojIFN1cHBvcnRlZCBGbGV4Q29w
SUkgKEIyQzIpIEFkYXB0ZXJzCiMKIyBDT05GSUdfRFZCX0IyQzJfRkxFWENPUCBpcyBub3Qgc2V0
CgojCiMgU3VwcG9ydGVkIEJUODc4IEFkYXB0ZXJzCiMKCiMKIyBTdXBwb3J0ZWQgUGx1dG8yIEFk
YXB0ZXJzCiMKIyBDT05GSUdfRFZCX1BMVVRPMiBpcyBub3Qgc2V0CgojCiMgU3VwcG9ydGVkIFNE
TUMgRE0xMTA1IEFkYXB0ZXJzCiMKIyBDT05GSUdfRFZCX0RNMTEwNSBpcyBub3Qgc2V0CgojCiMg
U3VwcG9ydGVkIEVhcnRoc29mdCBQVDEgQWRhcHRlcnMKIwojIENPTkZJR19EVkJfUFQxIGlzIG5v
dCBzZXQKCiMKIyBTdXBwb3J0ZWQgRFZCIEZyb250ZW5kcwojCiMgQ09ORklHX0RWQl9GRV9DVVNU
T01JU0UgaXMgbm90IHNldApDT05GSUdfREFCPXkKIyBDT05GSUdfVVNCX0RBQlVTQiBpcyBub3Qg
c2V0CgojCiMgR3JhcGhpY3Mgc3VwcG9ydAojCkNPTkZJR19BR1A9eQpDT05GSUdfQUdQX0FMST15
CkNPTkZJR19BR1BfQVRJPXkKQ09ORklHX0FHUF9BTUQ9eQpDT05GSUdfQUdQX0FNRDY0PXkKQ09O
RklHX0FHUF9JTlRFTD15CkNPTkZJR19BR1BfTlZJRElBPXkKQ09ORklHX0FHUF9TSVM9eQpDT05G
SUdfQUdQX1NXT1JLUz15CkNPTkZJR19BR1BfVklBPXkKQ09ORklHX0FHUF9FRkZJQ0VPTj15CkNP
TkZJR19WR0FfQVJCPXkKQ09ORklHX0RSTT1tCkNPTkZJR19EUk1fS01TX0hFTFBFUj1tCkNPTkZJ
R19EUk1fVFRNPW0KIyBDT05GSUdfRFJNX1RERlggaXMgbm90IHNldApDT05GSUdfRFJNX1IxMjg9
bQpDT05GSUdfRFJNX1JBREVPTj1tCkNPTkZJR19EUk1fSTgxMD1tCkNPTkZJR19EUk1fSTgzMD1t
CkNPTkZJR19EUk1fSTkxNT1tCiMgQ09ORklHX0RSTV9JOTE1X0tNUyBpcyBub3Qgc2V0CkNPTkZJ
R19EUk1fTUdBPW0KIyBDT05GSUdfRFJNX1NJUyBpcyBub3Qgc2V0CkNPTkZJR19EUk1fVklBPW0K
Q09ORklHX0RSTV9TQVZBR0U9bQpDT05GSUdfVkdBU1RBVEU9bQpDT05GSUdfVklERU9fT1VUUFVU
X0NPTlRST0w9bQpDT05GSUdfRkI9eQojIENPTkZJR19GSVJNV0FSRV9FRElEIGlzIG5vdCBzZXQK
Q09ORklHX0ZCX0REQz1tCkNPTkZJR19GQl9CT09UX1ZFU0FfU1VQUE9SVD15CkNPTkZJR19GQl9D
RkJfRklMTFJFQ1Q9eQpDT05GSUdfRkJfQ0ZCX0NPUFlBUkVBPXkKQ09ORklHX0ZCX0NGQl9JTUFH
RUJMSVQ9eQojIENPTkZJR19GQl9DRkJfUkVWX1BJWEVMU19JTl9CWVRFIGlzIG5vdCBzZXQKIyBD
T05GSUdfRkJfU1lTX0ZJTExSRUNUIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfU1lTX0NPUFlBUkVB
IGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfU1lTX0lNQUdFQkxJVCBpcyBub3Qgc2V0CiMgQ09ORklH
X0ZCX0ZPUkVJR05fRU5ESUFOIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfU1lTX0ZPUFMgaXMgbm90
IHNldAojIENPTkZJR19GQl9TVkdBTElCIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfTUFDTU9ERVMg
aXMgbm90IHNldApDT05GSUdfRkJfQkFDS0xJR0hUPXkKQ09ORklHX0ZCX01PREVfSEVMUEVSUz15
CkNPTkZJR19GQl9USUxFQkxJVFRJTkc9eQoKIwojIEZyYW1lIGJ1ZmZlciBoYXJkd2FyZSBkcml2
ZXJzCiMKQ09ORklHX0ZCX0NJUlJVUz1tCiMgQ09ORklHX0ZCX1BNMiBpcyBub3Qgc2V0CiMgQ09O
RklHX0ZCX0NZQkVSMjAwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0FSQyBpcyBub3Qgc2V0CiMg
Q09ORklHX0ZCX0FTSUxJQU5UIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfSU1TVFQgaXMgbm90IHNl
dApDT05GSUdfRkJfVkdBMTY9bQojIENPTkZJR19GQl9VVkVTQSBpcyBub3Qgc2V0CkNPTkZJR19G
Ql9WRVNBPXkKIyBDT05GSUdfRkJfRUZJIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfTjQxMSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0ZCX0hHQSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1MxRDEzWFhYIGlz
IG5vdCBzZXQKQ09ORklHX0ZCX05WSURJQT1tCkNPTkZJR19GQl9OVklESUFfSTJDPXkKIyBDT05G
SUdfRkJfTlZJRElBX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0ZCX05WSURJQV9CQUNLTElHSFQ9
eQpDT05GSUdfRkJfUklWQT1tCiMgQ09ORklHX0ZCX1JJVkFfSTJDIGlzIG5vdCBzZXQKIyBDT05G
SUdfRkJfUklWQV9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19GQl9SSVZBX0JBQ0tMSUdIVD15CkNP
TkZJR19GQl9JODEwPW0KQ09ORklHX0ZCX0k4MTBfR1RGPXkKQ09ORklHX0ZCX0k4MTBfSTJDPXkK
IyBDT05GSUdfRkJfTEU4MDU3OCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX01BVFJPWCBpcyBub3Qg
c2V0CkNPTkZJR19GQl9SQURFT049bQojIENPTkZJR19GQl9SQURFT05fSTJDIGlzIG5vdCBzZXQK
Q09ORklHX0ZCX1JBREVPTl9CQUNLTElHSFQ9eQojIENPTkZJR19GQl9SQURFT05fREVCVUcgaXMg
bm90IHNldAojIENPTkZJR19GQl9BVFkxMjggaXMgbm90IHNldAojIENPTkZJR19GQl9BVFkgaXMg
bm90IHNldAojIENPTkZJR19GQl9TMyBpcyBub3Qgc2V0CkNPTkZJR19GQl9TQVZBR0U9bQpDT05G
SUdfRkJfU0FWQUdFX0kyQz15CkNPTkZJR19GQl9TQVZBR0VfQUNDRUw9eQojIENPTkZJR19GQl9T
SVMgaXMgbm90IHNldAojIENPTkZJR19GQl9WSUEgaXMgbm90IHNldAojIENPTkZJR19GQl9ORU9N
QUdJQyBpcyBub3Qgc2V0CkNPTkZJR19GQl9LWVJPPW0KIyBDT05GSUdfRkJfM0RGWCBpcyBub3Qg
c2V0CiMgQ09ORklHX0ZCX1ZPT0RPTzEgaXMgbm90IHNldAojIENPTkZJR19GQl9WVDg2MjMgaXMg
bm90IHNldAojIENPTkZJR19GQl9UUklERU5UIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfQVJLIGlz
IG5vdCBzZXQKIyBDT05GSUdfRkJfUE0zIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfQ0FSTUlORSBp
cyBub3Qgc2V0CiMgQ09ORklHX0ZCX0dFT0RFIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfVklSVFVB
TCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX01FVFJPTk9NRSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZC
X01CODYyWFggaXMgbm90IHNldAojIENPTkZJR19GQl9CUk9BRFNIRUVUIGlzIG5vdCBzZXQKQ09O
RklHX0JBQ0tMSUdIVF9MQ0RfU1VQUE9SVD15CkNPTkZJR19MQ0RfQ0xBU1NfREVWSUNFPW0KIyBD
T05GSUdfTENEX0lMSTkzMjAgaXMgbm90IHNldAojIENPTkZJR19MQ0RfUExBVEZPUk0gaXMgbm90
IHNldApDT05GSUdfQkFDS0xJR0hUX0NMQVNTX0RFVklDRT15CkNPTkZJR19CQUNLTElHSFRfR0VO
RVJJQz15CiMgQ09ORklHX0JBQ0tMSUdIVF9QUk9HRUFSIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFD
S0xJR0hUX01CUF9OVklESUEgaXMgbm90IHNldAojIENPTkZJR19CQUNLTElHSFRfU0FIQVJBIGlz
IG5vdCBzZXQKCiMKIyBEaXNwbGF5IGRldmljZSBzdXBwb3J0CiMKIyBDT05GSUdfRElTUExBWV9T
VVBQT1JUIGlzIG5vdCBzZXQKCiMKIyBDb25zb2xlIGRpc3BsYXkgZHJpdmVyIHN1cHBvcnQKIwpD
T05GSUdfVkdBX0NPTlNPTEU9eQpDT05GSUdfVkdBQ09OX1NPRlRfU0NST0xMQkFDSz15CkNPTkZJ
R19WR0FDT05fU09GVF9TQ1JPTExCQUNLX1NJWkU9NjQKQ09ORklHX0RVTU1ZX0NPTlNPTEU9eQpD
T05GSUdfRlJBTUVCVUZGRVJfQ09OU09MRT15CiMgQ09ORklHX0ZSQU1FQlVGRkVSX0NPTlNPTEVf
REVURUNUX1BSSU1BUlkgaXMgbm90IHNldApDT05GSUdfRlJBTUVCVUZGRVJfQ09OU09MRV9ST1RB
VElPTj15CiMgQ09ORklHX0ZPTlRTIGlzIG5vdCBzZXQKQ09ORklHX0ZPTlRfOHg4PXkKQ09ORklH
X0ZPTlRfOHgxNj15CkNPTkZJR19MT0dPPXkKIyBDT05GSUdfTE9HT19MSU5VWF9NT05PIGlzIG5v
dCBzZXQKIyBDT05GSUdfTE9HT19MSU5VWF9WR0ExNiBpcyBub3Qgc2V0CkNPTkZJR19MT0dPX0xJ
TlVYX0NMVVQyMjQ9eQpDT05GSUdfU09VTkQ9bQpDT05GSUdfU09VTkRfT1NTX0NPUkU9eQpDT05G
SUdfU09VTkRfT1NTX0NPUkVfUFJFQ0xBSU09eQpDT05GSUdfU05EPW0KQ09ORklHX1NORF9USU1F
Uj1tCkNPTkZJR19TTkRfUENNPW0KQ09ORklHX1NORF9IV0RFUD1tCkNPTkZJR19TTkRfUkFXTUlE
ST1tCkNPTkZJR19TTkRfU0VRVUVOQ0VSPW0KQ09ORklHX1NORF9TRVFfRFVNTVk9bQpDT05GSUdf
U05EX09TU0VNVUw9eQpDT05GSUdfU05EX01JWEVSX09TUz1tCkNPTkZJR19TTkRfUENNX09TUz1t
CkNPTkZJR19TTkRfUENNX09TU19QTFVHSU5TPXkKQ09ORklHX1NORF9TRVFVRU5DRVJfT1NTPXkK
Q09ORklHX1NORF9EWU5BTUlDX01JTk9SUz15CiMgQ09ORklHX1NORF9TVVBQT1JUX09MRF9BUEkg
aXMgbm90IHNldApDT05GSUdfU05EX1ZFUkJPU0VfUFJPQ0ZTPXkKIyBDT05GSUdfU05EX1ZFUkJP
U0VfUFJJTlRLIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklH
X1NORF9WTUFTVEVSPXkKQ09ORklHX1NORF9ETUFfU0dCVUY9eQpDT05GSUdfU05EX1JBV01JRElf
U0VRPW0KQ09ORklHX1NORF9PUEwzX0xJQl9TRVE9bQojIENPTkZJR19TTkRfT1BMNF9MSUJfU0VR
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NCQVdFX1NFUSBpcyBub3Qgc2V0CkNPTkZJR19TTkRf
RU1VMTBLMV9TRVE9bQpDT05GSUdfU05EX01QVTQwMV9VQVJUPW0KQ09ORklHX1NORF9PUEwzX0xJ
Qj1tCkNPTkZJR19TTkRfVlhfTElCPW0KQ09ORklHX1NORF9BQzk3X0NPREVDPW0KQ09ORklHX1NO
RF9EUklWRVJTPXkKQ09ORklHX1NORF9EVU1NWT1tCkNPTkZJR19TTkRfVklSTUlEST1tCkNPTkZJ
R19TTkRfTVRQQVY9bQojIENPTkZJR19TTkRfTVRTNjQgaXMgbm90IHNldAojIENPTkZJR19TTkRf
U0VSSUFMX1UxNjU1MCBpcyBub3Qgc2V0CkNPTkZJR19TTkRfTVBVNDAxPW0KIyBDT05GSUdfU05E
X1BPUlRNQU4yWDQgaXMgbm90IHNldAojIENPTkZJR19TTkRfQUM5N19QT1dFUl9TQVZFIGlzIG5v
dCBzZXQKQ09ORklHX1NORF9TQl9DT01NT049bQpDT05GSUdfU05EX1BDST15CkNPTkZJR19TTkRf
QUQxODg5PW0KQ09ORklHX1NORF9BTFMzMDA9bQpDT05GSUdfU05EX0FMUzQwMDA9bQpDT05GSUdf
U05EX0FMSTU0NTE9bQpDT05GSUdfU05EX0FUSUlYUD1tCkNPTkZJR19TTkRfQVRJSVhQX01PREVN
PW0KQ09ORklHX1NORF9BVTg4MTA9bQpDT05GSUdfU05EX0FVODgyMD1tCkNPTkZJR19TTkRfQVU4
ODMwPW0KIyBDT05GSUdfU05EX0FXMiBpcyBub3Qgc2V0CkNPTkZJR19TTkRfQVpUMzMyOD1tCkNP
TkZJR19TTkRfQlQ4N1g9bQojIENPTkZJR19TTkRfQlQ4N1hfT1ZFUkNMT0NLIGlzIG5vdCBzZXQK
Q09ORklHX1NORF9DQTAxMDY9bQpDT05GSUdfU05EX0NNSVBDST1tCiMgQ09ORklHX1NORF9PWFlH
RU4gaXMgbm90IHNldApDT05GSUdfU05EX0NTNDI4MT1tCkNPTkZJR19TTkRfQ1M0NlhYPW0KQ09O
RklHX1NORF9DUzQ2WFhfTkVXX0RTUD15CiMgQ09ORklHX1NORF9DUzU1MzAgaXMgbm90IHNldApD
T05GSUdfU05EX0NTNTUzNUFVRElPPW0KIyBDT05GSUdfU05EX0NUWEZJIGlzIG5vdCBzZXQKQ09O
RklHX1NORF9EQVJMQTIwPW0KQ09ORklHX1NORF9HSU5BMjA9bQpDT05GSUdfU05EX0xBWUxBMjA9
bQpDT05GSUdfU05EX0RBUkxBMjQ9bQpDT05GSUdfU05EX0dJTkEyND1tCkNPTkZJR19TTkRfTEFZ
TEEyND1tCkNPTkZJR19TTkRfTU9OQT1tCkNPTkZJR19TTkRfTUlBPW0KQ09ORklHX1NORF9FQ0hP
M0c9bQpDT05GSUdfU05EX0lORElHTz1tCkNPTkZJR19TTkRfSU5ESUdPSU89bQpDT05GSUdfU05E
X0lORElHT0RKPW0KIyBDT05GSUdfU05EX0lORElHT0lPWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NO
RF9JTkRJR09ESlggaXMgbm90IHNldApDT05GSUdfU05EX0VNVTEwSzE9bQpDT05GSUdfU05EX0VN
VTEwSzFYPW0KQ09ORklHX1NORF9FTlMxMzcwPW0KQ09ORklHX1NORF9FTlMxMzcxPW0KQ09ORklH
X1NORF9FUzE5Mzg9bQpDT05GSUdfU05EX0VTMTk2OD1tCkNPTkZJR19TTkRfRk04MDE9bQojIENP
TkZJR19TTkRfRk04MDFfVEVBNTc1WF9CT09MIGlzIG5vdCBzZXQKQ09ORklHX1NORF9IREFfSU5U
RUw9bQojIENPTkZJR19TTkRfSERBX0hXREVQIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0hEQV9J
TlBVVF9CRUVQIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0hEQV9JTlBVVF9KQUNLIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU05EX0hEQV9QQVRDSF9MT0FERVIgaXMgbm90IHNldApDT05GSUdfU05EX0hE
QV9DT0RFQ19SRUFMVEVLPXkKQ09ORklHX1NORF9IREFfQ09ERUNfQU5BTE9HPXkKQ09ORklHX1NO
RF9IREFfQ09ERUNfU0lHTUFURUw9eQpDT05GSUdfU05EX0hEQV9DT0RFQ19WSUE9eQpDT05GSUdf
U05EX0hEQV9DT0RFQ19BVElIRE1JPXkKQ09ORklHX1NORF9IREFfQ09ERUNfTlZIRE1JPXkKQ09O
RklHX1NORF9IREFfQ09ERUNfSU5URUxIRE1JPXkKQ09ORklHX1NORF9IREFfRUxEPXkKQ09ORklH
X1NORF9IREFfQ09ERUNfQ0lSUlVTPXkKQ09ORklHX1NORF9IREFfQ09ERUNfQ09ORVhBTlQ9eQpD
T05GSUdfU05EX0hEQV9DT0RFQ19DQTAxMTA9eQpDT05GSUdfU05EX0hEQV9DT0RFQ19DTUVESUE9
eQpDT05GSUdfU05EX0hEQV9DT0RFQ19TSTMwNTQ9eQpDT05GSUdfU05EX0hEQV9HRU5FUklDPXkK
IyBDT05GSUdfU05EX0hEQV9QT1dFUl9TQVZFIGlzIG5vdCBzZXQKQ09ORklHX1NORF9IRFNQPW0K
Q09ORklHX1NORF9IRFNQTT1tCiMgQ09ORklHX1NORF9ISUZJRVIgaXMgbm90IHNldApDT05GSUdf
U05EX0lDRTE3MTI9bQpDT05GSUdfU05EX0lDRTE3MjQ9bQpDT05GSUdfU05EX0lOVEVMOFgwPW0K
Q09ORklHX1NORF9JTlRFTDhYME09bQpDT05GSUdfU05EX0tPUkcxMjEyPW0KIyBDT05GSUdfU05E
X0xYNjQ2NEVTIGlzIG5vdCBzZXQKQ09ORklHX1NORF9NQUVTVFJPMz1tCkNPTkZJR19TTkRfTUlY
QVJUPW0KQ09ORklHX1NORF9OTTI1Nj1tCkNPTkZJR19TTkRfUENYSFI9bQpDT05GSUdfU05EX1JJ
UFRJREU9bQpDT05GSUdfU05EX1JNRTMyPW0KQ09ORklHX1NORF9STUU5Nj1tCkNPTkZJR19TTkRf
Uk1FOTY1Mj1tCiMgQ09ORklHX1NORF9TSVM3MDE5IGlzIG5vdCBzZXQKQ09ORklHX1NORF9TT05J
Q1ZJQkVTPW0KQ09ORklHX1NORF9UUklERU5UPW0KQ09ORklHX1NORF9WSUE4MlhYPW0KQ09ORklH
X1NORF9WSUE4MlhYX01PREVNPW0KIyBDT05GSUdfU05EX1ZJUlRVT1NPIGlzIG5vdCBzZXQKQ09O
RklHX1NORF9WWDIyMj1tCkNPTkZJR19TTkRfWU1GUENJPW0KQ09ORklHX1NORF9VU0I9eQpDT05G
SUdfU05EX1VTQl9BVURJTz1tCkNPTkZJR19TTkRfVVNCX1VTWDJZPW0KIyBDT05GSUdfU05EX1VT
Ql9DQUlBUSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9VU0JfVVMxMjJMIGlzIG5vdCBzZXQKQ09O
RklHX1NORF9QQ01DSUE9eQojIENPTkZJR19TTkRfVlhQT0NLRVQgaXMgbm90IHNldAojIENPTkZJ
R19TTkRfUERBVURJT0NGIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NPQyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NPVU5EX1BSSU1FIGlzIG5vdCBzZXQKQ09ORklHX0FDOTdfQlVTPW0KQ09ORklHX0hJ
RF9TVVBQT1JUPXkKQ09ORklHX0hJRD15CiMgQ09ORklHX0hJRFJBVyBpcyBub3Qgc2V0CgojCiMg
VVNCIElucHV0IERldmljZXMKIwpDT05GSUdfVVNCX0hJRD15CkNPTkZJR19ISURfUElEPXkKQ09O
RklHX1VTQl9ISURERVY9eQoKIwojIFNwZWNpYWwgSElEIGRyaXZlcnMKIwpDT05GSUdfSElEX0E0
VEVDSD15CkNPTkZJR19ISURfQVBQTEU9eQpDT05GSUdfSElEX0JFTEtJTj15CkNPTkZJR19ISURf
Q0hFUlJZPXkKQ09ORklHX0hJRF9DSElDT05ZPXkKQ09ORklHX0hJRF9DWVBSRVNTPXkKQ09ORklH
X0hJRF9EUkFHT05SSVNFPXkKIyBDT05GSUdfRFJBR09OUklTRV9GRiBpcyBub3Qgc2V0CkNPTkZJ
R19ISURfRVpLRVk9eQpDT05GSUdfSElEX0tZRT15CkNPTkZJR19ISURfR1lSQVRJT049eQpDT05G
SUdfSElEX1RXSU5IQU49eQpDT05GSUdfSElEX0tFTlNJTkdUT049eQpDT05GSUdfSElEX0xPR0lU
RUNIPXkKQ09ORklHX0xPR0lURUNIX0ZGPXkKIyBDT05GSUdfTE9HSVJVTUJMRVBBRDJfRkYgaXMg
bm90IHNldApDT05GSUdfSElEX01JQ1JPU09GVD15CkNPTkZJR19ISURfTU9OVEVSRVk9eQpDT05G
SUdfSElEX05UUklHPXkKQ09ORklHX0hJRF9QQU5USEVSTE9SRD15CiMgQ09ORklHX1BBTlRIRVJM
T1JEX0ZGIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9QRVRBTFlOWD15CkNPTkZJR19ISURfU0FNU1VO
Rz15CkNPTkZJR19ISURfU09OWT15CkNPTkZJR19ISURfU1VOUExVUz15CkNPTkZJR19ISURfR1JF
RU5BU0lBPXkKIyBDT05GSUdfR1JFRU5BU0lBX0ZGIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9TTUFS
VEpPWVBMVVM9eQojIENPTkZJR19TTUFSVEpPWVBMVVNfRkYgaXMgbm90IHNldApDT05GSUdfSElE
X1RPUFNFRUQ9eQpDT05GSUdfSElEX1RIUlVTVE1BU1RFUj15CkNPTkZJR19USFJVU1RNQVNURVJf
RkY9eQpDT05GSUdfSElEX1dBQ09NPW0KQ09ORklHX0hJRF9aRVJPUExVUz15CiMgQ09ORklHX1pF
Uk9QTFVTX0ZGIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9TVVBQT1JUPXkKQ09ORklHX1VTQl9BUkNI
X0hBU19IQ0Q9eQpDT05GSUdfVVNCX0FSQ0hfSEFTX09IQ0k9eQpDT05GSUdfVVNCX0FSQ0hfSEFT
X0VIQ0k9eQpDT05GSUdfVVNCPXkKIyBDT05GSUdfVVNCX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX0FOTk9VTkNFX05FV19ERVZJQ0VTIGlzIG5vdCBzZXQKCiMKIyBNaXNjZWxsYW5lb3Vz
IFVTQiBvcHRpb25zCiMKQ09ORklHX1VTQl9ERVZJQ0VGUz15CkNPTkZJR19VU0JfREVWSUNFX0NM
QVNTPXkKIyBDT05GSUdfVVNCX0RZTkFNSUNfTUlOT1JTIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNC
X1NVU1BFTkQgaXMgbm90IHNldAojIENPTkZJR19VU0JfT1RHIGlzIG5vdCBzZXQKQ09ORklHX1VT
Ql9NT049eQojIENPTkZJR19VU0JfV1VTQiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9XVVNCX0NC
QUYgaXMgbm90IHNldAoKIwojIFVTQiBIb3N0IENvbnRyb2xsZXIgRHJpdmVycwojCiMgQ09ORklH
X1VTQl9DNjdYMDBfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1hIQ0lfSENEIGlzIG5vdCBz
ZXQKQ09ORklHX1VTQl9FSENJX0hDRD1tCkNPTkZJR19VU0JfRUhDSV9ST09UX0hVQl9UVD15CkNP
TkZJR19VU0JfRUhDSV9UVF9ORVdTQ0hFRD15CiMgQ09ORklHX1VTQl9PWFUyMTBIUF9IQ0QgaXMg
bm90IHNldApDT05GSUdfVVNCX0lTUDExNlhfSENEPW0KIyBDT05GSUdfVVNCX0lTUDE3NjBfSENE
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0lTUDEzNjJfSENEIGlzIG5vdCBzZXQKQ09ORklHX1VT
Ql9PSENJX0hDRD1tCiMgQ09ORklHX1VTQl9PSENJX0hDRF9TU0IgaXMgbm90IHNldAojIENPTkZJ
R19VU0JfT0hDSV9CSUdfRU5ESUFOX0RFU0MgaXMgbm90IHNldAojIENPTkZJR19VU0JfT0hDSV9C
SUdfRU5ESUFOX01NSU8gaXMgbm90IHNldApDT05GSUdfVVNCX09IQ0lfTElUVExFX0VORElBTj15
CkNPTkZJR19VU0JfVUhDSV9IQ0Q9bQpDT05GSUdfVVNCX1NMODExX0hDRD1tCkNPTkZJR19VU0Jf
U0w4MTFfQ1M9bQojIENPTkZJR19VU0JfUjhBNjY1OTdfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX1dIQ0lfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0hXQV9IQ0QgaXMgbm90IHNldAoK
IwojIFVTQiBEZXZpY2UgQ2xhc3MgZHJpdmVycwojCkNPTkZJR19VU0JfQUNNPW0KQ09ORklHX1VT
Ql9QUklOVEVSPW0KIyBDT05GSUdfVVNCX1dETSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9UTUMg
aXMgbm90IHNldAoKIwojIE5PVEU6IFVTQl9TVE9SQUdFIGRlcGVuZHMgb24gU0NTSSBidXQgQkxL
X0RFVl9TRCBtYXkKIwoKIwojIGFsc28gYmUgbmVlZGVkOyBzZWUgVVNCX1NUT1JBR0UgSGVscCBm
b3IgbW9yZSBpbmZvCiMKQ09ORklHX1VTQl9TVE9SQUdFPW0KIyBDT05GSUdfVVNCX1NUT1JBR0Vf
REVCVUcgaXMgbm90IHNldApDT05GSUdfVVNCX1NUT1JBR0VfREFUQUZBQj1tCkNPTkZJR19VU0Jf
U1RPUkFHRV9GUkVFQ09NPW0KQ09ORklHX1VTQl9TVE9SQUdFX0lTRDIwMD1tCkNPTkZJR19VU0Jf
U1RPUkFHRV9VU0JBVD1tCkNPTkZJR19VU0JfU1RPUkFHRV9TRERSMDk9bQpDT05GSUdfVVNCX1NU
T1JBR0VfU0REUjU1PW0KQ09ORklHX1VTQl9TVE9SQUdFX0pVTVBTSE9UPW0KQ09ORklHX1VTQl9T
VE9SQUdFX0FMQVVEQT1tCiMgQ09ORklHX1VTQl9TVE9SQUdFX09ORVRPVUNIIGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX1NUT1JBR0VfS0FSTUEgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFH
RV9DWVBSRVNTX0FUQUNCIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0xJQlVTVUFMIGlzIG5vdCBz
ZXQKCiMKIyBVU0IgSW1hZ2luZyBkZXZpY2VzCiMKQ09ORklHX1VTQl9NREM4MDA9bQpDT05GSUdf
VVNCX01JQ1JPVEVLPW0KCiMKIyBVU0IgcG9ydCBkcml2ZXJzCiMKQ09ORklHX1VTQl9VU1M3MjA9
bQpDT05GSUdfVVNCX1NFUklBTD1tCkNPTkZJR19VU0JfRVpVU0I9eQpDT05GSUdfVVNCX1NFUklB
TF9HRU5FUklDPXkKIyBDT05GSUdfVVNCX1NFUklBTF9BSVJDQUJMRSBpcyBub3Qgc2V0CkNPTkZJ
R19VU0JfU0VSSUFMX0FSSzMxMTY9bQpDT05GSUdfVVNCX1NFUklBTF9CRUxLSU49bQojIENPTkZJ
R19VU0JfU0VSSUFMX0NIMzQxIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9TRVJJQUxfV0hJVEVIRUFU
PW0KQ09ORklHX1VTQl9TRVJJQUxfRElHSV9BQ0NFTEVQT1JUPW0KIyBDT05GSUdfVVNCX1NFUklB
TF9DUDIxMFggaXMgbm90IHNldApDT05GSUdfVVNCX1NFUklBTF9DWVBSRVNTX004PW0KQ09ORklH
X1VTQl9TRVJJQUxfRU1QRUc9bQpDT05GSUdfVVNCX1NFUklBTF9GVERJX1NJTz1tCkNPTkZJR19V
U0JfU0VSSUFMX0ZVTlNPRlQ9bQpDT05GSUdfVVNCX1NFUklBTF9WSVNPUj1tCkNPTkZJR19VU0Jf
U0VSSUFMX0lQQVE9bQpDT05GSUdfVVNCX1NFUklBTF9JUj1tCkNPTkZJR19VU0JfU0VSSUFMX0VE
R0VQT1JUPW0KQ09ORklHX1VTQl9TRVJJQUxfRURHRVBPUlRfVEk9bQpDT05GSUdfVVNCX1NFUklB
TF9HQVJNSU49bQpDT05GSUdfVVNCX1NFUklBTF9JUFc9bQojIENPTkZJR19VU0JfU0VSSUFMX0lV
VSBpcyBub3Qgc2V0CkNPTkZJR19VU0JfU0VSSUFMX0tFWVNQQU5fUERBPW0KQ09ORklHX1VTQl9T
RVJJQUxfS0VZU1BBTj1tCkNPTkZJR19VU0JfU0VSSUFMX0tFWVNQQU5fTVBSPXkKQ09ORklHX1VT
Ql9TRVJJQUxfS0VZU1BBTl9VU0EyOD15CkNPTkZJR19VU0JfU0VSSUFMX0tFWVNQQU5fVVNBMjhY
PXkKQ09ORklHX1VTQl9TRVJJQUxfS0VZU1BBTl9VU0EyOFhBPXkKQ09ORklHX1VTQl9TRVJJQUxf
S0VZU1BBTl9VU0EyOFhCPXkKQ09ORklHX1VTQl9TRVJJQUxfS0VZU1BBTl9VU0ExOT15CkNPTkZJ
R19VU0JfU0VSSUFMX0tFWVNQQU5fVVNBMThYPXkKQ09ORklHX1VTQl9TRVJJQUxfS0VZU1BBTl9V
U0ExOVc9eQpDT05GSUdfVVNCX1NFUklBTF9LRVlTUEFOX1VTQTE5UVc9eQpDT05GSUdfVVNCX1NF
UklBTF9LRVlTUEFOX1VTQTE5UUk9eQpDT05GSUdfVVNCX1NFUklBTF9LRVlTUEFOX1VTQTQ5Vz15
CkNPTkZJR19VU0JfU0VSSUFMX0tFWVNQQU5fVVNBNDlXTEM9eQpDT05GSUdfVVNCX1NFUklBTF9L
TFNJPW0KQ09ORklHX1VTQl9TRVJJQUxfS09CSUxfU0NUPW0KQ09ORklHX1VTQl9TRVJJQUxfTUNU
X1UyMzI9bQojIENPTkZJR19VU0JfU0VSSUFMX01PUzc3MjAgaXMgbm90IHNldAojIENPTkZJR19V
U0JfU0VSSUFMX01PUzc4NDAgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX01PVE9ST0xB
IGlzIG5vdCBzZXQKQ09ORklHX1VTQl9TRVJJQUxfTkFWTUFOPW0KQ09ORklHX1VTQl9TRVJJQUxf
UEwyMzAzPW0KIyBDT05GSUdfVVNCX1NFUklBTF9PVEk2ODU4IGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX1NFUklBTF9RVUFMQ09NTSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfU1BDUDhY
NSBpcyBub3Qgc2V0CkNPTkZJR19VU0JfU0VSSUFMX0hQNFg9bQpDT05GSUdfVVNCX1NFUklBTF9T
QUZFPW0KQ09ORklHX1VTQl9TRVJJQUxfU0FGRV9QQURERUQ9eQojIENPTkZJR19VU0JfU0VSSUFM
X1NJRU1FTlNfTVBJIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9TRVJJQUxfU0lFUlJBV0lSRUxFU1M9
bQojIENPTkZJR19VU0JfU0VSSUFMX1NZTUJPTCBpcyBub3Qgc2V0CkNPTkZJR19VU0JfU0VSSUFM
X1RJPW0KQ09ORklHX1VTQl9TRVJJQUxfQ1lCRVJKQUNLPW0KQ09ORklHX1VTQl9TRVJJQUxfWElS
Q09NPW0KQ09ORklHX1VTQl9TRVJJQUxfT1BUSU9OPW0KQ09ORklHX1VTQl9TRVJJQUxfT01OSU5F
VD1tCiMgQ09ORklHX1VTQl9TRVJJQUxfT1BUSUNPTiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9T
RVJJQUxfREVCVUcgaXMgbm90IHNldAoKIwojIFVTQiBNaXNjZWxsYW5lb3VzIGRyaXZlcnMKIwpD
T05GSUdfVVNCX0VNSTYyPW0KQ09ORklHX1VTQl9FTUkyNj1tCiMgQ09ORklHX1VTQl9BRFVUVVgg
aXMgbm90IHNldAojIENPTkZJR19VU0JfU0VWU0VHIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9SSU81
MDA9bQpDT05GSUdfVVNCX0xFR09UT1dFUj1tCkNPTkZJR19VU0JfTENEPW0KIyBDT05GSUdfVVNC
X0JFUlJZX0NIQVJHRSBpcyBub3Qgc2V0CkNPTkZJR19VU0JfTEVEPW0KIyBDT05GSUdfVVNCX0NZ
UFJFU1NfQ1k3QzYzIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0NZVEhFUk0gaXMgbm90IHNldApD
T05GSUdfVVNCX0lETU9VU0U9bQojIENPTkZJR19VU0JfRlRESV9FTEFOIGlzIG5vdCBzZXQKQ09O
RklHX1VTQl9BUFBMRURJU1BMQVk9bQpDT05GSUdfVVNCX1NJU1VTQlZHQT1tCkNPTkZJR19VU0Jf
U0lTVVNCVkdBX0NPTj15CkNPTkZJR19VU0JfTEQ9bQojIENPTkZJR19VU0JfVFJBTkNFVklCUkFU
T1IgaXMgbm90IHNldAojIENPTkZJR19VU0JfSU9XQVJSSU9SIGlzIG5vdCBzZXQKQ09ORklHX1VT
Ql9URVNUPW0KIyBDT05GSUdfVVNCX0lTSUdIVEZXIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1ZT
VCBpcyBub3Qgc2V0CkNPTkZJR19VU0JfQVRNPW0KQ09ORklHX1VTQl9TUEVFRFRPVUNIPW0KQ09O
RklHX1VTQl9DWEFDUlU9bQpDT05GSUdfVVNCX1VFQUdMRUFUTT1tCkNPTkZJR19VU0JfWFVTQkFU
TT1tCiMgQ09ORklHX1VTQl9HQURHRVQgaXMgbm90IHNldAoKIwojIE9URyBhbmQgcmVsYXRlZCBp
bmZyYXN0cnVjdHVyZQojCiMgQ09ORklHX05PUF9VU0JfWENFSVYgaXMgbm90IHNldAojIENPTkZJ
R19VV0IgaXMgbm90IHNldApDT05GSUdfTU1DPW0KIyBDT05GSUdfTU1DX0RFQlVHIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTU1DX1VOU0FGRV9SRVNVTUUgaXMgbm90IHNldAoKIwojIE1NQy9TRC9TRElP
IENhcmQgRHJpdmVycwojCkNPTkZJR19NTUNfQkxPQ0s9bQpDT05GSUdfTU1DX0JMT0NLX0JPVU5D
RT15CiMgQ09ORklHX1NESU9fVUFSVCBpcyBub3Qgc2V0CiMgQ09ORklHX01NQ19URVNUIGlzIG5v
dCBzZXQKCiMKIyBNTUMvU0QvU0RJTyBIb3N0IENvbnRyb2xsZXIgRHJpdmVycwojCkNPTkZJR19N
TUNfU0RIQ0k9bQojIENPTkZJR19NTUNfU0RIQ0lfUENJIGlzIG5vdCBzZXQKIyBDT05GSUdfTU1D
X1NESENJX1BMVEZNIGlzIG5vdCBzZXQKQ09ORklHX01NQ19XQlNEPW0KIyBDT05GSUdfTU1DX0FU
OTEgaXMgbm90IHNldAojIENPTkZJR19NTUNfQVRNRUxNQ0kgaXMgbm90IHNldAojIENPTkZJR19N
TUNfVElGTV9TRCBpcyBub3Qgc2V0CiMgQ09ORklHX01NQ19TRFJJQ09IX0NTIGlzIG5vdCBzZXQK
IyBDT05GSUdfTU1DX0NCNzEwIGlzIG5vdCBzZXQKIyBDT05GSUdfTU1DX1ZJQV9TRE1NQyBpcyBu
b3Qgc2V0CiMgQ09ORklHX01FTVNUSUNLIGlzIG5vdCBzZXQKQ09ORklHX05FV19MRURTPXkKQ09O
RklHX0xFRFNfQ0xBU1M9eQoKIwojIExFRCBkcml2ZXJzCiMKIyBDT05GSUdfTEVEU19BTElYMiBp
cyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfUENBOTUzMiBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNf
TFAzOTQ0IGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19DTEVWT19NQUlMIGlzIG5vdCBzZXQKIyBD
T05GSUdfTEVEU19QQ0E5NTVYIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19CRDI4MDIgaXMgbm90
IHNldAoKIwojIExFRCBUcmlnZ2VycwojCkNPTkZJR19MRURTX1RSSUdHRVJTPXkKQ09ORklHX0xF
RFNfVFJJR0dFUl9USU1FUj1tCkNPTkZJR19MRURTX1RSSUdHRVJfSURFX0RJU0s9eQpDT05GSUdf
TEVEU19UUklHR0VSX0hFQVJUQkVBVD1tCiMgQ09ORklHX0xFRFNfVFJJR0dFUl9CQUNLTElHSFQg
aXMgbm90IHNldAojIENPTkZJR19MRURTX1RSSUdHRVJfREVGQVVMVF9PTiBpcyBub3Qgc2V0Cgoj
CiMgaXB0YWJsZXMgdHJpZ2dlciBpcyB1bmRlciBOZXRmaWx0ZXIgY29uZmlnIChMRUQgdGFyZ2V0
KQojCiMgQ09ORklHX0FDQ0VTU0lCSUxJVFkgaXMgbm90IHNldApDT05GSUdfSU5GSU5JQkFORD1t
CkNPTkZJR19JTkZJTklCQU5EX1VTRVJfTUFEPW0KQ09ORklHX0lORklOSUJBTkRfVVNFUl9BQ0NF
U1M9bQpDT05GSUdfSU5GSU5JQkFORF9VU0VSX01FTT15CkNPTkZJR19JTkZJTklCQU5EX0FERFJf
VFJBTlM9eQpDT05GSUdfSU5GSU5JQkFORF9NVEhDQT1tCkNPTkZJR19JTkZJTklCQU5EX01USENB
X0RFQlVHPXkKQ09ORklHX0lORklOSUJBTkRfQU1TTzExMDA9bQojIENPTkZJR19JTkZJTklCQU5E
X0FNU08xMTAwX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0lORklOSUJBTkRfQ1hHQjM9bQojIENP
TkZJR19JTkZJTklCQU5EX0NYR0IzX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfTUxYNF9JTkZJ
TklCQU5EIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5GSU5JQkFORF9ORVMgaXMgbm90IHNldApDT05G
SUdfSU5GSU5JQkFORF9JUE9JQj1tCiMgQ09ORklHX0lORklOSUJBTkRfSVBPSUJfQ00gaXMgbm90
IHNldApDT05GSUdfSU5GSU5JQkFORF9JUE9JQl9ERUJVRz15CiMgQ09ORklHX0lORklOSUJBTkRf
SVBPSUJfREVCVUdfREFUQSBpcyBub3Qgc2V0CkNPTkZJR19JTkZJTklCQU5EX1NSUD1tCkNPTkZJ
R19JTkZJTklCQU5EX0lTRVI9bQpDT05GSUdfRURBQz15CgojCiMgUmVwb3J0aW5nIHN1YnN5c3Rl
bXMKIwojIENPTkZJR19FREFDX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0VEQUNfREVDT0RFX01D
RT15CkNPTkZJR19FREFDX01NX0VEQUM9bQpDT05GSUdfRURBQ19BTUQ3Nlg9bQpDT05GSUdfRURB
Q19FN1hYWD1tCkNPTkZJR19FREFDX0U3NTJYPW0KQ09ORklHX0VEQUNfSTgyODc1UD1tCiMgQ09O
RklHX0VEQUNfSTgyOTc1WCBpcyBub3Qgc2V0CiMgQ09ORklHX0VEQUNfSTMwMDAgaXMgbm90IHNl
dAojIENPTkZJR19FREFDX0kzMjAwIGlzIG5vdCBzZXQKIyBDT05GSUdfRURBQ19YMzggaXMgbm90
IHNldAojIENPTkZJR19FREFDX0k1NDAwIGlzIG5vdCBzZXQKQ09ORklHX0VEQUNfSTgyODYwPW0K
Q09ORklHX0VEQUNfUjgyNjAwPW0KIyBDT05GSUdfRURBQ19JNTAwMCBpcyBub3Qgc2V0CiMgQ09O
RklHX0VEQUNfSTUxMDAgaXMgbm90IHNldApDT05GSUdfUlRDX0xJQj1tCkNPTkZJR19SVENfQ0xB
U1M9bQoKIwojIFJUQyBpbnRlcmZhY2VzCiMKQ09ORklHX1JUQ19JTlRGX1NZU0ZTPXkKQ09ORklH
X1JUQ19JTlRGX1BST0M9eQpDT05GSUdfUlRDX0lOVEZfREVWPXkKIyBDT05GSUdfUlRDX0lOVEZf
REVWX1VJRV9FTVVMIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9URVNUIGlzIG5vdCBzZXQK
CiMKIyBJMkMgUlRDIGRyaXZlcnMKIwpDT05GSUdfUlRDX0RSVl9EUzEzMDc9bQojIENPTkZJR19S
VENfRFJWX0RTMTM3NCBpcyBub3Qgc2V0CkNPTkZJR19SVENfRFJWX0RTMTY3Mj1tCiMgQ09ORklH
X1JUQ19EUlZfTUFYNjkwMCBpcyBub3Qgc2V0CkNPTkZJR19SVENfRFJWX1JTNUMzNzI9bQpDT05G
SUdfUlRDX0RSVl9JU0wxMjA4PW0KQ09ORklHX1JUQ19EUlZfWDEyMDU9bQpDT05GSUdfUlRDX0RS
Vl9QQ0Y4NTYzPW0KQ09ORklHX1JUQ19EUlZfUENGODU4Mz1tCiMgQ09ORklHX1JUQ19EUlZfTTQx
VDgwIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9TMzUzOTBBIGlzIG5vdCBzZXQKIyBDT05G
SUdfUlRDX0RSVl9GTTMxMzAgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1JYODU4MSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUlg4MDI1IGlzIG5vdCBzZXQKCiMKIyBTUEkgUlRDIGRy
aXZlcnMKIwoKIwojIFBsYXRmb3JtIFJUQyBkcml2ZXJzCiMKQ09ORklHX1JUQ19EUlZfQ01PUz1t
CiMgQ09ORklHX1JUQ19EUlZfRFMxMjg2IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9EUzE1
MTEgaXMgbm90IHNldApDT05GSUdfUlRDX0RSVl9EUzE1NTM9bQpDT05GSUdfUlRDX0RSVl9EUzE3
NDI9bQojIENPTkZJR19SVENfRFJWX1NUSzE3VEE4IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RS
Vl9NNDhUODYgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX000OFQzNSBpcyBub3Qgc2V0CiMg
Q09ORklHX1JUQ19EUlZfTTQ4VDU5IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9CUTQ4MDIg
aXMgbm90IHNldApDT05GSUdfUlRDX0RSVl9WMzAyMD1tCgojCiMgb24tQ1BVIFJUQyBkcml2ZXJz
CiMKIyBDT05GSUdfRE1BREVWSUNFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0FVWERJU1BMQVkgaXMg
bm90IHNldAojIENPTkZJR19VSU8gaXMgbm90IHNldAoKIwojIFRJIFZMWU5RCiMKIyBDT05GSUdf
U1RBR0lORyBpcyBub3Qgc2V0CkNPTkZJR19YODZfUExBVEZPUk1fREVWSUNFUz15CiMgQ09ORklH
X0FDRVJfV01JIGlzIG5vdCBzZXQKIyBDT05GSUdfQVNVU19MQVBUT1AgaXMgbm90IHNldAojIENP
TkZJR19GVUpJVFNVX0xBUFRPUCBpcyBub3Qgc2V0CiMgQ09ORklHX1RDMTEwMF9XTUkgaXMgbm90
IHNldAojIENPTkZJR19NU0lfTEFQVE9QIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFOQVNPTklDX0xB
UFRPUCBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTVBBTF9MQVBUT1AgaXMgbm90IHNldAojIENPTkZJ
R19USElOS1BBRF9BQ1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5URUxfTUVOTE9XIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRUVFUENfTEFQVE9QIGlzIG5vdCBzZXQKIyBDT05GSUdfQUNQSV9XTUkgaXMg
bm90IHNldApDT05GSUdfQUNQSV9BU1VTPW0KIyBDT05GSUdfVE9QU1RBUl9MQVBUT1AgaXMgbm90
IHNldApDT05GSUdfQUNQSV9UT1NISUJBPW0KCiMKIyBGaXJtd2FyZSBEcml2ZXJzCiMKQ09ORklH
X0VERD1tCiMgQ09ORklHX0VERF9PRkYgaXMgbm90IHNldApDT05GSUdfRklSTVdBUkVfTUVNTUFQ
PXkKQ09ORklHX0VGSV9WQVJTPXkKQ09ORklHX0RFTExfUkJVPW0KQ09ORklHX0RDREJBUz1tCkNP
TkZJR19ETUlJRD15CiMgQ09ORklHX0lTQ1NJX0lCRlRfRklORCBpcyBub3Qgc2V0CgojCiMgRmls
ZSBzeXN0ZW1zCiMKQ09ORklHX0VYVDJfRlM9eQpDT05GSUdfRVhUMl9GU19YQVRUUj15CkNPTkZJ
R19FWFQyX0ZTX1BPU0lYX0FDTD15CkNPTkZJR19FWFQyX0ZTX1NFQ1VSSVRZPXkKQ09ORklHX0VY
VDJfRlNfWElQPXkKQ09ORklHX0VYVDNfRlM9bQojIENPTkZJR19FWFQzX0RFRkFVTFRTX1RPX09S
REVSRUQgaXMgbm90IHNldApDT05GSUdfRVhUM19GU19YQVRUUj15CkNPTkZJR19FWFQzX0ZTX1BP
U0lYX0FDTD15CkNPTkZJR19FWFQzX0ZTX1NFQ1VSSVRZPXkKIyBDT05GSUdfRVhUNF9GUyBpcyBu
b3Qgc2V0CkNPTkZJR19GU19YSVA9eQpDT05GSUdfSkJEPW0KIyBDT05GSUdfSkJEX0RFQlVHIGlz
IG5vdCBzZXQKQ09ORklHX0ZTX01CQ0FDSEU9eQojIENPTkZJR19SRUlTRVJGU19GUyBpcyBub3Qg
c2V0CiMgQ09ORklHX0pGU19GUyBpcyBub3Qgc2V0CkNPTkZJR19GU19QT1NJWF9BQ0w9eQojIENP
TkZJR19YRlNfRlMgaXMgbm90IHNldApDT05GSUdfR0ZTMl9GUz1tCiMgQ09ORklHX0dGUzJfRlNf
TE9DS0lOR19ETE0gaXMgbm90IHNldAojIENPTkZJR19PQ0ZTMl9GUyBpcyBub3Qgc2V0CiMgQ09O
RklHX0JUUkZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfTklMRlMyX0ZTIGlzIG5vdCBzZXQKQ09O
RklHX0ZJTEVfTE9DS0lORz15CkNPTkZJR19GU05PVElGWT15CkNPTkZJR19ETk9USUZZPXkKQ09O
RklHX0lOT1RJRlk9eQpDT05GSUdfSU5PVElGWV9VU0VSPXkKQ09ORklHX1FVT1RBPXkKIyBDT05G
SUdfUVVPVEFfTkVUTElOS19JTlRFUkZBQ0UgaXMgbm90IHNldApDT05GSUdfUFJJTlRfUVVPVEFf
V0FSTklORz15CkNPTkZJR19RVU9UQV9UUkVFPXkKIyBDT05GSUdfUUZNVF9WMSBpcyBub3Qgc2V0
CkNPTkZJR19RRk1UX1YyPXkKQ09ORklHX1FVT1RBQ1RMPXkKIyBDT05GSUdfQVVUT0ZTX0ZTIGlz
IG5vdCBzZXQKQ09ORklHX0FVVE9GUzRfRlM9bQojIENPTkZJR19GVVNFX0ZTIGlzIG5vdCBzZXQK
CiMKIyBDYWNoZXMKIwpDT05GSUdfRlNDQUNIRT1tCiMgQ09ORklHX0ZTQ0FDSEVfU1RBVFMgaXMg
bm90IHNldAojIENPTkZJR19GU0NBQ0hFX0hJU1RPR1JBTSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZT
Q0FDSEVfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19GU0NBQ0hFX09CSkVDVF9MSVNUIGlzIG5v
dCBzZXQKQ09ORklHX0NBQ0hFRklMRVM9bQpDT05GSUdfQ0FDSEVGSUxFU19ERUJVRz15CiMgQ09O
RklHX0NBQ0hFRklMRVNfSElTVE9HUkFNIGlzIG5vdCBzZXQKCiMKIyBDRC1ST00vRFZEIEZpbGVz
eXN0ZW1zCiMKQ09ORklHX0lTTzk2NjBfRlM9eQpDT05GSUdfSk9MSUVUPXkKQ09ORklHX1pJU09G
Uz15CkNPTkZJR19VREZfRlM9bQpDT05GSUdfVURGX05MUz15CgojCiMgRE9TL0ZBVC9OVCBGaWxl
c3lzdGVtcwojCkNPTkZJR19GQVRfRlM9bQpDT05GSUdfTVNET1NfRlM9bQpDT05GSUdfVkZBVF9G
Uz1tCkNPTkZJR19GQVRfREVGQVVMVF9DT0RFUEFHRT00MzcKQ09ORklHX0ZBVF9ERUZBVUxUX0lP
Q0hBUlNFVD0iYXNjaWkiCkNPTkZJR19OVEZTX0ZTPW0KIyBDT05GSUdfTlRGU19ERUJVRyBpcyBu
b3Qgc2V0CiMgQ09ORklHX05URlNfUlcgaXMgbm90IHNldAoKIwojIFBzZXVkbyBmaWxlc3lzdGVt
cwojCkNPTkZJR19QUk9DX0ZTPXkKQ09ORklHX1BST0NfS0NPUkU9eQpDT05GSUdfUFJPQ19WTUNP
UkU9eQpDT05GSUdfUFJPQ19TWVNDVEw9eQpDT05GSUdfUFJPQ19QQUdFX01PTklUT1I9eQpDT05G
SUdfU1lTRlM9eQpDT05GSUdfVE1QRlM9eQojIENPTkZJR19UTVBGU19QT1NJWF9BQ0wgaXMgbm90
IHNldApDT05GSUdfSFVHRVRMQkZTPXkKQ09ORklHX0hVR0VUTEJfUEFHRT15CkNPTkZJR19DT05G
SUdGU19GUz1tCkNPTkZJR19NSVNDX0ZJTEVTWVNURU1TPXkKIyBDT05GSUdfQURGU19GUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0FGRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19FQ1JZUFRfRlMgaXMg
bm90IHNldApDT05GSUdfSEZTX0ZTPW0KQ09ORklHX0hGU1BMVVNfRlM9bQojIENPTkZJR19CRUZT
X0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQkZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfRUZTX0ZT
IGlzIG5vdCBzZXQKQ09ORklHX0pGRlMyX0ZTPW0KQ09ORklHX0pGRlMyX0ZTX0RFQlVHPTAKQ09O
RklHX0pGRlMyX0ZTX1dSSVRFQlVGRkVSPXkKIyBDT05GSUdfSkZGUzJfRlNfV0JVRl9WRVJJRlkg
aXMgbm90IHNldApDT05GSUdfSkZGUzJfU1VNTUFSWT15CiMgQ09ORklHX0pGRlMyX0ZTX1hBVFRS
IGlzIG5vdCBzZXQKIyBDT05GSUdfSkZGUzJfQ09NUFJFU1NJT05fT1BUSU9OUyBpcyBub3Qgc2V0
CkNPTkZJR19KRkZTMl9aTElCPXkKIyBDT05GSUdfSkZGUzJfTFpPIGlzIG5vdCBzZXQKQ09ORklH
X0pGRlMyX1JUSU1FPXkKIyBDT05GSUdfSkZGUzJfUlVCSU4gaXMgbm90IHNldApDT05GSUdfQ1JB
TUZTPW0KQ09ORklHX1NRVUFTSEZTPW0KIyBDT05GSUdfU1FVQVNIRlNfRU1CRURERUQgaXMgbm90
IHNldApDT05GSUdfU1FVQVNIRlNfRlJBR01FTlRfQ0FDSEVfU0laRT0zCkNPTkZJR19WWEZTX0ZT
PW0KIyBDT05GSUdfTUlOSVhfRlMgaXMgbm90IHNldAojIENPTkZJR19PTUZTX0ZTIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSFBGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1FOWDRGU19GUyBpcyBub3Qg
c2V0CiMgQ09ORklHX1JPTUZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfU1lTVl9GUyBpcyBub3Qg
c2V0CiMgQ09ORklHX1VGU19GUyBpcyBub3Qgc2V0CkNPTkZJR19ORVRXT1JLX0ZJTEVTWVNURU1T
PXkKQ09ORklHX05GU19GUz1tCkNPTkZJR19ORlNfVjM9eQpDT05GSUdfTkZTX1YzX0FDTD15CkNP
TkZJR19ORlNfVjQ9eQojIENPTkZJR19ORlNfVjRfMSBpcyBub3Qgc2V0CkNPTkZJR19ORlNfRlND
QUNIRT15CkNPTkZJR19ORlNEPW0KQ09ORklHX05GU0RfVjJfQUNMPXkKQ09ORklHX05GU0RfVjM9
eQpDT05GSUdfTkZTRF9WM19BQ0w9eQpDT05GSUdfTkZTRF9WND15CkNPTkZJR19MT0NLRD1tCkNP
TkZJR19MT0NLRF9WND15CkNPTkZJR19FWFBPUlRGUz1tCkNPTkZJR19ORlNfQUNMX1NVUFBPUlQ9
bQpDT05GSUdfTkZTX0NPTU1PTj15CkNPTkZJR19TVU5SUEM9bQpDT05GSUdfU1VOUlBDX0dTUz1t
CkNPTkZJR19TVU5SUENfWFBSVF9SRE1BPW0KQ09ORklHX1JQQ1NFQ19HU1NfS1JCNT1tCkNPTkZJ
R19SUENTRUNfR1NTX1NQS00zPW0KIyBDT05GSUdfU01CX0ZTIGlzIG5vdCBzZXQKQ09ORklHX0NJ
RlM9bQojIENPTkZJR19DSUZTX1NUQVRTIGlzIG5vdCBzZXQKQ09ORklHX0NJRlNfV0VBS19QV19I
QVNIPXkKIyBDT05GSUdfQ0lGU19VUENBTEwgaXMgbm90IHNldApDT05GSUdfQ0lGU19YQVRUUj15
CkNPTkZJR19DSUZTX1BPU0lYPXkKIyBDT05GSUdfQ0lGU19ERUJVRzIgaXMgbm90IHNldAojIENP
TkZJR19DSUZTX0RGU19VUENBTEwgaXMgbm90IHNldAojIENPTkZJR19DSUZTX0VYUEVSSU1FTlRB
TCBpcyBub3Qgc2V0CiMgQ09ORklHX05DUF9GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0NPREFfRlMg
aXMgbm90IHNldAojIENPTkZJR19BRlNfRlMgaXMgbm90IHNldAoKIwojIFBhcnRpdGlvbiBUeXBl
cwojCkNPTkZJR19QQVJUSVRJT05fQURWQU5DRUQ9eQojIENPTkZJR19BQ09STl9QQVJUSVRJT04g
aXMgbm90IHNldApDT05GSUdfT1NGX1BBUlRJVElPTj15CkNPTkZJR19BTUlHQV9QQVJUSVRJT049
eQojIENPTkZJR19BVEFSSV9QQVJUSVRJT04gaXMgbm90IHNldApDT05GSUdfTUFDX1BBUlRJVElP
Tj15CkNPTkZJR19NU0RPU19QQVJUSVRJT049eQpDT05GSUdfQlNEX0RJU0tMQUJFTD15CkNPTkZJ
R19NSU5JWF9TVUJQQVJUSVRJT049eQpDT05GSUdfU09MQVJJU19YODZfUEFSVElUSU9OPXkKQ09O
RklHX1VOSVhXQVJFX0RJU0tMQUJFTD15CiMgQ09ORklHX0xETV9QQVJUSVRJT04gaXMgbm90IHNl
dApDT05GSUdfU0dJX1BBUlRJVElPTj15CiMgQ09ORklHX1VMVFJJWF9QQVJUSVRJT04gaXMgbm90
IHNldApDT05GSUdfU1VOX1BBUlRJVElPTj15CkNPTkZJR19LQVJNQV9QQVJUSVRJT049eQpDT05G
SUdfRUZJX1BBUlRJVElPTj15CiMgQ09ORklHX1NZU1Y2OF9QQVJUSVRJT04gaXMgbm90IHNldApD
T05GSUdfTkxTPXkKQ09ORklHX05MU19ERUZBVUxUPSJ1dGY4IgpDT05GSUdfTkxTX0NPREVQQUdF
XzQzNz15CkNPTkZJR19OTFNfQ09ERVBBR0VfNzM3PW0KQ09ORklHX05MU19DT0RFUEFHRV83NzU9
bQpDT05GSUdfTkxTX0NPREVQQUdFXzg1MD1tCkNPTkZJR19OTFNfQ09ERVBBR0VfODUyPW0KQ09O
RklHX05MU19DT0RFUEFHRV84NTU9bQpDT05GSUdfTkxTX0NPREVQQUdFXzg1Nz1tCkNPTkZJR19O
TFNfQ09ERVBBR0VfODYwPW0KQ09ORklHX05MU19DT0RFUEFHRV84NjE9bQpDT05GSUdfTkxTX0NP
REVQQUdFXzg2Mj1tCkNPTkZJR19OTFNfQ09ERVBBR0VfODYzPW0KQ09ORklHX05MU19DT0RFUEFH
RV84NjQ9bQpDT05GSUdfTkxTX0NPREVQQUdFXzg2NT1tCkNPTkZJR19OTFNfQ09ERVBBR0VfODY2
PW0KQ09ORklHX05MU19DT0RFUEFHRV84Njk9bQpDT05GSUdfTkxTX0NPREVQQUdFXzkzNj1tCkNP
TkZJR19OTFNfQ09ERVBBR0VfOTUwPW0KQ09ORklHX05MU19DT0RFUEFHRV85MzI9bQpDT05GSUdf
TkxTX0NPREVQQUdFXzk0OT1tCkNPTkZJR19OTFNfQ09ERVBBR0VfODc0PW0KQ09ORklHX05MU19J
U084ODU5Xzg9bQpDT05GSUdfTkxTX0NPREVQQUdFXzEyNTA9bQpDT05GSUdfTkxTX0NPREVQQUdF
XzEyNTE9bQpDT05GSUdfTkxTX0FTQ0lJPXkKQ09ORklHX05MU19JU084ODU5XzE9bQpDT05GSUdf
TkxTX0lTTzg4NTlfMj1tCkNPTkZJR19OTFNfSVNPODg1OV8zPW0KQ09ORklHX05MU19JU084ODU5
XzQ9bQpDT05GSUdfTkxTX0lTTzg4NTlfNT1tCkNPTkZJR19OTFNfSVNPODg1OV82PW0KQ09ORklH
X05MU19JU084ODU5Xzc9bQpDT05GSUdfTkxTX0lTTzg4NTlfOT1tCkNPTkZJR19OTFNfSVNPODg1
OV8xMz1tCkNPTkZJR19OTFNfSVNPODg1OV8xND1tCkNPTkZJR19OTFNfSVNPODg1OV8xNT1tCkNP
TkZJR19OTFNfS09JOF9SPW0KQ09ORklHX05MU19LT0k4X1U9bQpDT05GSUdfTkxTX1VURjg9bQpD
T05GSUdfRExNPW0KQ09ORklHX0RMTV9ERUJVRz15CgojCiMgS2VybmVsIGhhY2tpbmcKIwpDT05G
SUdfVFJBQ0VfSVJRRkxBR1NfU1VQUE9SVD15CiMgQ09ORklHX1BSSU5US19USU1FIGlzIG5vdCBz
ZXQKQ09ORklHX0VOQUJMRV9XQVJOX0RFUFJFQ0FURUQ9eQpDT05GSUdfRU5BQkxFX01VU1RfQ0hF
Q0s9eQpDT05GSUdfRlJBTUVfV0FSTj0xMDI0CkNPTkZJR19NQUdJQ19TWVNSUT15CiMgQ09ORklH
X1NUUklQX0FTTV9TWU1TIGlzIG5vdCBzZXQKIyBDT05GSUdfVU5VU0VEX1NZTUJPTFMgaXMgbm90
IHNldApDT05GSUdfREVCVUdfRlM9eQojIENPTkZJR19IRUFERVJTX0NIRUNLIGlzIG5vdCBzZXQK
Q09ORklHX0RFQlVHX0tFUk5FTD15CiMgQ09ORklHX0RFQlVHX1NISVJRIGlzIG5vdCBzZXQKQ09O
RklHX0RFVEVDVF9TT0ZUTE9DS1VQPXkKIyBDT05GSUdfQk9PVFBBUkFNX1NPRlRMT0NLVVBfUEFO
SUMgaXMgbm90IHNldApDT05GSUdfQk9PVFBBUkFNX1NPRlRMT0NLVVBfUEFOSUNfVkFMVUU9MApD
T05GSUdfREVURUNUX0hVTkdfVEFTSz15CiMgQ09ORklHX0JPT1RQQVJBTV9IVU5HX1RBU0tfUEFO
SUMgaXMgbm90IHNldApDT05GSUdfQk9PVFBBUkFNX0hVTkdfVEFTS19QQU5JQ19WQUxVRT0wCkNP
TkZJR19TQ0hFRF9ERUJVRz15CkNPTkZJR19TQ0hFRFNUQVRTPXkKIyBDT05GSUdfVElNRVJfU1RB
VFMgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19PQkpFQ1RTIGlzIG5vdCBzZXQKIyBDT05GSUdf
REVCVUdfU0xBQiBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0tNRU1MRUFLIGlzIG5vdCBzZXQK
IyBDT05GSUdfREVCVUdfUlRfTVVURVhFUyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUX01VVEVYX1RF
U1RFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1NQSU5MT0NLIGlzIG5vdCBzZXQKIyBDT05G
SUdfREVCVUdfTVVURVhFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0xPQ0tfQUxMT0MgaXMg
bm90IHNldAojIENPTkZJR19QUk9WRV9MT0NLSU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfTE9DS19T
VEFUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfU1BJTkxPQ0tfU0xFRVAgaXMgbm90IHNldAoj
IENPTkZJR19ERUJVR19MT0NLSU5HX0FQSV9TRUxGVEVTVFMgaXMgbm90IHNldApDT05GSUdfU1RB
Q0tUUkFDRT15CiMgQ09ORklHX0RFQlVHX0tPQkpFQ1QgaXMgbm90IHNldApDT05GSUdfREVCVUdf
SElHSE1FTT15CkNPTkZJR19ERUJVR19CVUdWRVJCT1NFPXkKQ09ORklHX0RFQlVHX0lORk89eQoj
IENPTkZJR19ERUJVR19WTSBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1ZJUlRVQUwgaXMgbm90
IHNldAojIENPTkZJR19ERUJVR19XUklURUNPVU5UIGlzIG5vdCBzZXQKQ09ORklHX0RFQlVHX01F
TU9SWV9JTklUPXkKQ09ORklHX0RFQlVHX0xJU1Q9eQojIENPTkZJR19ERUJVR19TRyBpcyBub3Qg
c2V0CiMgQ09ORklHX0RFQlVHX05PVElGSUVSUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0NS
RURFTlRJQUxTIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfV0FOVF9GUkFNRV9QT0lOVEVSUz15CiMg
Q09ORklHX0ZSQU1FX1BPSU5URVIgaXMgbm90IHNldAojIENPTkZJR19CT09UX1BSSU5US19ERUxB
WSBpcyBub3Qgc2V0CiMgQ09ORklHX1JDVV9UT1JUVVJFX1RFU1QgaXMgbm90IHNldAojIENPTkZJ
R19SQ1VfQ1BVX1NUQUxMX0RFVEVDVE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfS1BST0JFU19TQU5J
VFlfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX0JBQ0tUUkFDRV9TRUxGX1RFU1QgaXMgbm90IHNl
dAojIENPTkZJR19ERUJVR19CTE9DS19FWFRfREVWVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVH
X0ZPUkNFX1dFQUtfUEVSX0NQVSBpcyBub3Qgc2V0CiMgQ09ORklHX0xLRFRNIGlzIG5vdCBzZXQK
IyBDT05GSUdfRkFVTFRfSU5KRUNUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfTEFURU5DWVRPUCBp
cyBub3Qgc2V0CiMgQ09ORklHX1NZU0NUTF9TWVNDQUxMX0NIRUNLIGlzIG5vdCBzZXQKIyBDT05G
SUdfREVCVUdfUEFHRUFMTE9DIGlzIG5vdCBzZXQKQ09ORklHX1VTRVJfU1RBQ0tUUkFDRV9TVVBQ
T1JUPXkKQ09ORklHX05PUF9UUkFDRVI9eQpDT05GSUdfSEFWRV9GVU5DVElPTl9UUkFDRVI9eQpD
T05GSUdfSEFWRV9GVU5DVElPTl9HUkFQSF9UUkFDRVI9eQpDT05GSUdfSEFWRV9GVU5DVElPTl9H
UkFQSF9GUF9URVNUPXkKQ09ORklHX0hBVkVfRlVOQ1RJT05fVFJBQ0VfTUNPVU5UX1RFU1Q9eQpD
T05GSUdfSEFWRV9EWU5BTUlDX0ZUUkFDRT15CkNPTkZJR19IQVZFX0ZUUkFDRV9NQ09VTlRfUkVD
T1JEPXkKQ09ORklHX0hBVkVfU1lTQ0FMTF9UUkFDRVBPSU5UUz15CkNPTkZJR19SSU5HX0JVRkZF
Uj15CkNPTkZJR19FVkVOVF9UUkFDSU5HPXkKQ09ORklHX0NPTlRFWFRfU1dJVENIX1RSQUNFUj15
CkNPTkZJR19SSU5HX0JVRkZFUl9BTExPV19TV0FQPXkKQ09ORklHX1RSQUNJTkc9eQpDT05GSUdf
R0VORVJJQ19UUkFDRVI9eQpDT05GSUdfVFJBQ0lOR19TVVBQT1JUPXkKQ09ORklHX0ZUUkFDRT15
CiMgQ09ORklHX0ZVTkNUSU9OX1RSQUNFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0lSUVNPRkZfVFJB
Q0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfU1lTUFJPRl9UUkFDRVIgaXMgbm90IHNldAojIENPTkZJ
R19TQ0hFRF9UUkFDRVIgaXMgbm90IHNldAojIENPTkZJR19GVFJBQ0VfU1lTQ0FMTFMgaXMgbm90
IHNldAojIENPTkZJR19CT09UX1RSQUNFUiBpcyBub3Qgc2V0CkNPTkZJR19CUkFOQ0hfUFJPRklM
RV9OT05FPXkKIyBDT05GSUdfUFJPRklMRV9BTk5PVEFURURfQlJBTkNIRVMgaXMgbm90IHNldAoj
IENPTkZJR19QUk9GSUxFX0FMTF9CUkFOQ0hFUyBpcyBub3Qgc2V0CiMgQ09ORklHX1BPV0VSX1RS
QUNFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1NUQUNLX1RSQUNFUiBpcyBub3Qgc2V0CiMgQ09ORklH
X0tNRU1UUkFDRSBpcyBub3Qgc2V0CiMgQ09ORklHX1dPUktRVUVVRV9UUkFDRVIgaXMgbm90IHNl
dApDT05GSUdfQkxLX0RFVl9JT19UUkFDRT15CiMgQ09ORklHX0ZUUkFDRV9TVEFSVFVQX1RFU1Qg
aXMgbm90IHNldAojIENPTkZJR19NTUlPVFJBQ0UgaXMgbm90IHNldAojIENPTkZJR19SSU5HX0JV
RkZFUl9CRU5DSE1BUksgaXMgbm90IHNldAojIENPTkZJR19QUk9WSURFX09IQ0kxMzk0X0RNQV9J
TklUIGlzIG5vdCBzZXQKIyBDT05GSUdfRklSRVdJUkVfT0hDSV9SRU1PVEVfRE1BIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRFlOQU1JQ19ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX0RNQV9BUElfREVC
VUcgaXMgbm90IHNldAojIENPTkZJR19TQU1QTEVTIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfQVJD
SF9LR0RCPXkKIyBDT05GSUdfS0dEQiBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX0FSQ0hfS01FTUNI
RUNLPXkKIyBDT05GSUdfU1RSSUNUX0RFVk1FTSBpcyBub3Qgc2V0CkNPTkZJR19YODZfVkVSQk9T
RV9CT09UVVA9eQpDT05GSUdfRUFSTFlfUFJJTlRLPXkKIyBDT05GSUdfRUFSTFlfUFJJTlRLX0RC
R1AgaXMgbm90IHNldApDT05GSUdfREVCVUdfU1RBQ0tPVkVSRkxPVz15CkNPTkZJR19ERUJVR19T
VEFDS19VU0FHRT15CiMgQ09ORklHX0RFQlVHX1BFUl9DUFVfTUFQUyBpcyBub3Qgc2V0CiMgQ09O
RklHX1g4Nl9QVERVTVAgaXMgbm90IHNldApDT05GSUdfREVCVUdfUk9EQVRBPXkKQ09ORklHX0RF
QlVHX1JPREFUQV9URVNUPXkKIyBDT05GSUdfREVCVUdfTlhfVEVTVCBpcyBub3Qgc2V0CkNPTkZJ
R180S1NUQUNLUz15CkNPTkZJR19ET1VCTEVGQVVMVD15CiMgQ09ORklHX0lPTU1VX1NUUkVTUyBp
cyBub3Qgc2V0CkNPTkZJR19IQVZFX01NSU9UUkFDRV9TVVBQT1JUPXkKQ09ORklHX0lPX0RFTEFZ
X1RZUEVfMFg4MD0wCkNPTkZJR19JT19ERUxBWV9UWVBFXzBYRUQ9MQpDT05GSUdfSU9fREVMQVlf
VFlQRV9VREVMQVk9MgpDT05GSUdfSU9fREVMQVlfVFlQRV9OT05FPTMKQ09ORklHX0lPX0RFTEFZ
XzBYODA9eQojIENPTkZJR19JT19ERUxBWV8wWEVEIGlzIG5vdCBzZXQKIyBDT05GSUdfSU9fREVM
QVlfVURFTEFZIGlzIG5vdCBzZXQKIyBDT05GSUdfSU9fREVMQVlfTk9ORSBpcyBub3Qgc2V0CkNP
TkZJR19ERUZBVUxUX0lPX0RFTEFZX1RZUEU9MAojIENPTkZJR19ERUJVR19CT09UX1BBUkFNUyBp
cyBub3Qgc2V0CiMgQ09ORklHX0NQQV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX09QVElNSVpF
X0lOTElOSU5HIGlzIG5vdCBzZXQKCiMKIyBTZWN1cml0eSBvcHRpb25zCiMKQ09ORklHX0tFWVM9
eQpDT05GSUdfS0VZU19ERUJVR19QUk9DX0tFWVM9eQpDT05GSUdfU0VDVVJJVFk9eQojIENPTkZJ
R19TRUNVUklUWUZTIGlzIG5vdCBzZXQKQ09ORklHX1NFQ1VSSVRZX05FVFdPUks9eQpDT05GSUdf
U0VDVVJJVFlfTkVUV09SS19YRlJNPXkKIyBDT05GSUdfU0VDVVJJVFlfUEFUSCBpcyBub3Qgc2V0
CiMgQ09ORklHX1NFQ1VSSVRZX0ZJTEVfQ0FQQUJJTElUSUVTIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0VDVVJJVFlfUk9PVFBMVUcgaXMgbm90IHNldApDT05GSUdfTFNNX01NQVBfTUlOX0FERFI9NjU1
MzYKQ09ORklHX1NFQ1VSSVRZX1NFTElOVVg9eQpDT05GSUdfU0VDVVJJVFlfU0VMSU5VWF9CT09U
UEFSQU09eQpDT05GSUdfU0VDVVJJVFlfU0VMSU5VWF9CT09UUEFSQU1fVkFMVUU9MQpDT05GSUdf
U0VDVVJJVFlfU0VMSU5VWF9ESVNBQkxFPXkKQ09ORklHX1NFQ1VSSVRZX1NFTElOVVhfREVWRUxP
UD15CkNPTkZJR19TRUNVUklUWV9TRUxJTlVYX0FWQ19TVEFUUz15CkNPTkZJR19TRUNVUklUWV9T
RUxJTlVYX0NIRUNLUkVRUFJPVF9WQUxVRT0xCiMgQ09ORklHX1NFQ1VSSVRZX1NFTElOVVhfUE9M
SUNZREJfVkVSU0lPTl9NQVggaXMgbm90IHNldAojIENPTkZJR19TRUNVUklUWV9TTUFDSyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFQ1VSSVRZX1RPTU9ZTyBpcyBub3Qgc2V0CiMgQ09ORklHX0lNQSBp
cyBub3Qgc2V0CkNPTkZJR19YT1JfQkxPQ0tTPW0KQ09ORklHX0FTWU5DX0NPUkU9bQpDT05GSUdf
QVNZTkNfTUVNQ1BZPW0KQ09ORklHX0FTWU5DX1hPUj1tCkNPTkZJR19BU1lOQ19QUT1tCkNPTkZJ
R19BU1lOQ19SQUlENl9SRUNPVj1tCkNPTkZJR19DUllQVE89eQoKIwojIENyeXB0byBjb3JlIG9y
IGhlbHBlcgojCiMgQ09ORklHX0NSWVBUT19GSVBTIGlzIG5vdCBzZXQKQ09ORklHX0NSWVBUT19B
TEdBUEk9eQpDT05GSUdfQ1JZUFRPX0FMR0FQSTI9eQpDT05GSUdfQ1JZUFRPX0FFQUQ9bQpDT05G
SUdfQ1JZUFRPX0FFQUQyPXkKQ09ORklHX0NSWVBUT19CTEtDSVBIRVI9bQpDT05GSUdfQ1JZUFRP
X0JMS0NJUEhFUjI9eQpDT05GSUdfQ1JZUFRPX0hBU0g9eQpDT05GSUdfQ1JZUFRPX0hBU0gyPXkK
Q09ORklHX0NSWVBUT19STkc9bQpDT05GSUdfQ1JZUFRPX1JORzI9eQpDT05GSUdfQ1JZUFRPX1BD
T01QPXkKQ09ORklHX0NSWVBUT19NQU5BR0VSPXkKQ09ORklHX0NSWVBUT19NQU5BR0VSMj15CiMg
Q09ORklHX0NSWVBUT19HRjEyOE1VTCBpcyBub3Qgc2V0CkNPTkZJR19DUllQVE9fTlVMTD1tCkNP
TkZJR19DUllQVE9fV09SS1FVRVVFPXkKIyBDT05GSUdfQ1JZUFRPX0NSWVBURCBpcyBub3Qgc2V0
CkNPTkZJR19DUllQVE9fQVVUSEVOQz1tCiMgQ09ORklHX0NSWVBUT19URVNUIGlzIG5vdCBzZXQK
CiMKIyBBdXRoZW50aWNhdGVkIEVuY3J5cHRpb24gd2l0aCBBc3NvY2lhdGVkIERhdGEKIwojIENP
TkZJR19DUllQVE9fQ0NNIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0dDTSBpcyBub3Qgc2V0
CiMgQ09ORklHX0NSWVBUT19TRVFJViBpcyBub3Qgc2V0CgojCiMgQmxvY2sgbW9kZXMKIwpDT05G
SUdfQ1JZUFRPX0NCQz1tCiMgQ09ORklHX0NSWVBUT19DVFIgaXMgbm90IHNldAojIENPTkZJR19D
UllQVE9fQ1RTIGlzIG5vdCBzZXQKQ09ORklHX0NSWVBUT19FQ0I9bQojIENPTkZJR19DUllQVE9f
TFJXIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1BDQkMgaXMgbm90IHNldAojIENPTkZJR19D
UllQVE9fWFRTIGlzIG5vdCBzZXQKCiMKIyBIYXNoIG1vZGVzCiMKQ09ORklHX0NSWVBUT19ITUFD
PXkKIyBDT05GSUdfQ1JZUFRPX1hDQkMgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fVk1BQyBp
cyBub3Qgc2V0CgojCiMgRGlnZXN0CiMKQ09ORklHX0NSWVBUT19DUkMzMkM9eQojIENPTkZJR19D
UllQVE9fQ1JDMzJDX0lOVEVMIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0dIQVNIIGlzIG5v
dCBzZXQKQ09ORklHX0NSWVBUT19NRDQ9bQpDT05GSUdfQ1JZUFRPX01ENT1tCkNPTkZJR19DUllQ
VE9fTUlDSEFFTF9NSUM9bQojIENPTkZJR19DUllQVE9fUk1EMTI4IGlzIG5vdCBzZXQKIyBDT05G
SUdfQ1JZUFRPX1JNRDE2MCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19STUQyNTYgaXMgbm90
IHNldAojIENPTkZJR19DUllQVE9fUk1EMzIwIGlzIG5vdCBzZXQKQ09ORklHX0NSWVBUT19TSEEx
PXkKQ09ORklHX0NSWVBUT19TSEEyNTY9bQpDT05GSUdfQ1JZUFRPX1NIQTUxMj1tCkNPTkZJR19D
UllQVE9fVEdSMTkyPW0KQ09ORklHX0NSWVBUT19XUDUxMj1tCgojCiMgQ2lwaGVycwojCkNPTkZJ
R19DUllQVE9fQUVTPW0KQ09ORklHX0NSWVBUT19BRVNfNTg2PW0KQ09ORklHX0NSWVBUT19BTlVC
SVM9bQpDT05GSUdfQ1JZUFRPX0FSQzQ9bQpDT05GSUdfQ1JZUFRPX0JMT1dGSVNIPW0KIyBDT05G
SUdfQ1JZUFRPX0NBTUVMTElBIGlzIG5vdCBzZXQKQ09ORklHX0NSWVBUT19DQVNUNT1tCkNPTkZJ
R19DUllQVE9fQ0FTVDY9bQpDT05GSUdfQ1JZUFRPX0RFUz1tCiMgQ09ORklHX0NSWVBUT19GQ1JZ
UFQgaXMgbm90IHNldApDT05GSUdfQ1JZUFRPX0tIQVpBRD1tCiMgQ09ORklHX0NSWVBUT19TQUxT
QTIwIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NBTFNBMjBfNTg2IGlzIG5vdCBzZXQKIyBD
T05GSUdfQ1JZUFRPX1NFRUQgaXMgbm90IHNldApDT05GSUdfQ1JZUFRPX1NFUlBFTlQ9bQpDT05G
SUdfQ1JZUFRPX1RFQT1tCkNPTkZJR19DUllQVE9fVFdPRklTSD1tCkNPTkZJR19DUllQVE9fVFdP
RklTSF9DT01NT049bQojIENPTkZJR19DUllQVE9fVFdPRklTSF81ODYgaXMgbm90IHNldAoKIwoj
IENvbXByZXNzaW9uCiMKQ09ORklHX0NSWVBUT19ERUZMQVRFPW0KIyBDT05GSUdfQ1JZUFRPX1pM
SUIgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fTFpPIGlzIG5vdCBzZXQKCiMKIyBSYW5kb20g
TnVtYmVyIEdlbmVyYXRpb24KIwpDT05GSUdfQ1JZUFRPX0FOU0lfQ1BSTkc9bQpDT05GSUdfQ1JZ
UFRPX0hXPXkKQ09ORklHX0NSWVBUT19ERVZfUEFETE9DSz1tCkNPTkZJR19DUllQVE9fREVWX1BB
RExPQ0tfQUVTPW0KIyBDT05GSUdfQ1JZUFRPX0RFVl9QQURMT0NLX1NIQSBpcyBub3Qgc2V0CiMg
Q09ORklHX0NSWVBUT19ERVZfR0VPREUgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fREVWX0hJ
Rk5fNzk1WCBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX0tWTT15CiMgQ09ORklHX1ZJUlRVQUxJWkFU
SU9OIGlzIG5vdCBzZXQKQ09ORklHX0JJTkFSWV9QUklOVEY9eQoKIwojIExpYnJhcnkgcm91dGlu
ZXMKIwpDT05GSUdfQklUUkVWRVJTRT15CkNPTkZJR19HRU5FUklDX0ZJTkRfRklSU1RfQklUPXkK
Q09ORklHX0dFTkVSSUNfRklORF9ORVhUX0JJVD15CkNPTkZJR19HRU5FUklDX0ZJTkRfTEFTVF9C
SVQ9eQpDT05GSUdfQ1JDX0NDSVRUPW0KQ09ORklHX0NSQzE2PW0KIyBDT05GSUdfQ1JDX1QxMERJ
RiBpcyBub3Qgc2V0CkNPTkZJR19DUkNfSVRVX1Q9bQpDT05GSUdfQ1JDMzI9eQojIENPTkZJR19D
UkM3IGlzIG5vdCBzZXQKQ09ORklHX0xJQkNSQzMyQz15CkNPTkZJR19BVURJVF9HRU5FUklDPXkK
Q09ORklHX1pMSUJfSU5GTEFURT15CkNPTkZJR19aTElCX0RFRkxBVEU9bQpDT05GSUdfREVDT01Q
UkVTU19HWklQPXkKQ09ORklHX0RFQ09NUFJFU1NfQlpJUDI9eQpDT05GSUdfREVDT01QUkVTU19M
Wk1BPXkKQ09ORklHX0dFTkVSSUNfQUxMT0NBVE9SPXkKQ09ORklHX1JFRURfU09MT01PTj1tCkNP
TkZJR19SRUVEX1NPTE9NT05fREVDMTY9eQpDT05GSUdfVEVYVFNFQVJDSD15CkNPTkZJR19URVhU
U0VBUkNIX0tNUD1tCkNPTkZJR19URVhUU0VBUkNIX0JNPW0KQ09ORklHX1RFWFRTRUFSQ0hfRlNN
PW0KQ09ORklHX0hBU19JT01FTT15CkNPTkZJR19IQVNfSU9QT1JUPXkKQ09ORklHX0hBU19ETUE9
eQpDT05GSUdfQ0hFQ0tfU0lHTkFUVVJFPXkKQ09ORklHX05MQVRUUj15Cg==
------=_Part_181637_1538288329.1265851460627--
