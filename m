Return-Path: <linux-kernel-owner+w=401wt.eu-S944124AbXHMQDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944124AbXHMQDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031621AbXHMOX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:23:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:49917 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S971033AbXHMOXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:23:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type;
        b=A19eZoRmRt+o1TJNy0ZOhLUnbLkMCjDCn/CLhKkA/nSv/bLPkteIfF7lOhE3vGUvPksM8wUTwqzkceC2wjKJTRLC/x+W6fipiaH1a0og881VA98QdxFaaYqkj7EFBz8TVYpsGKiowBtR5iQAzRw6hAyu8atBpKlgcfZZKxMuoJs=
Message-ID: <46C068FB.1040200@gmail.com>
Date: Mon, 13 Aug 2007 16:21:47 +0200
From: giggz <giggzounet@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM : On a laptop Aopen 1556 or 1557 my integrated card-reader
 doesn't work.
Content-Type: multipart/mixed;
 boundary="------------050909010201070501090903"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050909010201070501090903
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

My mail is a little big. In order not to be blocked I try to attach it.

Regards,
Guillaume

--------------050909010201070501090903
Content-Type: text/plain;
 name="bug_kernel.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bug_kernel.txt"


[1.] One line summary of the problem:

On a laptop Aopen 1556 or 1557 my integrated card-reader doesn't work.

[2.] Full description of the problem/report:

The card-reader of my laptop (Aopen 1556 or 1557) has never work. I'm under Debian unstable, but I have tested others distros through live-cd and it doesn't work too.

[3.] Keywords (i.e., modules, networking, kernel):

kernel; card-reader; sd-card; pcmcia

[4.] Kernel information
[4.1.] Kernel version (from /proc/version):

Linux version 2.6.22.2-1 (giggz@debian) (gcc version 4.1.3 20070718 (prerelease) (Debian 4.1.2-14)) #1 PREEMPT Fri Aug 10 10:42:01 CEST 2007

[4.2.] Kernel .config file:

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.22.2-1
# Fri Aug 10 10:35:51 2007
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32

#
# General setup
#
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
# CONFIG_IPC_NS is not set
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
# CONFIG_UTS_NS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=15
CONFIG_SYSFS_DEPRECATED=y
CONFIG_RELAY=y
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
# CONFIG_KALLSYMS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0

#
# Loadable module support
#
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y

#
# Block layer
#
CONFIG_BLOCK=y
CONFIG_LBD=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_LSF=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
# CONFIG_SMP is not set
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_PARAVIRT is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
CONFIG_MPENTIUMM=y
# CONFIG_MCORE2 is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_MODEL=4
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_BKL=y
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
# CONFIG_X86_MCE_P4THERMAL is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_NR_QUICK=1
# CONFIG_HIGHPTE is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_COMPAT_VDSO is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options (ACPI, APM)
#
CONFIG_PM=y
CONFIG_PM_LEGACY=y
# CONFIG_PM_DEBUG is not set
# CONFIG_PM_SYSFS_DEPRECATED is not set
CONFIG_SOFTWARE_SUSPEND=y
CONFIG_PM_STD_PARTITION=""

#
# ACPI (Advanced Configuration and Power Interface) Support
#
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_SLEEP_PROC_FS=y
# CONFIG_ACPI_SLEEP_PROC_SLEEP is not set
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y

[5.] Most recent kernel version which did not have the bug:

all versions of the kernel have this bug

[6.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)
[7.] A small shell script or example program which triggers the
     problem (if possible)


[8.] Environment
[8.1.] Software (add the output of the ver_linux script here)

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux debian 2.6.22.2-1 #1 PREEMPT Fri Aug 10 10:42:01 CEST 2007 i686 GNU/Linux
 
Gnu C                  4.1.3
Gnu make               3.81
binutils               Binutils
util-linux             2.13-rc3
mount                  2.13-rc3
module-init-tools      3.3-pre11
e2fsprogs              1.40.2
pcmciautils            014
PPP                    2.4.4
Linux C Library        2.6.1
Dynamic linker (ldd)   2.6.1
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.97
udev                   114
wireless-tools         29
Modules Loaded         xt_limit ipt_LOG ipt_MASQUERADE ipt_TOS ipt_REJECT nf_conntrack_irc nf_conntrack_ftp xt_state xt_TCPMSS xt_tcpmss xt_tcpudp pppoe pppox ppp_generic slhc nfsd exportfs lockd sunrpc ppdev lp ipv6 acpi_cpufreq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nfnetlink iptable_mangle iptable_filter ip_tables x_tables fuse wistron_btns cpufreq_conservative cpufreq_powersave cpufreq_ondemand cpufreq_performance radeon drm usbhid pcmcia joydev nsc_ircc ipw2200 ieee80211 ieee80211_crypt ide_cd firewire_ohci firewire_core snd_intel8x0m snd_intel8x0 snd_ac97_codec snd_pcm_oss snd_mixer_oss iTCO_wdt iTCO_vendor_support ehci_hcd yenta_socket rsrc_nonstatic pcmcia_core firmware_class intel_agp agpgart b44 mii parport_pc parport cdrom uhci_hcd irda crc_itu_t ac97_bus snd_pcm snd_timer snd_page_alloc usbcore psmouse evdev crc_ccitt

[8.2.] Processor information (from /proc/cpuinfo):

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 13
model name      : Intel(R) Pentium(R) M processor 1.80GHz
stepping        : 6
cpu MHz         : 800.000
cache size      : 2048 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr mce cx8 sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss tm pbe est tm2
bogomips        : 1595.31
clflush size    : 64


[8.3.] Module information (from /proc/modules):

xt_limit 1472 8 - Live 0xf9b58000
ipt_LOG 4544 8 - Live 0xf9b4d000
ipt_MASQUERADE 1920 0 - Live 0xf9b54000
ipt_TOS 1216 0 - Live 0xf9b52000
ipt_REJECT 2880 1 - Live 0xf9b50000
nf_conntrack_irc 4376 0 - Live 0xf9afd000
nf_conntrack_ftp 6656 0 - Live 0xf9ae4000
xt_state 1280 6 - Live 0xf9afb000
xt_TCPMSS 3200 0 - Live 0xf9af9000
xt_tcpmss 1216 0 - Live 0xf9aec000
xt_tcpudp 1984 100 - Live 0xf9aea000
pppoe 9216 2 - Live 0xf9aef000
pppox 1864 1 pppoe, Live 0xf9ad3000
ppp_generic 19540 6 pppoe,pppox, Live 0xf9af3000
slhc 4224 1 ppp_generic, Live 0xf9ae7000
nfsd 168240 13 - Live 0xf9b7e000
exportfs 3712 1 nfsd, Live 0xf99ee000
lockd 45960 2 nfsd, Live 0xf9ad5000
sunrpc 113084 8 nfsd,lockd, Live 0xf9b30000
ppdev 7108 0 - Live 0xf99eb000
lp 7364 0 - Live 0xf99dc000
ipv6 191684 14 - Live 0xf9b00000
acpi_cpufreq 4684 0 - Live 0xf99e0000
iptable_nat 4740 0 - Live 0xf9963000
nf_nat 11436 2 ipt_MASQUERADE,iptable_nat, Live 0xf99e3000
nf_conntrack_ipv4 11148 8 iptable_nat, Live 0xf997c000
nf_conntrack 32520 7 ipt_MASQUERADE,nf_conntrack_irc,nf_conntrack_ftp,xt_state,iptable_nat,nf_nat,nf_conntrack_ipv4, Live 0xf9aa2000
nfnetlink 2776 3 nf_nat,nf_conntrack_ipv4,nf_conntrack, Live 0xf997a000
iptable_mangle 1600 0 - Live 0xf9966000
iptable_filter 1536 1 - Live 0xf990b000
ip_tables 8520 3 iptable_nat,iptable_mangle,iptable_filter, Live 0xf996c000
x_tables 7364 11 xt_limit,ipt_LOG,ipt_MASQUERADE,ipt_TOS,ipt_REJECT,xt_state,xt_TCPMSS,xt_tcpmss,xt_tcpudp,iptable_nat,ip_tables, Live 0xf9969000
fuse 32212 1 - Live 0xf9971000
wistron_btns 5620 0 - Live 0xf9920000
cpufreq_conservative 3872 0 - Live 0xf9887000
cpufreq_powersave 832 0 - Live 0xf9906000
cpufreq_ondemand 4756 1 - Live 0xf9924000
cpufreq_performance 832 0 - Live 0xf98c2000
radeon 103776 2 - Live 0xf99c1000
drm 54612 3 radeon, Live 0xf9936000
usbhid 19872 0 - Live 0xf9930000
pcmcia 20384 0 - Live 0xf992a000
joydev 7104 0 - Live 0xf98f0000
nsc_ircc 12496 0 - Live 0xf990d000
ipw2200 117448 0 - Live 0xf9945000
ieee80211 22920 1 ipw2200, Live 0xf98e1000
ieee80211_crypt 2560 1 ieee80211, Live 0xf98c5000
ide_cd 30880 0 - Live 0xf9912000
firewire_ohci 12736 0 - Live 0xf98dc000
firewire_core 25152 1 firewire_ohci, Live 0xf98e8000
snd_intel8x0m 11404 5 - Live 0xf98b8000
snd_intel8x0 22684 2 - Live 0xf98d5000
snd_ac97_codec 71012 2 snd_intel8x0m,snd_intel8x0, Live 0xf98f3000
snd_pcm_oss 29408 0 - Live 0xf98cc000
snd_mixer_oss 11968 2 snd_pcm_oss, Live 0xf98bc000
iTCO_wdt 6880 0 - Live 0xf98b1000
iTCO_vendor_support 1348 1 iTCO_wdt, Live 0xf98b4000
ehci_hcd 25612 0 - Live 0xf98a2000
yenta_socket 11212 2 - Live 0xf988f000
rsrc_nonstatic 8320 1 yenta_socket, Live 0xf989e000
pcmcia_core 22672 3 pcmcia,yenta_socket,rsrc_nonstatic, Live 0xf98aa000
firmware_class 6080 2 pcmcia,ipw2200, Live 0xf9894000
intel_agp 16852 1 - Live 0xf9898000
agpgart 18288 2 drm,intel_agp, Live 0xf9881000
b44 19276 0 - Live 0xf9889000
mii 2944 1 b44, Live 0xf881c000
parport_pc 20324 1 - Live 0xf886e000
parport 13504 3 ppdev,lp,parport_pc, Live 0xf8877000
cdrom 26976 1 ide_cd, Live 0xf8860000
uhci_hcd 17872 0 - Live 0xf8868000
irda 70456 1 nsc_ircc, Live 0xf8828000
crc_itu_t 1152 1 firewire_core, Live 0xf8818000
ac97_bus 1152 1 snd_ac97_codec, Live 0xf8816000
snd_pcm 42568 6 snd_intel8x0m,snd_intel8x0,snd_ac97_codec,snd_pcm_oss, Live 0xf883c000
snd_timer 14084 1 snd_pcm, Live 0xf8823000
snd_page_alloc 5960 3 snd_intel8x0m,snd_intel8x0,snd_pcm, Live 0xf880f000
usbcore 88344 4 usbhid,ehci_hcd,uhci_hcd, Live 0xf8849000
psmouse 16264 0 - Live 0xf881e000
evdev 6720 6 - Live 0xf8813000
crc_ccitt 1152 1 irda, Live 0xf880d000

[8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

cat /proc/ioports (without card in the reader) :
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
  0170-0177 : ide1
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : ide0
02f8-02ff : nsc-ircc
0376-0376 : 0000:00:1f.1
  0376-0376 : ide1
03bc-03be : parport0
03c0-03df : vga+
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : ide0
0cf8-0cff : PCI conf1
1000-107f : 0000:00:1f.0
  1000-1003 : ACPI PM1a_EVT_BLK
  1004-1005 : ACPI PM1a_CNT_BLK
  1008-100b : ACPI PM_TMR
  1020-1020 : ACPI PM2_CNT_BLK
  1028-102f : ACPI GPE0_BLK
  1060-107f : iTCO_wdt
1180-11bf : 0000:00:1f.0
1800-181f : 0000:00:1d.0
  1800-181f : uhci_hcd
1820-183f : 0000:00:1d.1
  1820-183f : uhci_hcd
1840-185f : 0000:00:1d.2
  1840-185f : uhci_hcd
1860-186f : 0000:00:1f.1
  1860-1867 : ide0
  1868-186f : ide1
1880-189f : 0000:00:1f.3
  1880-189f : i801_smbus
18c0-18ff : 0000:00:1f.5
  18c0-18ff : Intel 82801DB-ICH4
1c00-1cff : 0000:00:1f.5
  1c00-1cff : Intel 82801DB-ICH4
2000-207f : 0000:00:1f.6
  2000-207f : Intel 82801DB-ICH4 Modem
2400-24ff : 0000:00:1f.6
  2400-24ff : Intel 82801DB-ICH4 Modem
3000-3fff : PCI Bus #01
  3000-30ff : 0000:01:00.0
4000-4fff : PCI Bus #02
  4000-40ff : PCI CardBus #03
  4400-44ff : PCI CardBus #03
  4800-48ff : PCI CardBus #07
  4c00-4cff : PCI CardBus #07

cat /proc/iomem (without card in the reader) :
00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cefff : Video ROM
000cf000-000cffff : Adapter ROM
000d0000-000d17ff : Adapter ROM
000d8000-000dffff : reserved
000f0000-000fffff : System ROM
00100000-7ff6ffff : System RAM
  00100000-002c1a14 : Kernel code
  002c1a15-00348a23 : Kernel data
7ff70000-7ff7afff : ACPI Tables
7ff7b000-7ff7ffff : ACPI Non-volatile Storage
7ff80000-7fffffff : reserved
88000000-91ffffff : PCI Bus #02
  88000000-8bffffff : PCI CardBus #03
  8c000000-8fffffff : PCI CardBus #07
  90000000-9000ffff : 0000:02:05.0
92000000-920003ff : 0000:00:1f.1
94000000-97ffffff : PCI CardBus #03
98000000-9bffffff : PCI CardBus #07
d0000000-d00003ff : 0000:00:1d.7
  d0000000-d00003ff : ehci_hcd
d0000800-d00008ff : 0000:00:1f.5
  d0000800-d00008ff : Intel 82801DB-ICH4
d0000c00-d0000dff : 0000:00:1f.5
  d0000c00-d0000dff : Intel 82801DB-ICH4
d0100000-d01fffff : PCI Bus #01
  d0100000-d010ffff : 0000:01:00.0
    d0100000-d010ffff : radeonfb mmio
  d0120000-d013ffff : 0000:01:00.0
d0200000-d02fffff : PCI Bus #02
  d0200000-d0201fff : 0000:02:05.0
    d0200000-d0201fff : b44
  d0202000-d0202fff : 0000:02:06.0
    d0202000-d0202fff : ipw2200
  d0203000-d02037ff : 0000:02:09.2
    d0203000-d02037ff : firewire_ohci
  d0204000-d0204fff : 0000:02:09.0
    d0204000-d0204fff : yenta_socket
  d0205000-d0205fff : 0000:02:09.1
    d0205000-d0205fff : yenta_socket
d8000000-dfffffff : PCI Bus #01
  d8000000-dfffffff : 0000:01:00.0
    d8000000-dfffffff : radeonfb framebuffer
e0000000-efffffff : 0000:00:00.0
fec10000-fec1ffff : pnp 00:04
ff800000-ffbfffff : reserved
fffff000-ffffffff : reserved

[8.5.] PCI information ('lspci -vvv' as root)

00:00.0 Host bridge: Intel Corporation 82855PM Processor to I/O Controller (rev 21)
        Subsystem: Wistron Corp. Unknown device 4010
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort+ <MAbort+ >SERR- <PERR-
        Latency: 0
        Region 0: Memory at e0000000 (32-bit, prefetchable) [size=256M]
        Capabilities: [e4] Vendor Specific Information
        Capabilities: [a0] AGP version 2.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
                Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4

00:01.0 PCI bridge: Intel Corporation 82855PM Processor to AGP Controller (rev 21) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 96
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
        I/O behind bridge: 00003000-00003fff
        Memory behind bridge: d0100000-d01fffff
        Prefetchable memory behind bridge: d8000000-dfffffff
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-

00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 03) (prog-if 00 [UHCI])
        Subsystem: Wistron Corp. Unknown device 4006
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 11
        Region 4: I/O ports at 1800 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 03) (prog-if 00 [UHCI])
        Subsystem: Wistron Corp. Unknown device 4006
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 10
        Region 4: I/O ports at 1820 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 03) (prog-if 00 [UHCI])
        Subsystem: Wistron Corp. Unknown device 4006
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 11
        Region 4: I/O ports at 1840 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 03) (prog-if 20 [EHCI])
        Subsystem: Wistron Corp. Unknown device 1071
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin D routed to IRQ 10
        Region 0: Memory at d0000000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 83) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort+ <TAbort- <MAbort- >SERR- <PERR+
        Latency: 0
        Bus: primary=00, secondary=02, subordinate=0a, sec-latency=32
        I/O behind bridge: 00004000-00004fff
        Memory behind bridge: d0200000-d02fffff
        Prefetchable memory behind bridge: 88000000-91ffffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge (rev 03)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE Controller (rev 03) (prog-if 8a [Master SecP PriP])
        Subsystem: Wistron Corp. Unknown device 4006
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at 1860 [size=16]
        Region 5: Memory at 92000000 (32-bit, non-prefetchable) [size=1K]

00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 03)
        Subsystem: Wistron Corp. Unknown device 4006
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 10
        Region 4: I/O ports at 1880 [size=32]

00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 03)
        Subsystem: Wistron Corp. Unknown device 2005
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 10
        Region 0: I/O ports at 1c00 [size=256]
        Region 1: I/O ports at 18c0 [size=64]
        Region 2: Memory at d0000c00 (32-bit, non-prefetchable) [size=512]
        Region 3: Memory at d0000800 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller (rev 03) (prog-if 00 [Generic])
        Subsystem: Wistron Corp. Unknown device 1069
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 10
        Region 0: I/O ports at 2400 [size=256]
        Region 1: I/O ports at 2000 [size=128]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.0 VGA compatible controller: ATI Technologies Inc RV350 [Mobility Radeon 9600 M10] (prog-if 00 [VGA])
        Subsystem: Wistron Corp. Unknown device 2061
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B+
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 66 (2000ns min), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at d8000000 (32-bit, prefetchable) [size=128M]
        Region 1: I/O ports at 3000 [size=256]
        Region 2: Memory at d0100000 (32-bit, non-prefetchable) [size=64K]
        [virtual] Expansion ROM at d0120000 [disabled] [size=128K]
        Capabilities: [58] AGP version 2.0
                Status: RQ=80 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
                Command: RQ=32 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:05.0 Ethernet controller: Broadcom Corporation BCM4401 100Base-T (rev 01)
        Subsystem: Wistron Corp. Unknown device 1082
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort+ <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at d0200000 (32-bit, non-prefetchable) [size=8K]
        [virtual] Expansion ROM at 90000000 [disabled] [size=64K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

02:06.0 Network controller: Intel Corporation PRO/Wireless 2200BG Network Connection (rev 05)
        Subsystem: Intel Corporation Unknown device 2702
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (750ns min, 6000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at d0202000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-

02:09.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ac)
        Subsystem: Wistron Corp. Unknown device 3301
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 168
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at d0204000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
        Memory window 0: 88000000-8bfff000 (prefetchable)
        Memory window 1: 94000000-97fff000
        I/O window 0: 00004000-000040ff
        I/O window 1: 00004400-000044ff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
        16-bit legacy interface ports at 0001

02:09.1 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ac)
        Subsystem: Wistron Corp. Unknown device 3301
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 168
        Interrupt: pin B routed to IRQ 10
        Region 0: Memory at d0205000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=02, secondary=07, subordinate=0a, sec-latency=176
        Memory window 0: 8c000000-8ffff000 (prefetchable)
        Memory window 1: 98000000-9bfff000
        I/O window 0: 00004800-000048ff
        I/O window 1: 00004c00-00004cff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
        16-bit legacy interface ports at 0001

02:09.2 FireWire (IEEE 1394): Ricoh Co Ltd R5C552 IEEE 1394 Controller (rev 04) (prog-if 10 [OHCI])
        Subsystem: Wistron Corp. Unknown device 107a
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (500ns min, 1000ns max)
        Interrupt: pin C routed to IRQ 11
        Region 0: Memory at d0203000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME+

[8.6.] SCSI information (from /proc/scsi/scsi)

Attached devices:

[8.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

lspcmcia -vvv without any card :
Socket 0 Bridge:        [yenta_cardbus]         (bus ID: 0000:02:09.0)
        Configuration:  state: on       ready: unknown
--none--
--none--
Socket 1 Bridge:        [yenta_cardbus]         (bus ID: 0000:02:09.1)
        Configuration:  state: on       ready: unknown
--none--
--none--

lspcmcia -vvv with a card :
Socket 0 Bridge:        [yenta_cardbus]         (bus ID: 0000:02:09.0)
        Configuration:  state: on       ready: unknown
                        Voltage: 3.3V Vcc: 3.3V Vpp: 3.3V
--none--
--none--
Socket 0 Device 0:      [-- no driver --]       (bus ID: 0.0)
        Configuration:  state: on
        Product Name:   RICOH Bay1Controller 
        Identification: manf_id: 0x0000 card_id: 0x0000
zsh: segmentation fault  lspcmcia -vvv

and I just see that in the syslog :
Aug 13 15:14:14 debian kernel: pccard: PCMCIA card inserted into slot 0
Aug 13 15:14:14 debian kernel: cs: memory probe 0xd0200000-0xd02fffff: excluding 0xd0200000-0xd020ffff
Aug 13 15:14:14 debian kernel: pcmcia: registering new device pcmcia0.0


[X.] Other notes, patches, fixes, workarounds:
no, sorry...



Thx for your great work,
Regards
Guillaume



--------------050909010201070501090903--
