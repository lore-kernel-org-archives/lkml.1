Return-Path: <linux-kernel-owner+w=401wt.eu-S1759855AbZEZXmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855AbZEZXmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757505AbZEZXmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:42:42 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48532 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757355AbZEZXmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:42:40 -0400
Date: Tue, 26 May 2009 16:42:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/18] MAINTAINERS - Remove L:
	linux-kernel@vger.kernel.org from all but "THE REST"
Message-ID: <20090526234241.GD7006@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1243131992.git.joe@perches.com> <9f55522f7ab56afcf16d936d06ab2f3a7e699ed5.1243131992.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f55522f7ab56afcf16d936d06ab2f3a7e699ed5.1243131992.git.joe@perches.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 23, 2009 at 07:37:47PM -0700, Joe Perches wrote:
> lkml is added to all CC lists via pattern matching on "THE REST"

Hmmm...  Given that you are removing LKML from RCU and rcutorture,
could you please add me?  If someone misses "THE REST", I very likely
won't see their bug/issue/question.

P:	Paul E. McKenney
M:	paulmck@linux.vnet.ibm.com

							Thanx, Paul

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  MAINTAINERS |   81 -----------------------------------------------------------
>  1 files changed, 0 insertions(+), 81 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 11231fb..0774b87 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -901,7 +901,6 @@ P:	Dan Williams
>  M:	dan.j.williams@intel.com
>  P:	Maciej Sosnowski
>  M:	maciej.sosnowski@intel.com
> -L:	linux-kernel@vger.kernel.org
>  W:	http://sourceforge.net/projects/xscaleiop
>  S:	Supported
>  F:	Documentation/crypto/async-tx-api.txt
> @@ -991,7 +990,6 @@ F:	drivers/mmc/host/at91_mci.c
>  ATMEL AT91 / AT32 SERIAL DRIVER
>  P:	Haavard Skinnemoen
>  M:	hskinnemoen@atmel.com
> -L:	linux-kernel@vger.kernel.org
>  S:	Supported
>  F:	drivers/serial/atmel_serial.c
> 
> @@ -1047,7 +1045,6 @@ F:	kernel/audit*
>  AUXILIARY DISPLAY DRIVERS
>  P:	Miguel Ojeda Sandonis
>  M:	miguel.ojeda.sandonis@gmail.com
> -L:	linux-kernel@vger.kernel.org
>  W:	http://miguelojeda.es/auxdisplay.htm
>  W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
>  S:	Maintained
> @@ -1117,7 +1114,6 @@ F:	drivers/net/hamradio/baycom*
>  BEFS FILE SYSTEM
>  P:	Sergey S. Kostyliov
>  M:	rathamahata@php4.ru
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/filesystems/befs.txt
>  F:	fs/befs/
> @@ -1125,7 +1121,6 @@ F:	fs/befs/
>  BFS FILE SYSTEM
>  P:	Tigran A. Aivazian
>  M:	tigran@aivazian.fsnet.co.uk
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/filesystems/bfs.txt
>  F:	fs/bfs/
> @@ -1182,7 +1177,6 @@ F:	drivers/i2c/busses/i2c-bfin-twi.c
>  BLOCK LAYER
>  P:	Jens Axboe
>  M:	axboe@kernel.dk
> -L:	linux-kernel@vger.kernel.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
>  S:	Maintained
>  F:	block/
> @@ -1309,7 +1303,6 @@ P:	Muli Ben-Yehuda
>  M:	muli@il.ibm.com
>  P:	Jon D. Mason
>  M:	jdmason@kudzu.us
> -L:	linux-kernel@vger.kernel.org
>  L:	discuss@x86-64.org
>  S:	Maintained
>  F:	arch/x86/kernel/pci-calgary_64.c
> @@ -1354,7 +1347,6 @@ F:	include/linux/usb/wusb*
>  CFAG12864B LCD DRIVER
>  P:	Miguel Ojeda Sandonis
>  M:	miguel.ojeda.sandonis@gmail.com
> -L:	linux-kernel@vger.kernel.org
>  W:	http://miguelojeda.es/auxdisplay.htm
>  W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
>  S:	Maintained
> @@ -1364,7 +1356,6 @@ F:	include/linux/cfag12864b.h
>  CFAG12864BFB LCD FRAMEBUFFER DRIVER
>  P:	Miguel Ojeda Sandonis
>  M:	miguel.ojeda.sandonis@gmail.com
> -L:	linux-kernel@vger.kernel.org
>  W:	http://miguelojeda.es/auxdisplay.htm
>  W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
>  S:	Maintained
> @@ -1384,7 +1375,6 @@ X:	net/wireless/wext*
>  CHECKPATCH
>  P:	Andy Whitcroft
>  M:	apw@canonical.com
> -L:	linux-kernel@vger.kernel.org
>  S:	Supported
>  F:	scripts/checkpatch.pl
> 
> @@ -1510,7 +1500,6 @@ F:	drivers/usb/atm/cxacru.c
>  CONFIGFS
>  P:	Joel Becker
>  M:	joel.becker@oracle.com
> -L:	linux-kernel@vger.kernel.org
>  S:	Supported
>  F:	fs/configfs/
>  F:	include/linux/configfs.h
> @@ -1561,7 +1550,6 @@ F:	arch/x86/kernel/msr.c
>  CPUSETS
>  P:	Paul Menage
>  M:	menage@google.com
> -L:	linux-kernel@vger.kernel.org
>  W:	http://www.bullopensource.org/cpuset/
>  W:	http://oss.sgi.com/projects/cpusets/
>  S:	Supported
> @@ -1768,7 +1756,6 @@ DEVICE NUMBER REGISTRY
>  P:	Torben Mathiasen
>  M:	device@lanana.org
>  W:	http://lanana.org/docs/device-list/index.html
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
> 
>  DEVICE-MAPPER  (LVM)
> @@ -1794,7 +1781,6 @@ F:	drivers/char/digi*
>  DIRECTORY NOTIFICATION (DNOTIFY)
>  P:	Stephen Rothwell
>  M:	sfr@canb.auug.org.au
> -L:	linux-kernel@vger.kernel.org
>  S:	Supported
>  F:	Documentation/filesystems/dnotify.txt
>  F:	fs/notify/dnotify/
> @@ -1811,7 +1797,6 @@ S:	Maintained
>  DISKQUOTA
>  P:	Jan Kara
>  M:	jack@suse.cz
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/filesystems/quota.txt
>  F:	fs/quota/
> @@ -1833,7 +1818,6 @@ P:	Maciej Sosnowski
>  M:	maciej.sosnowski@intel.com
>  P:	Dan Williams
>  M:	dan.j.williams@intel.com
> -L:	linux-kernel@vger.kernel.org
>  S:	Supported
>  F:	drivers/dma/
>  F:	include/linux/dma*
> @@ -1885,7 +1869,6 @@ F:	drivers/scsi/dpt/
>  DRIVER CORE, KOBJECTS, AND SYSFS
>  P:	Greg Kroah-Hartman
>  M:	gregkh@suse.de
> -L:	linux-kernel@vger.kernel.org
>  T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
>  S:	Supported
>  F:	Documentation/kobject.txt
> @@ -2213,7 +2196,6 @@ F:	drivers/firewire/
>  F:	include/linux/firewire*.h
> 
>  FIRMWARE LOADER (request_firmware)
> -L:	linux-kernel@vger.kernel.org
>  S:	Orphan
>  F:	Documentation/firmware_class/
>  F:	drivers/base/firmware*.c
> @@ -2250,7 +2232,6 @@ M:	leoli@freescale.com
>  P:	Zhang Wei
>  M:	zw@zh-kernel.org
>  L:	linuxppc-embedded@ozlabs.org
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	drivers/dma/fsldma.*
> 
> @@ -2450,7 +2431,6 @@ F:	drivers/hwmon/hdaps.c
> 
>  HYPERVISOR VIRTUAL CONSOLE DRIVER
>  L:	linuxppc-dev@ozlabs.org
> -L:	linux-kernel@vger.kernel.org
>  S:	Odd Fixes
>  F:	drivers/char/hvc_*
> 
> @@ -2517,7 +2497,6 @@ F:	sound/parisc/harmony.*
>  HAYES ESP SERIAL DRIVER
>  P:	Andrew J. Robinson
>  M:	arobinso@nyx.net
> -L:	linux-kernel@vger.kernel.org
>  W:	http://www.nyx.net/~arobinso
>  S:	Maintained
>  F:	Documentation/serial/hayes-esp.txt
> @@ -2543,7 +2522,6 @@ F:	include/linux/cciss_ioctl.h
>  HFS FILESYSTEM
>  P:	Roman Zippel
>  M:	zippel@linux-m68k.org
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/filesystems/hfs.txt
>  F:	fs/hfs/
> @@ -2583,7 +2561,6 @@ F:	include/linux/hid*
>  HIGH-RESOLUTION TIMERS, CLOCKEVENTS, DYNTICKS
>  P:	Thomas Gleixner
>  M:	tglx@linutronix.de
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/timers/
>  F:	kernel/hrtimer.c
> @@ -2722,7 +2699,6 @@ F:	drivers/i2c/busses/i2c-tiny-usb.c
>  i386 BOOT CODE
>  P:	H. Peter Anvin
>  M:	hpa@zytor.com
> -L:	Linux-Kernel@vger.kernel.org
>  S:	Maintained
>  F:	arch/x86/boot/
> 
> @@ -2838,7 +2814,6 @@ P:	John McCutchan
>  M:	john@johnmccutchan.com
>  P:	Robert Love
>  M:	rlove@rlove.org
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/filesystems/inotify.txt
>  F:	fs/notify/inotify/
> @@ -2886,7 +2861,6 @@ F:	arch/x86/kernel/microcode_intel.c
>  INTEL I/OAT DMA DRIVER
>  P:	Maciej Sosnowski
>  M:	maciej.sosnowski@intel.com
> -L:	linux-kernel@vger.kernel.org
>  S:	Supported
>  F:	drivers/dma/ioat*
> 
> @@ -2902,7 +2876,6 @@ F:	include/linux/intel-iommu.h
>  INTEL IOP-ADMA DMA DRIVER
>  P:	Dan Williams
>  M:	dan.j.williams@intel.com
> -L:	linux-kernel@vger.kernel.org
>  S:	Supported
>  F:	drivers/dma/iop-adma.c
> 
> @@ -3214,7 +3187,6 @@ M:	vgoyal@redhat.com
>  P:	Haren Myneni
>  M:	hbabu@us.ibm.com
>  L:	kexec@lists.infradead.org
> -L:	linux-kernel@vger.kernel.org
>  W:	http://lse.sourceforge.net/kdump/
>  S:	Maintained
>  F:	Documentation/kdump/
> @@ -3324,7 +3296,6 @@ KEXEC
>  P:	Eric Biederman
>  M:	ebiederm@xmission.com
>  W:	http://ftp.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
> -L:	linux-kernel@vger.kernel.org
>  L:	kexec@lists.infradead.org
>  S:	Maintained
>  F:	include/linux/kexec.h
> @@ -3344,7 +3315,6 @@ F:	kernel/kgdb.c
>  KMEMTRACE
>  P:	Eduard - Gabriel Munteanu
>  M:	eduard.munteanu@linux360.ro
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/trace/kmemtrace.txt
>  F:	include/trace/kmemtrace.h
> @@ -3359,7 +3329,6 @@ P:	David S. Miller
>  M:	davem@davemloft.net
>  P:	Masami Hiramatsu
>  M:	mhiramat@redhat.com
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/kprobes.txt
>  F:	include/linux/kprobes.h
> @@ -3368,7 +3337,6 @@ F:	kernel/kprobes.c
>  KS0108 LCD CONTROLLER DRIVER
>  P:	Miguel Ojeda Sandonis
>  M:	miguel.ojeda.sandonis@gmail.com
> -L:	linux-kernel@vger.kernel.org
>  W:	http://miguelojeda.es/auxdisplay.htm
>  W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
>  S:	Maintained
> @@ -3532,7 +3500,6 @@ P:	Peter Zijlstra
>  M:	peterz@infradead.org
>  P:	Ingo Molnar
>  M:	mingo@redhat.com
> -L:	linux-kernel@vger.kernel.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git
>  S:	Maintained
>  F:	Documentation/lockdep*.txt
> @@ -3667,7 +3634,6 @@ F:	include/linux/mv643xx.h
>  MARVELL SOC MMC/SD/SDIO CONTROLLER DRIVER
>  P:	Nicolas Pitre
>  M:	nico@cam.org
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
> 
>  MARVELL YUKON / SYSKONNECT DRIVER
> @@ -3721,7 +3687,6 @@ F:	drivers/scsi/megaraid/
> 
>  MEMORY MANAGEMENT
>  L:	linux-mm@kvack.org
> -L:	linux-kernel@vger.kernel.org
>  W:	http://www.linux-mm.org
>  S:	Maintained
>  F:	include/linux/mm.h
> @@ -3735,7 +3700,6 @@ M:	xemul@openvz.org
>  P:	KAMEZAWA Hiroyuki
>  M:	kamezawa.hiroyu@jp.fujitsu.com
>  L:	linux-mm@kvack.org
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	mm/memcontrol.c
> 
> @@ -3778,7 +3742,6 @@ F:	arch/mips/
>  MISCELLANEOUS MCA-SUPPORT
>  P:	James Bottomley
>  M:	James.Bottomley@HansenPartnership.com
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/ia64/mca.txt
>  F:	Documentation/mca.txt
> @@ -3788,7 +3751,6 @@ F:	include/linux/mca*
>  MODULE SUPPORT
>  P:	Rusty Russell
>  M:	rusty@rustcorp.com.au
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	include/linux/module.h
>  F:	kernel/module.c
> @@ -3812,7 +3774,6 @@ F:	drivers/mmc/host/imxmmc.*
>  MOUSE AND MISC DEVICES [GENERAL]
>  P:	Alessandro Rubini
>  M:	rubini@ipvvis.unipv.it
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	drivers/input/mouse/
>  F:	include/linux/gpio_mouse.h
> @@ -3820,7 +3781,6 @@ F:	include/linux/gpio_mouse.h
>  MOXA SMARTIO/INDUSTIO/INTELLIO SERIAL CARD
>  P:	Jiri Slaby
>  M:	jirislaby@gmail.com
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/serial/moxa-smartio
>  F:	drivers/char/mxser.*
> @@ -3836,7 +3796,6 @@ F:	drivers/platform/x86/msi-laptop.c
>  MULTIFUNCTION DEVICES (MFD)
>  P:	Samuel Ortiz
>  M:	sameo@linux.intel.com
> -L:	linux-kernel@vger.kernel.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git
>  S:	Supported
>  F:	drivers/mfd/
> @@ -3844,7 +3803,6 @@ F:	drivers/mfd/
>  MULTIMEDIA CARD (MMC), SECURE DIGITAL (SD) AND SDIO SUBSYSTEM
>  P:	Pierre Ossman
>  M:	pierre@ossman.eu
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	drivers/mmc/
>  F:	include/linux/mmc/
> @@ -3852,7 +3810,6 @@ F:	include/linux/mmc/
>  MULTIMEDIA CARD (MMC) ETC. OVER SPI
>  P:	David Brownell
>  M:	dbrownell@users.sourceforge.net
> -L:	linux-kernel@vger.kernel.org
>  S:	Odd Fixes
>  F:	drivers/mmc/host/mmc_spi.c
>  F:	include/linux/spi/mmc_spi.h
> @@ -3867,7 +3824,6 @@ F:	sound/oss/msnd*
>  MULTITECH MULTIPORT CARD (ISICOM)
>  P:	Jiri Slaby
>  M:	jirislaby@gmail.com
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	drivers/char/isicom.c
>  F:	include/linux/isicom.h
> @@ -4111,7 +4067,6 @@ NTFS FILESYSTEM
>  P:	Anton Altaparmakov
>  M:	aia21@cantab.net
>  L:	linux-ntfs-dev@lists.sourceforge.net
> -L:	linux-kernel@vger.kernel.org
>  W:	http://www.linux-ntfs.org/
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/aia21/ntfs-2.6.git
>  S:	Maintained
> @@ -4282,7 +4237,6 @@ M:	akataria@vmware.com
>  P:	Rusty Russell
>  M:	rusty@rustcorp.com.au
>  L:	virtualization@lists.osdl.org
> -L:	linux-kernel@vger.kernel.org
>  S:	Supported
>  F:	Documentation/ia64/paravirt_ops.txt
>  F:	arch/*/kernel/paravirt*
> @@ -4333,7 +4287,6 @@ F:	include/linux/leds-pca9532.h
>  PCI ERROR RECOVERY
>  P:	Linas Vepstas
>  M:	linas@austin.ibm.com
> -L:	linux-kernel@vger.kernel.org
>  L:	linux-pci@vger.kernel.org
>  S:	Supported
>  F:	Documentation/PCI/pci-error-recovery.txt
> @@ -4342,7 +4295,6 @@ F:	Documentation/powerpc/eeh-pci-error-recovery.txt
>  PCI SUBSYSTEM
>  P:	Jesse Barnes
>  M:	jbarnes@virtuousgeek.org
> -L:	linux-kernel@vger.kernel.org
>  L:	linux-pci@vger.kernel.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
>  S:	Supported
> @@ -4377,7 +4329,6 @@ F:	drivers/net/pcnet32.c
>  PER-TASK DELAY ACCOUNTING
>  P:	Balbir Singh
>  M:	balbir@linux.vnet.ibm.com
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	include/linux/delayacct.h
>  F:	kernel/delayacct.c
> @@ -4399,7 +4350,6 @@ F:	drivers/mtd/devices/phram.c
>  PKTCDVD DRIVER
>  P:	Peter Osterlund
>  M:	petero2@telia.com
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	drivers/block/pktcdvd.c
>  F:	include/linux/pktcdvd.h
> @@ -4407,7 +4357,6 @@ F:	include/linux/pktcdvd.h
>  POSIX CLOCKS and TIMERS
>  P:	Thomas Gleixner
>  M:	tglx@linutronix.de
> -L:	linux-kernel@vger.kernel.org
>  S:	Supported
>  F:	fs/timerfd.c
>  F:	include/linux/timer*
> @@ -4418,7 +4367,6 @@ P:	Anton Vorontsov
>  M:	cbou@mail.ru
>  P:	David Woodhouse
>  M:	dwmw2@infradead.org
> -L:	linux-kernel@vger.kernel.org
>  T:	git git://git.infradead.org/battery-2.6.git
>  S:	Maintained
>  F:	include/linux/power_supply.h
> @@ -4470,7 +4418,6 @@ F:	include/linux/if_pppol2tp.h
>  PREEMPTIBLE KERNEL
>  P:	Robert Love
>  M:	rml@tech9.net
> -L:	linux-kernel@vger.kernel.org
>  L:	kpreempt-tech@lists.sourceforge.net
>  W:	ftp://ftp.kernel.org/pub/linux/kernel/people/rml/preempt-kernel
>  S:	Supported
> @@ -4533,7 +4480,6 @@ P:	Roland McGrath
>  M:	roland@redhat.com
>  P:	Oleg Nesterov
>  M:	oleg@redhat.com
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	include/asm-generic/syscall.h
>  F:	include/linux/ptrace.h
> @@ -4618,7 +4564,6 @@ F:	drivers/net/qlge/
>  QNX4 FILESYSTEM
>  P:	Anders Larsen
>  M:	al@alarsen.net
> -L:	linux-kernel@vger.kernel.org
>  W:	http://www.alarsen.net/linux/qnx4fs/
>  S:	Maintained
>  F:	fs/qnx4/
> @@ -4665,7 +4610,6 @@ F:	drivers/char/random.c
>  RAPIDIO SUBSYSTEM
>  P:	Matt Porter
>  M:	mporter@kernel.crashing.org
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	drivers/rapidio/
> 
> @@ -4679,7 +4623,6 @@ F:	drivers/net/wireless/ray*
>  RCUTORTURE MODULE
>  P:	Josh Triplett
>  M:	josh@freedesktop.org
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/RCU/torture.txt
>  F:	kernel/rcutorture.c
> @@ -4687,7 +4630,6 @@ F:	kernel/rcutorture.c
>  RDC R-321X SoC
>  P:	Florian Fainelli
>  M:	florian@openwrt.org
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
> 
>  RDC R6040 FAST ETHERNET DRIVER
> @@ -4708,7 +4650,6 @@ READ-COPY UPDATE (RCU)
>  P:	Dipankar Sarma
>  M:	dipankar@in.ibm.com
>  W:	http://www.rdrop.com/users/paulmck/rclock/
> -L:	linux-kernel@vger.kernel.org
>  S:	Supported
>  F:	Documentation/RCU/rcu.txt
>  F:	Documentation/RCU/rcuref.txt
> @@ -4719,7 +4660,6 @@ F:	kernel/rcupdate.c
>  REAL TIME CLOCK DRIVER
>  P:	Paul Gortmaker
>  M:	p_gortmaker@yahoo.com
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/rtc.txt
>  F:	drivers/rtc/
> @@ -4857,7 +4797,6 @@ S3C24XX SD/MMC Driver
>  P:	Ben Dooks
>  M:	ben-linux@fluff.org
>  L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
> -L:	linux-kernel@vger.kernel.org
>  S:	Supported
>  F:	drivers/mmc/host/s3cmci.*
> 
> @@ -4883,7 +4822,6 @@ P:	Ingo Molnar
>  M:	mingo@elte.hu
>  P:	Peter Zijlstra
>  M:	peterz@infradead.org
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	kernel/sched*
>  F:	include/linux/sched.h
> @@ -4985,7 +4923,6 @@ F:	drivers/mmc/host/sdhci.*
>  SECURITY SUBSYSTEM
>  P:	James Morris
>  M:	jmorris@namei.org
> -L:	linux-kernel@vger.kernel.org
>  L:	linux-security-module@vger.kernel.org (suggested Cc:)
>  T:	git git://www.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
>  W:	http://security.wiki.kernel.org/
> @@ -5004,7 +4941,6 @@ P:	James Morris
>  M:	jmorris@namei.org
>  P:	Eric Paris
>  M:	eparis@parisplace.org
> -L:	linux-kernel@vger.kernel.org (kernel issues)
>  L:	selinux@tycho.nsa.gov (subscribers-only, general discussion)
>  W:	http://selinuxproject.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
> @@ -5268,7 +5204,6 @@ F:	include/linux/sony-laptop.h
>  SONY MEMORYSTICK CARD SUPPORT
>  P:	Alex Dubov
>  M:	oakad@yahoo.com
> -L:	linux-kernel@vger.kernel.org
>  W:	http://tifmxx.berlios.de/
>  S:	Maintained
>  F:	drivers/memstick/host/tifm_ms.c
> @@ -5310,7 +5245,6 @@ F:	arch/sparc/
>  SPECIALIX IO8+ MULTIPORT SERIAL CARD DRIVER
>  P:	Roger Wolff
>  M:	R.E.Wolff@BitWizard.nl
> -L:	linux-kernel@vger.kernel.org
>  S:	Supported
>  F:	Documentation/serial/specialix.txt
>  F:	drivers/char/specialix*
> @@ -5356,7 +5290,6 @@ F:	fs/squashfs/
>  SRM (Alpha) environment access
>  P:	Jan-Benedict Glaw
>  M:	jbglaw@lug-owl.de
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	arch/alpha/kernel/srm_env.c
> 
> @@ -5371,7 +5304,6 @@ S:	Maintained
>  STAGING SUBSYSTEM
>  P:	Greg Kroah-Hartman
>  M:	gregkh@suse.de
> -L:	linux-kernel@vger.kernel.org
>  T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
>  S:	Maintained
>  F:	drivers/staging/
> @@ -5451,7 +5383,6 @@ F:	include/linux/sysv_fs.h
>  TASKSTATS STATISTICS INTERFACE
>  P:	Balbir Singh
>  M:	balbir@linux.vnet.ibm.com
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/accounting/taskstats*
>  F:	include/linux/taskstats*
> @@ -5558,7 +5489,6 @@ P:	Kentaro Takeda
>  M:	takedakn@nttdata.co.jp
>  P:	Tetsuo Handa
>  M:	penguin-kernel@I-love.SAKURA.ne.jp
> -L:	linux-kernel@vger.kernel.org (kernel issues)
>  L:	tomoyo-users-en@lists.sourceforge.jp (subscribers-only, for developers and users in English)
>  L:	tomoyo-dev@lists.sourceforge.jp (subscribers-only, for developers in Japanese)
>  L:	tomoyo-users@lists.sourceforge.jp (subscribers-only, for users in Japanese)
> @@ -5610,14 +5540,12 @@ F:	drivers/char/tpm/
>  TRIVIAL PATCHES
>  P:	Jiri Kosina
>  M:	trivial@kernel.org
> -L:	linux-kernel@vger.kernel.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git
>  S:	Maintained
> 
>  TTY LAYER
>  P:	Alan Cox
>  M:	alan@lxorguk.ukuu.org.uk
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
> 
>  TULIP NETWORK DRIVERS
> @@ -5689,7 +5617,6 @@ F:	fs/udf/
>  UFS FILESYSTEM
>  P:	Evgeniy Dushistov
>  M:	dushistov@mail.ru
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/filesystems/ufs.txt
>  F:	fs/ufs/
> @@ -5706,7 +5633,6 @@ F:	include/linux/uwb/
>  UNIFORM CDROM DRIVER
>  P:	Jens Axboe
>  M:	axboe@kernel.dk
> -L:	linux-kernel@vger.kernel.org
>  W:	http://www.kernel.dk
>  S:	Maintained
>  F:	Documentation/cdrom/
> @@ -5735,7 +5661,6 @@ F:	drivers/usb/class/cdc-acm.*
>  USB BLOCK DRIVER (UB ub)
>  P:	Pete Zaitcev
>  M:	zaitcev@redhat.com
> -L:	linux-kernel@vger.kernel.org
>  L:	linux-usb@vger.kernel.org
>  S:	Supported
>  F:	drivers/block/ub.c
> @@ -6075,7 +6000,6 @@ P:	Hans J. Koch
>  M:	hjk@linutronix.de
>  P:	Greg Kroah-Hartman
>  M:	gregkh@suse.de
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/DocBook/uio-howto.tmpl
>  F:	drivers/uio/
> @@ -6101,7 +6025,6 @@ F:	drivers/video/uvesafb.*
>  VFAT/FAT/MSDOS FILESYSTEM
>  P:	OGAWA Hirofumi
>  M:	hirofumi@mail.parknet.co.jp
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/filesystems/vfat.txt
>  F:	fs/fat/
> @@ -6198,7 +6121,6 @@ F:	drivers/hwmon/w83793.c
>  W83L51xD SD/MMC CARD INTERFACE DRIVER
>  P:	Pierre Ossman
>  M:	pierre@ossman.eu
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	drivers/mmc/host/wbsd.*
> 
> @@ -6285,7 +6207,6 @@ M:	mingo@redhat.com
>  P:	H. Peter Anvin
>  M:	hpa@zytor.com
>  M:	x86@kernel.org
> -L:	linux-kernel@vger.kernel.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
>  S:	Maintained
>  F:	Documentation/x86/
> @@ -6321,7 +6242,6 @@ XILINX SYSTEMACE DRIVER
>  P:	Grant Likely
>  M:	grant.likely@secretlab.ca
>  W:	http://www.secretlab.ca/
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	drivers/block/xsysace.c
> 
> @@ -6392,4 +6312,3 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>  S:	Buried alive in reporters
>  F:	*
>  F:	*/
> -
> -- 
> 1.6.3.1.10.g659a0.dirty
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
