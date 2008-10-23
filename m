Return-Path: <linux-kernel-owner+w=401wt.eu-S1759231AbYJWXMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231AbYJWXMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 19:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758675AbYJWXKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 19:10:17 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4768 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbYJWXJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:09:47 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Pavel Machek <pavel@suse.cz>,
       =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@strlen.de>
Subject: [PATCH 6/8] MAINTAINERS - standardize "T:	git urls"
Date: Thu, 23 Oct 2008 16:09:24 -0700
Message-Id: <1a29dd9705091501c849a7c96678aa1a4796a836.1224802312.git.joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <92e881c3c6b7068ee07f8415be9071cfcea2175c.1224802312.git.joe@perches.com>
References: <1224803366-6478-1-git-send-email-joe@perches.com>
 <ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com>
 <f3c9f31c59a20acbc8b7535878ab6c86ba6630de.1224802312.git.joe@perches.com>
 <f1526bde1c026c2b5f439a97f96ec587705229e5.1224802312.git.joe@perches.com>
 <61cf615d8a20ad2608cb1c2fbad67ff4253a8457.1224802312.git.joe@perches.com>
 <92e881c3c6b7068ee07f8415be9071cfcea2175c.1224802312.git.joe@perches.com>
In-Reply-To: <ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com>
References: <ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c74ce8b..fdda380 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -161,41 +161,41 @@ L:	linux-serial@vger.kernel.org
 W:	http://serial.sourceforge.net
 S:	Orphan
 
 8390 NETWORK DRIVERS [WD80x3/SMC-ELITE, SMC-ULTRA, NE2000, 3C503, etc.]
 P:	Paul Gortmaker
 M:	p_gortmaker@yahoo.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/*8390*
 F:	drivers/net/ax88796.c
 
 9P FILE SYSTEM
 P:	Eric Van Hensbergen
 M:	ericvh@gmail.com
 P:	Ron Minnich
 M:	rminnich@sandia.gov
 P:	Latchesar Ionkov
 M:	lucho@ionkov.net
 L:	v9fs-developer@lists.sourceforge.net
 W:	http://swik.net/v9fs
-T:	git kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git
 S:	Maintained
 F:	fs/9p/
 
 A2232 SERIAL BOARD DRIVER
 P:	Enver Haase
 M:	A2232@gmx.net
 L:	linux-m68k@lists.linux-m68k.org
 S:	Maintained
 F:	drivers/char/ser_a2232*
 
 AACRAID SCSI RAID DRIVER
 P:	Adaptec OEM Raid Solutions
 M:	aacraid@adaptec.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.adaptec.com/
 S:	Supported
 F:	Documentation/scsi/aacraid.txt
 F:	drivers/scsi/aacraid/
 
 ABIT UGURU 1,2 HARDWARE MONITOR DRIVER
@@ -215,41 +215,41 @@ F:	drivers/hwmon/abituguru3.c
 ACENIC DRIVER
 P:	Jes Sorensen
 M:	jes@trained-monkey.org
 L:	linux-acenic@sunsite.dk
 S:	Maintained
 F:	drivers/net/acenic*
 
 ACER WMI LAPTOP EXTRAS
 P:	Carlos Corbacho
 M:	carlos@strangeworlds.co.uk
 L:	aceracpi@googlegroups.com (subscribers-only)
 W:	http://code.google.com/p/aceracpi
 S:	Maintained
 F:	drivers/misc/acer-wmi.c
 
 ACPI
 P:	Len Brown
 M:	lenb@kernel.org
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
-T:	git kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
 S:	Supported
 F:	drivers/acpi/
 F:	drivers/pnp/pnpacpi/
 
 ACPI BATTERY DRIVERS
 P:	Alexey Starikovskiy
 M:	astarikovskiy@suse.de
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 S:	Supported
 F:	drivers/acpi/battery.c
 F:	drivers/acpi/*sbs*
 
 ACPI EC DRIVER
 P:	Alexey Starikovskiy
 M:	astarikovskiy@suse.de
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 S:	Supported
 F:	drivers/acpi/ec.c
@@ -306,41 +306,41 @@ F:	sound/pci/ad1889.*
 ADM1025 HARDWARE MONITOR DRIVER
 P:	Jean Delvare
 M:	khali@linux-fr.org
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/adm1025
 F:	drivers/hwmon/adm1025.c
 
 ADM1029 HARDWARE MONITOR DRIVER
 P:	Corentin Labbe
 M:	corentin.labbe@geomatys.fr
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	drivers/hwmon/adm1029.c
 
 ADM8211 WIRELESS DRIVER
 P:	Michael Wu
 M:	flamingice@sourmilk.net
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
 S:	Maintained
 F:	drivers/net/wireless/adm8211.*
 
 ADT746X FAN DRIVER
 P:	Colin Leroy
 M:	colin@colino.net
 S:	Maintained
 F:	drivers/macintosh/therm_adt746x.c
 
 ADVANSYS SCSI DRIVER
 P:	Matthew Wilcox
 M:	matthew@wil.cx
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	Documentation/scsi/advansys.txt
 F:	drivers/scsi/advansys.c
 
 AEDSP16 DRIVER
 P:	Riccardo Facchetti
 M:	fizban@tin.it
@@ -348,41 +348,41 @@ S:	Maintained
 F:	sound/oss/aedsp16.c
 
 AFFS FILE SYSTEM
 P:	Roman Zippel
 M:	zippel@linux-m68k.org
 S:	Maintained
 F:	fs/affs/
 
 AFS FILESYSTEM & AF_RXRPC SOCKET DOMAIN
 P:	David Howells
 M:	dhowells@redhat.com
 L:	linux-afs@lists.infradead.org
 S:	Supported
 F:	fs/afs/
 F:	include/net/af_rxrpc.h
 F:	net/rxrpc/af_rxrpc.c
 
 AGPGART DRIVER
 P:	David Airlie
 M:	airlied@linux.ie
-T:	git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
 F:	drivers/char/agp/
 F:	include/linux/agp*
 
 AHA152X SCSI DRIVER
 P:	Juergen E. Fischer
 M:	fischer@norbit.de
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/aha152x*
 F:	drivers/scsi/pcmcia/aha152x*
 
 AIC7XXX / AIC79XX SCSI DRIVER
 P:	Hannes Reinecke
 M:	hare@suse.de
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/aic7xxx/
 F:	drivers/scsi/aic7xxx_old/
 
@@ -431,41 +431,41 @@ P:	Thomas Dahlmann
 M:	thomas.dahlmann@amd.com
 L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 F:	drivers/usb/gadget/amd5536udc.*
 
 AMD GEODE PROCESSOR/CHIPSET SUPPORT
 P:	Jordan Crouse
 L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.amd.com/us-en/ConnectivitySolutions/TechnicalResources/0,,50_2334_2452_11363,00.html
 S:	Supported
 F:	arch/x86/kernel/geode_32.c
 F:	drivers/char/hw_random/geode-rng.c
 F:	drivers/crypto/geode*
 F:	drivers/video/geode/
 F:	arch/x86/include/asm/geode.h
 
 AMD IOMMU (AMD-VI)
 P:	Joerg Roedel
 M:	joerg.roedel@amd.com
 L:	iommu@lists.linux-foundation.org
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git
 S:	Supported
 
 AMD MICROCODE UPDATE SUPPORT
 P:	Andreas Herrmann
 M:	andeas.herrmann3@amd.com
 L:	amd64-microcode@amd64.org
 S:	Supported
 F:	arch/x86/kernel/microcode_amd.c
 
 AMS (Apple Motion Sensor) DRIVER
 P:	Stelian Pop
 M:	stelian@popies.net
 P:	Michael Hanselmann
 M:	linux-kernel@hansmi.ch
 S:	Supported
 F:	drivers/hwmon/ams/
 
 AMSO1100 RNIC DRIVER
 P:	Tom Tucker
 M:	tom@opengridcomputing.com
@@ -1069,65 +1069,65 @@ F:	drivers/serial/bfin_5xx.c
 BLACKFIN WATCHDOG DRIVER
 P:	Mike Frysinger
 M:	vapier.adi@gmail.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/watchdog/bfin_wdt.c
 
 BLACKFIN I2C TWI DRIVER
 P:	Sonic Zhang
 M:	sonic.zhang@analog.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org/
 S:	Supported
 F:	drivers/i2c/busses/i2c-bfin-twi.c
 
 BLOCK LAYER
 P:	Jens Axboe
 M:	axboe@kernel.dk
 L:	linux-kernel@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
 S:	Maintained
 F:	block/
 
 BLOCK2MTD DRIVER
 P:	Joern Engel
 M:	joern@lazybastard.org
 L:	linux-mtd@lists.infradead.org
 S:	Maintained
 F:	drivers/mtd/devices/block2mtd.c
 
 BLUETOOTH DRIVERS
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
 S:	Maintained
 F:	drivers/bluetooth/
 
 BLUETOOTH SUBSYSTEM
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/holtmann/bluetooth-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/holtmann/bluetooth-2.6.git
 S:	Maintained
 F:	net/bluetooth/
 F:	include/net/bluetooth/
 
 BONDING DRIVER
 P:	Jay Vosburgh
 M:	fubar@us.ibm.com
 L:	bonding-devel@lists.sourceforge.net
 W:	http://sourceforge.net/projects/bonding/
 S:	Supported
 F:	drivers/net/bonding/
 F:	include/linux/if_bonding.h
 
 BROADCOM B44 10/100 ETHERNET DRIVER
 P:	Gary Zambrano
 M:	zambrano@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/b44.*
 
@@ -1157,41 +1157,41 @@ BSG (block layer generic sg v4 driver)
 P:	FUJITA Tomonori
 M:	fujita.tomonori@lab.ntt.co.jp
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	block/bsg.c
 F:	include/linux/bsg.h
 
 BT8XXGPIO DRIVER
 P:	Michael Buesch
 M:	mb@bu3sch.de
 W:	http://bu3sch.de/btgpio.php
 S:	Maintained
 F:	drivers/gpio/bt8xxgpio.c
 
 BTTV VIDEO4LINUX DRIVER
 P:	Mauro Carvalho Chehab
 M:	mchehab@infradead.org
 M:	v4l-dvb-maintainer@linuxtv.org
 L:	video4linux-list@redhat.com
 W:	http://linuxtv.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
 F:	Documentation/video4linux/bttv/
 F:	drivers/media/video/bt8xx/bttv*
 
 CAFE CMOS INTEGRATED CAMERA CONTROLLER DRIVER
 P:	Jonathan Corbet
 M:	corbet@lwn.net
 L:	video4linux-list@redhat.com
 S:	Maintained
 F:	Documentation/video4linux/cafe_ccic
 F:	drivers/media/video/cafe_ccic*
 
 CALGARY x86-64 IOMMU
 P:	Muli Ben-Yehuda
 M:	muli@il.ibm.com
 P:	Jon D. Mason
 M:	jdmason@kudzu.us
 L:	linux-kernel@vger.kernel.org
 L:	discuss@x86-64.org
 S:	Maintained
@@ -1299,41 +1299,41 @@ L:	alsa-devel@alsa-project.org
 S:	Supported
 F:	sound/soc/codecs/cs4270*
 F:	sound/soc/fsl/mpc8610_hpcd.c
 
 CODA FILE SYSTEM
 P:	Jan Harkes
 M:	jaharkes@cs.cmu.edu
 M:	coda@cs.cmu.edu
 L:	codalist@coda.cs.cmu.edu
 W:	http://www.coda.cs.cmu.edu/
 S:	Maintained
 F:	fs/coda/
 F:	include/linux/coda*.h
 
 COMMON INTERNET FILE SYSTEM (CIFS)
 P:	Steve French
 M:	sfrench@samba.org
 L:	linux-cifs-client@lists.samba.org
 L:	samba-technical@lists.samba.org
 W:	http://linux-cifs.samba.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
 S:	Supported
 F:	fs/cifs/
 
 COMPACTPCI HOTPLUG CORE
 P:	Scott Murray
 M:	scottm@somanetworks.com
 M:	scott@spiteful.org
 L:	linux-pci@vger.kernel.org
 S:	Supported
 F:	drivers/pci/hotplug/cpci_hotplug*
 
 COMPACTPCI HOTPLUG ZIATECH ZT5550 DRIVER
 P:	Scott Murray
 M:	scottm@somanetworks.com
 M:	scott@spiteful.org
 L:	linux-pci@vger.kernel.org
 S:	Supported
 F:	drivers/pci/hotplug/cpcihp_zt5550.*
 
 COMPACTPCI HOTPLUG GENERIC DRIVER
@@ -1385,41 +1385,41 @@ F:	kernel/cgroup*
 CORETEMP HARDWARE MONITORING DRIVER
 P:	Rudolf Marek
 M:	r.marek@assembler.cz
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/coretemp
 F:	drivers/hwmon/coretemp.c
 
 COSA/SRP SYNC SERIAL DRIVER
 P:	Jan "Yenya" Kasprzak
 M:	kas@fi.muni.cz
 W:	http://www.fi.muni.cz/~kas/cosa/
 S:	Maintained
 F:	drivers/net/wan/cosa*
 
 CPU FREQUENCY DRIVERS
 P:	Dave Jones
 M:	davej@redhat.com
 L:	cpufreq@vger.kernel.org
 W:	http://www.codemonkey.org.uk/projects/cpufreq/
-T:	git kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git
 S:	Maintained
 F:	arch/x86/kernel/cpu/cpufreq/
 F:	drivers/cpufreq/
 F:	include/linux/cpufreq.h
 
 CPUID/MSR DRIVER
 P:	H. Peter Anvin
 M:	hpa@zytor.com
 S:	Maintained
 F:	arch/x86/kernel/cpuid.c
 F:	arch/x86/kernel/msr.c
 
 CPUSETS
 P:	Paul Menage
 M:	menage@google.com
 L:	linux-kernel@vger.kernel.org
 W:	http://www.bullopensource.org/cpuset/
 W:	http://oss.sgi.com/projects/cpusets/
 S:	Supported
 F:	Documentation/cpusets.txt
@@ -1432,41 +1432,41 @@ S:	Orphan
 F:	Documentation/filesystems/cramfs.txt
 F:	fs/cramfs/
 
 CRIS PORT
 P:	Mikael Starvik
 M:	starvik@axis.com
 P:	Jesper Nilsson
 M:	jesper.nilsson@axis.com
 L:	dev-etrax@axis.com
 W:	http://developer.axis.com
 S:	Maintained
 F:	arch/cris/
 F:	include/asm-cris/
 
 CRYPTO API
 P:	Herbert Xu
 M:	herbert@gondor.apana.org.au
 P:	David S. Miller
 M:	davem@davemloft.net
 L:	linux-crypto@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
 S:	Maintained
 F:	crypto/
 
 CS5535 Audio ALSA driver
 P:	Jaya Kumar
 M:	jayakumar.alsa@gmail.com
 S:	Maintained
 F:	sound/pci/cs5535audio/
 
 CX18 VIDEO4LINUX DRIVER
 P:	Hans Verkuil
 M:	hverkuil@xs4all.nl
 P:	Andy Walls
 M:	awalls@radix.net
 L:	ivtv-devel@ivtvdriver.org
 L:	ivtv-users@ivtvdriver.org
 L:	video4linux-list@redhat.com
 W:	http://linuxtv.org
 S:	Maintained
 F:	Documentation/video4linux/cx18.txt
@@ -1645,41 +1645,41 @@ W:	http://www.win.tue.nl/~aeb/linux/Large-Disk.html
 W:	http://www.win.tue.nl/~aeb/linux/zip/zip-1.html
 W:	http://www.win.tue.nl/~aeb/partitions/partition_types-1.html
 S:	Maintained
 
 DISKQUOTA
 P:	Jan Kara
 M:	jack@suse.cz
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/quota.txt
 F:	fs/quota*
 F:	include/linux/quota*.h
 
 DISTRIBUTED LOCK MANAGER (DLM)
 P:	Christine Caulfield
 M:	ccaulfie@redhat.com
 P:	David Teigland
 M:	teigland@redhat.com
 L:	cluster-devel@redhat.com
 W:	http://sources.redhat.com/cluster/
-T:	git kernel.org:/pub/scm/linux/kernel/git/teigland/dlm.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git
 S:	Supported
 F:	fs/dlm/
 
 DMA GENERIC OFFLOAD ENGINE SUBSYSTEM
 P:	Maciej Sosnowski
 M:	maciej.sosnowski@intel.com
 P:	Dan Williams
 M:	dan.j.williams@intel.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/dma/
 F:	include/linux/dma*
 
 DME1737 HARDWARE MONITOR DRIVER
 P:	Juerg Haefliger
 M:	juergh@gmail.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/dme1737
 F:	drivers/hwmon/dme1737.c
@@ -1720,57 +1720,57 @@ W:	http://www.adaptec.com/
 S:	Maintained
 F:	drivers/scsi/dpt*
 F:	drivers/scsi/dpt/
 
 DRIVER CORE, KOBJECTS, AND SYSFS
 P:	Greg Kroah-Hartman
 M:	gregkh@suse.de
 L:	linux-kernel@vger.kernel.org
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 S:	Supported
 F:	Documentation/kobject.txt
 F:	drivers/base/core.c
 F:	fs/sysfs/
 F:	include/linux/kobj*
 F:	lib/kobj*
 
 DRM DRIVERS
 P:	David Airlie
 M:	airlied@linux.ie
 L:	dri-devel@lists.sourceforge.net
-T:	git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
 F:	drivers/gpu/drm/
 
 DSCC4 DRIVER
 P:	Francois Romieu
 M:	romieu@fr.zoreil.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wan/dscc4.c
 
 DVB SUBSYSTEM AND DRIVERS
 P:	LinuxTV.org Project
 M:	v4l-dvb-maintainer@linuxtv.org
 L:	linux-dvb@linuxtv.org (subscription required)
 W:	http://linuxtv.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
 F:	Documentation/dvb/
 F:	drivers/media/dvb/
 F:	drivers/media/common/saa7146*.c
 F:	include/linux/dvb/
 
 DZ DECSTATION DZ11 SERIAL DRIVER
 P:	Maciej W. Rozycki
 M:	macro@linux-mips.org
 S:	Maintained
 F:	drivers/serial/dz.*
 
 EATA-DMA SCSI DRIVER
 P:	Michael Neuffer
 M:	mike@i-Connect.Net
 L:	linux-eata@i-connect.net
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/eata*
 
@@ -2024,41 +2024,41 @@ L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
 F:	include/linux/fcntl.h
 F:	include/linux/fs.h
 F:	fs/fcntl.c
 F:	fs/locks.c
 
 FILESYSTEMS (VFS and infrastructure)
 P:	Alexander Viro
 M:	viro@zeniv.linux.org.uk
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
 F:	fs/*
 
 FIREWIRE SUBSYSTEM
 P:	Kristian Hoegsberg
 M:	krh@redhat.com
 P:	Stefan Richter
 M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
 F:	drivers/firewire/
 F:	include/linux/firewire*.h
 
 FIRMWARE LOADER (request_firmware)
 L:	linux-kernel@vger.kernel.org
 S:	Orphan
 F:	Documentation/firmware_class/
 F:	drivers/base/firmware*.c
 F:	include/linux/firmware.h
 
 FPU EMULATOR
 P:	Bill Metzenthen
 M:	billm@suburbia.net
 W:	http://suburbia.net/~billm/floating-point/emulator/
 S:	Maintained
 F:	arch/x86/math-emu/
 
 FRAME RELAY DLCI/FRAD (Sangoma drivers too)
 P:	Mike McLagan
@@ -2209,42 +2209,42 @@ F:	drivers/i2c/busses/i2c-gpio.c
 F:	include/linux/i2c-gpio.h
 
 GENERIC HDLC DRIVER, N2, C101, PCI200SYN and WANXL DRIVERS
 P:	Krzysztof Halasa
 M:	khc@pm.waw.pl
 W:	http://www.kernel.org/pub/linux/utils/net/hdlc/
 S:	Maintained
 F:	drivers/net/wan/c101.c
 F:	drivers/net/wan/hd6457x.c
 F:	drivers/net/wan/hdlc*
 F:	drivers/net/wan/n2.c
 F:	drivers/net/wan/pc300too.c
 F:	drivers/net/wan/pci200syn.c
 F:	drivers/net/wan/wanxl*
 
 GFS2 FILE SYSTEM
 P:	Steven Whitehouse
 M:	swhiteho@redhat.com
 L:	cluster-devel@redhat.com
 W:	http://sources.redhat.com/cluster/
-T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git
-T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git
 S:	Supported
 F:	Documentation/filesystems/gfs2.txt
 F:	fs/gfs2/
 F:	include/linux/gfs2_ondisk.h
 F:	include/linux/lm_interface.h
 
 GIGASET ISDN DRIVERS
 P:	Hansjoerg Lipp
 M:	hjlipp@web.de
 P:	Tilman Schmidt
 M:	tilman@imap.cc
 L:	gigaset307x-common@lists.sourceforge.net
 W:	http://gigaset307x.sourceforge.net/
 S:	Maintained
 F:	Documentation/isdn/README.gigaset
 F:	drivers/isdn/gigaset/
 F:	include/linux/gigaset_dev.h
 
 HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
 P:	Robert Love
@@ -2316,41 +2316,41 @@ F:	drivers/video/hgafb.c
 HIBERNATION (aka Software Suspend, aka swsusp)
 P:	Pavel Machek
 M:	pavel@suse.cz
 P:	Rafael J. Wysocki
 M:	rjw@sisk.pl
 L:	linux-pm@lists.linux-foundation.org
 S:	Supported
 F:	arch/x86/power/
 F:	drivers/base/power/
 F:	kernel/power/
 F:	include/linux/suspend.h
 F:	include/linux/freezer.h
 F:	include/linux/pm.h
 F:	include/asm-*/suspend*.h
 F:	arch/*/include/asm/suspend*.h
 
 HID CORE LAYER
 P:	Jiri Kosina
 M:	jkosina@suse.cz
 L:	linux-input@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
 F:	drivers/hid/
 F:	include/linux/hid*
 
 HIGH-RESOLUTION TIMERS, CLOCKEVENTS, DYNTICKS
 P:	Thomas Gleixner
 M:	tglx@linutronix.de
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/timers/
 F:	kernel/hrtimer.c
 F:	include/linux/hrtimer.h
 
 HIGH-SPEED SCC DRIVER FOR AX.25
 P:	Klaus Kudielka
 M:	klaus.kudielka@ieee.org
 L:	linux-hams@vger.kernel.org
 W:	http://www.nt.tuwien.ac.at/~kkudielk/Linux/
 S:	Maintained
 F:	drivers/net/hamradio/dmascc.c
@@ -2460,49 +2460,49 @@ F:	include/linux/i2c.h
 F:	include/linux/i2c-dev.h
 F:	include/linux/i2c-id.h
 
 I2C-TINY-USB DRIVER
 P:	Till Harbaum
 M:	till@harbaum.org
 L:	i2c@lm-sensors.org
 T:	http://www.harbaum.org/till/i2c_tiny_usb
 S:	Maintained
 F:	drivers/i2c/busses/i2c-tiny-usb.c
 
 i386 BOOT CODE
 P:	H. Peter Anvin
 M:	hpa@zytor.com
 L:	Linux-Kernel@vger.kernel.org
 S:	Maintained
 
 i386 SETUP CODE / CPU ERRATA WORKAROUNDS
 P:	H. Peter Anvin
 M:	hpa@zytor.com
-T:	git.kernel.org:/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git
 S:	Maintained
 
 IA64 (Itanium) PLATFORM
 P:	Tony Luck
 M:	tony.luck@intel.com
 L:	linux-ia64@vger.kernel.org
 W:	http://www.ia64-linux.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6.git
 S:	Maintained
 
 IBM MCA SCSI SUBSYSTEM DRIVER
 P:	Michael Lang
 M:	langa2@kph.uni-mainz.de
 W:	http://www.uni-mainz.de/~langm000/linux.html
 S:	Maintained
 F:	drivers/scsi/ibmmca.c
 
 IBM Power Linux RAID adapter
 P:	Brian King
 M:	brking@us.ibm.com
 S:	Supported
 F:	drivers/scsi/ipr.*
 
 IBM ServeRAID RAID DRIVER
 P:	Jack Hammer
 P:	Dave Jeffery
 M:	ipslinux@adaptec.com
 W:	http://www.developer.ibm.com/welcome/netfinity/serveraid.html
@@ -2544,126 +2544,126 @@ F:	drivers/ide/ide-tape.c
 
 IDE-SCSI DRIVER
 L:	linux-ide@vger.kernel.org
 L:	linux-scsi@vger.kernel.org
 S:	Orphan
 
 IDLE-I7300
 P:	Andy Henroid
 M:	andrew.d.henroid@intel.com
 L:	linux-pm@lists.linux-foundation.org
 S:	Supported
 F:	drivers/idle/i7300_idle.c
 
 IEEE 1394 SUBSYSTEM
 P:	Ben Collins
 M:	ben.collins@ubuntu.com
 P:	Stefan Richter
 M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
 F:	drivers/ieee1394/
 
 IEEE 1394 RAW I/O DRIVER
 P:	Dan Dennedy
 M:	dan@dennedy.org
 P:	Stefan Richter
 M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 S:	Maintained
 F:	drivers/ieee1394/raw1394*
 
 IMS TWINTURBO FRAMEBUFFER DRIVER
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Orphan
 F:	drivers/video/imsttfb.c
 
 INFINIBAND SUBSYSTEM
 P:	Roland Dreier
 M:	rolandd@cisco.com
 P:	Sean Hefty
 M:	sean.hefty@intel.com
 P:	Hal Rosenstock
 M:	hal.rosenstock@gmail.com
 L:	general@lists.openfabrics.org
 W:	http://www.openib.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git
 S:	Supported
 F:	Documentation/infiniband/
 F:	drivers/infiniband/
 F:	include/linux/if_infiniband.h
 
 INOTIFY
 P:	John McCutchan
 M:	ttb@tentacle.dhs.org
 P:	Robert Love
 M:	rml@novell.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/inotify.txt
 F:	fs/inotify*
 
 INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHSCREEN) DRIVERS
 P:	Dmitry Torokhov
 M:	dmitry.torokhov@gmail.com
 M:	dtor@mail.ru
 L:	linux-input@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/dtor/input.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
 S:	Maintained
 F:	drivers/input/
 
 INTEL FRAMEBUFFER DRIVER (excluding 810 and 815)
 P:	Sylvain Meyer
 M:	sylvain.meyer@worldonline.fr
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	Documentation/fb/intelfb.txt
 F:	drivers/video/intelfb/
 
 INTEL 810/815 FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/video/i810/
 
 INTEL IA32 MICROCODE UPDATE SUPPORT
 P:	Tigran Aivazian
 M:	tigran@aivazian.fsnet.co.uk
 S:	Maintained
 F:	arch/x86/kernel/microcode_core.c
 F:	arch/x86/kernel/microcode_intel.c
 
 INTEL I/OAT DMA DRIVER
 P:	Maciej Sosnowski
 M:	maciej.sosnowski@intel.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/dma/ioat*
 
 INTEL IOMMU (VT-d)
 P:	David Woodhouse
 M:	dwmw2@infradead.org
 L:	iommu@lists.linux-foundation.org
-T:	git://git.infradead.org/iommu-2.6.git
+T:	git git.infradead.org/iommu-2.6.git
 S:	Supported
 F:	drivers/pci/intel-iommu.c
 F:	include/linux/intel-iommu.h
 
 INTEL IOP-ADMA DMA DRIVER
 P:	Dan Williams
 M:	dan.j.williams@intel.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/dma/iop-adma.c
 
 INTEL IXP4XX RANDOM NUMBER GENERATOR SUPPORT
 P:	Deepak Saxena
 M:	dsaxena@plexity.net
 S:	Maintained
 F:	drivers/char/hw_random/ixp4xx-rng.c
 
 INTEL IXP2000 ETHERNET DRIVER
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
@@ -2712,199 +2712,199 @@ P:	Zhu Yi
 M:	yi.zhu@intel.com
 P:	James Ketrenos
 M:	jketreno@linux.intel.com
 P:	Reinette Chatre
 M:	reinette.chatre@intel.com
 L:	linux-wireless@vger.kernel.org
 L:	ipw2100-devel@lists.sourceforge.net
 W:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
 W:	http://ipw2200.sourceforge.net
 S:	Supported
 F:	drivers/net/wireless/ipw2200.*
 
 INTEL WIRELESS WIFI LINK (iwlwifi)
 P:	Zhu Yi
 M:	yi.zhu@intel.com
 P:	Reinette Chatre
 M:	reinette.chatre@intel.com
 L:	linux-wireless@vger.kernel.org
 L:	ipw3945-devel@lists.sourceforge.net
 W:	http://intellinuxwireless.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
 S:	Supported
 F:	drivers/net/wireless/iwlwifi/
 
 IOC3 ETHERNET DRIVER
 P:	Ralf Baechle
 M:	ralf@linux-mips.org
 L:	linux-mips@linux-mips.org
 S:	Maintained
 F:	drivers/net/ioc3-eth.c
 
 IOC3 SERIAL DRIVER
 P:	Pat Gefre
 M:	pfg@sgi.com
 L:	linux-mips@linux-mips.org
 S:	Maintained
 F:	drivers/serial/ioc3_serial.c
 
 IP MASQUERADING
 P:	Juanjo Ciarlante
 M:	jjciarla@raiz.uncu.edu.ar
 S:	Maintained
 F:	net/ipv4/netfilter/ipt_MASQUERADE.c
 
 IP1000A 10/100/1000 GIGABIT ETHERNET DRIVER
 P:	Francois Romieu
 M:	romieu@fr.zoreil.com
 P:	Sorbica Shieh
 M:	sorbica@icplus.com.tw
 P:	Jesse Huang
 M:	jesse@icplus.com.tw
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ipg.c
 
 IPATH DRIVER
 P:	Ralph Campbell
 M:	infinipath@qlogic.com
 L:	general@lists.openfabrics.org
-T:	git git://git.qlogic.com/ipath-linux-2.6
+T:	git git.qlogic.com/ipath-linux-2.6
 S:	Supported
 F:	drivers/infiniband/hw/ipath/
 
 IPMI SUBSYSTEM
 P:	Corey Minyard
 M:	minyard@acm.org
 L:	openipmi-developer@lists.sourceforge.net
 W:	http://openipmi.sourceforge.net/
 S:	Supported
 F:	Documentation/IPMI.txt
 F:	drivers/char/ipmi/
 F:	include/linux/ipmi*
 
 IPS SCSI RAID DRIVER
 P:	Adaptec OEM Raid Solutions
 M:	aacraid@adaptec.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.adaptec.com/
 S:	Maintained
 F:	drivers/scsi/ips*
 
 IPVS
 P:	Wensong Zhang
 M:	wensong@linux-vs.org
 P:	Simon Horman
 M:	horms@verge.net.au
 P:	Julian Anastasov
 M:	ja@ssi.bg
 L:	netdev@vger.kernel.org
 L:	lvs-devel@vger.kernel.org
 S:	Maintained
 F:	Documentation/networking/ipvs-sysctl.txt
 F:	net/netfilter/ipvs/
 
 IPWIRELESS DRIVER
 P:	Jiri Kosina
 M:	jkosina@suse.cz
 P:	David Sterba
 M:	dsterba@suse.cz
 S:	Maintained
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/jikos/ipwireless_cs.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/jikos/ipwireless_cs.git
 F:	drivers/char/pcmcia/ipwireless/
 
 IPX NETWORK LAYER
 P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	include/linux/ipx.h
 F:	include/net/ipx.h
 F:	net/ipx/
 
 IRDA SUBSYSTEM
 P:	Samuel Ortiz
 M:	samuel@sortiz.org
 L:	irda-users@lists.sourceforge.net (subscribers-only)
 W:	http://irda.sourceforge.net/
 S:	Maintained
 F:	Documentation/networking/irda.txt
 F:	drivers/net/irda/
 F:	include/net/irda/
 F:	net/irda/
 
 ISAPNP
 P:	Jaroslav Kysela
 M:	perex@perex.cz
 S:	Maintained
 F:	Documentation/isapnp.txt
 F:	drivers/pnp/isapnp/
 F:	include/linux/isapnp.h
 
 ISCSI
 P:	Mike Christie
 M:	michaelc@cs.wisc.edu
 L:	open-iscsi@googlegroups.com
 W:	www.open-iscsi.org
-T:	git kernel.org:/pub/scm/linux/kernel/mnc/linux-2.6-iscsi.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/mnc/linux-2.6-iscsi.git
 S:	Maintained
 F:	drivers/scsi/*iscsi*
 F:	include/scsi/*iscsi*
 
 ISDN SUBSYSTEM
 P:	Karsten Keil
 M:	kkeil@suse.de
 L:	isdn4linux@listserv.isdn4linux.de (subscribers-only)
 W:	http://www.isdn4linux.de
-T:	git kernel.org:/pub/scm/linux/kernel/kkeil/isdn-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/kkeil/isdn-2.6.git
 S:	Maintained
 F:	Documentation/isdn/
 F:	drivers/isdn/
 F:	include/linux/isdn.h
 F:	include/linux/isdn/
 
 ISDN SUBSYSTEM (Eicon active card driver)
 P:	Armin Schindler
 M:	mac@melware.de
 L:	isdn4linux@listserv.isdn4linux.de (subscribers-only)
 W:	http://www.melware.de
 S:	Maintained
 F:	drivers/isdn/hardware/eicon/
 
 IVTV VIDEO4LINUX DRIVER
 P:	Hans Verkuil
 M:	hverkuil@xs4all.nl
 L:	ivtv-devel@ivtvdriver.org
 L:	ivtv-users@ivtvdriver.org
 L:	video4linux-list@redhat.com
 W:	http://www.ivtvdriver.org
 S:	Maintained
 F:	Documentation/video4linux/*.ivtv
 F:	drivers/media/video/ivtv/
 F:	include/linux/ivtv*
 
 JFS FILESYSTEM
 P:	Dave Kleikamp
 M:	shaggy@austin.ibm.com
 L:	jfs-discussion@lists.sourceforge.net
 W:	http://jfs.sourceforge.net/
-T:	git kernel.org:/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git
 S:	Supported
 F:	Documentation/filesystems/jfs.txt
 F:	fs/jfs/
 
 JME NETWORK DRIVER
 P:	Guo-Fu Tseng
 M:	cooldavid@cooldavid.org
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/jme.*
 
 JOURNALLING FLASH FILE SYSTEM V2 (JFFS2)
 P:	David Woodhouse
 M:	dwmw2@infradead.org
 L:	linux-mtd@lists.infradead.org
 W:	http://www.linux-mtd.infradead.org/doc/jffs2.html
 S:	Maintained
 F:	fs/jffs2/
 F:	include/linux/jffs2.h
 F:	include/mtd/jffs2-user.h
@@ -2947,42 +2947,42 @@ W:	http://lse.sourceforge.net/kdump/
 S:	Maintained
 F:	Documentation/kdump
 
 KERNEL AUTOMOUNTER (AUTOFS)
 P:	H. Peter Anvin
 M:	hpa@zytor.com
 L:	autofs@linux.kernel.org
 S:	Odd Fixes
 F:	fs/autofs/
 
 KERNEL AUTOMOUNTER v4 (AUTOFS4)
 P:	Ian Kent
 M:	raven@themaw.net
 L:	autofs@linux.kernel.org
 S:	Maintained
 F:	fs/autofs4/
 
 KERNEL BUILD
 P:	Sam Ravnborg
 M:	sam@ravnborg.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-next.git
-T:	git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-fixes.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-next.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git
 L:	linux-kbuild@vger.kernel.org
 S:	Maintained
 F:	Documentation/kbuild/
 F:	Makefile
 F:	scripts/Makefile.*
 
 KERNEL JANITORS
 P:	Several
 L:	kernel-janitors@vger.kernel.org
 W:	http://www.kerneljanitors.org/
 S:	Maintained
 
 KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
 P:	J. Bruce Fields
 M:	bfields@fieldses.org
 P:	Neil Brown
 M:	neilb@suse.de
 L:	linux-nfs@vger.kernel.org
 W:	http://nfs.sourceforge.net/
 S:	Supported
@@ -3138,136 +3138,136 @@ W:	http://www.ibm.com/linux/ltc/projects/ppc
 S:	Supported
 
 LINUX FOR NCR VOYAGER
 P:	James Bottomley
 M:	James.Bottomley@HansenPartnership.com
 W:	http://www.hansenpartnership.com/voyager
 S:	Maintained
 F:	Documentation/voyager.txt
 F:	arch/x86/boot/voyager.c
 F:	arch/x86/mach-voyager/
 F:	arch/x86/include/asm/mach-voyager/
 F:	arch/x86/include/asm/voyager.h
 
 LINUX FOR POWERPC (32-BIT AND 64-BIT)
 P:	Paul Mackerras
 M:	paulus@samba.org
 P:	Benjamin Herrenschmidt
 M:	benh@kernel.crashing.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/paulus/powerpc.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git
 S:	Supported
 
 LINUX FOR POWER MACINTOSH
 P:	Benjamin Herrenschmidt
 M:	benh@kernel.crashing.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
 S:	Maintained
 
 LINUX FOR POWERPC EMBEDDED MPC5XXX
 P:	Sylvain Munaut
 M:	tnt@246tNt.com
 P:	Grant Likely
 M:	grant.likely@secretlab.ca
 L:	linuxppc-dev@ozlabs.org
 S:	Maintained
 
 LINUX FOR POWERPC EMBEDDED PPC4XX
 P:	Josh Boyer
 M:	jwboyer@linux.vnet.ibm.com
 P:	Matt Porter
 M:	mporter@kernel.crashing.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jwboyer/powerpc.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/jwboyer/powerpc.git
 S:	Maintained
 
 LINUX FOR POWERPC EMBEDDED XILINX VIRTEX
 P:	Grant Likely
 M:	grant.likely@secretlab.ca
 W:	http://wiki.secretlab.ca/index.php/Linux_on_Xilinx_Virtex
 L:	linuxppc-dev@ozlabs.org
 S:	Maintained
 
 LINUX FOR POWERPC EMBEDDED PPC8XX
 P:	Vitaly Bordug
 M:	vitb@kernel.crashing.org
 P:	Marcelo Tosatti
 M:	marcelo@kvack.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
 S:	Maintained
 
 LINUX FOR POWERPC EMBEDDED PPC83XX AND PPC85XX
 P:	Kumar Gala
 M:	galak@kernel.crashing.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
 S:	Maintained
 
 LINUX FOR POWERPC PA SEMI PWRFICIENT
 P:	Olof Johansson
 M:	olof@lixom.net
 W:	http://www.pasemi.com/
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
 
 LINUX SECURITY MODULE (LSM) FRAMEWORK
 P:	Chris Wright
 M:	chrisw@sous-sol.org
 L:	linux-security-module@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
 S:	Supported
 
 LLC (802.2)
 P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net
 S:	Maintained
 F:	include/linux/llc.h
 F:	include/net/llc*
 F:	net/llc/
 
 LM83 HARDWARE MONITOR DRIVER
 P:	Jean Delvare
 M:	khali@linux-fr.org
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/lm83
 F:	drivers/hwmon/lm83.c
 
 LM90 HARDWARE MONITOR DRIVER
 P:	Jean Delvare
 M:	khali@linux-fr.org
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/lm90
 F:	drivers/hwmon/lm90.c
 
 LOCKDEP AND LOCKSTAT
 P:	Peter Zijlstra
 M:	peterz@infradead.org
 P:	Ingo Molnar
 M:	mingo@redhat.com
 L:	linux-kernel@vger.kernel.org
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git
 S:	Maintained
 F:	Documentation/lockdep*.txt
 F:	Documentation/lockstat.txt
 F:	include/linux/lockdep.h
 F:	kernel/lockdep*
 
 LOGICAL DISK MANAGER SUPPORT (LDM, Windows 2000/XP/Vista Dynamic Disks)
 P:	Richard Russon (FlatCap)
 M:	ldm@flatcap.org
 L:	linux-ntfs-dev@lists.sourceforge.net
 W:	http://www.linux-ntfs.org/content/view/19/37/
 S:	Maintained
 F:	Documentation/ldm.txt
 F:	fs/partitions/ldm.*
 
 LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
 P:	Eric Moore
 M:	Eric.Moore@lsi.com
 M:	support@lsi.com
 L:	DL-MPTFusionLinux@lsi.com
@@ -3310,54 +3310,54 @@ P:	Joshua Thompson
 M:	funaho@jurai.org
 W:	http://www.mac.linux-m68k.org/
 L:	linux-m68k@lists.linux-m68k.org
 S:	Maintained
 
 M68K ON HP9000/300
 P:	Philip Blundell
 M:	philb@gnu.org
 W:	http://www.tazenda.demon.co.uk/phil/linux-hp
 S:	Maintained
 F:	arch/m68k/hp300/
 F:	include/asm-m68k/hp*
 
 MAC80211
 P:	Johannes Berg
 M:	johannes@sipsolutions.net
 P:	Michael Wu
 M:	flamingice@sourmilk.net
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
 F:	Documentation/networking/mac80211-injection.txt
 F:	include/net/mac80211.h
 F:	net/mac80211/
 
 MAC80211 PID RATE CONTROL
 P:	Stefano Brivio
 M:	stefano.brivio@polimi.it
 P:	Mattias Nissler
 M:	mattias.nissler@gmx.de
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/en/developers/Documentation/mac80211/RateControl/PID
-T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
 F:	net/mac80211/rc80211_pid*
 
 MACVLAN DRIVER
 P:	Patrick McHardy
 M:	kaber@trash.net
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/macvlan.c
 F:	include/linux/if_macvlan.h
 
 MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2, 3, 4, 5, and 7
 P:	Michael Kerrisk
 M:	mtk.manpages@gmail.com
 W:	http://www.kernel.org/doc/man-pages
 L:	linux-man@vger.kernel.org
 S:	Supported
 
 MARVELL LIBERTAS WIRELESS DRIVER
 P:	Dan Williams
@@ -3416,58 +3416,58 @@ S:	Maintained
 F:	include/linux/mm.h
 F:	mm/
 
 MEMORY RESOURCE CONTROLLER
 P:	Balbir Singh
 M:	balbir@linux.vnet.ibm.com
 P:	Pavel Emelyanov
 M:	xemul@openvz.org
 P:	KAMEZAWA Hiroyuki
 M:	kamezawa.hiroyu@jp.fujitsu.com
 L:	linux-mm@kvack.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	mm/memcontrol.c
 
 MEMORY TECHNOLOGY DEVICES (MTD)
 P:	David Woodhouse
 M:	dwmw2@infradead.org
 W:	http://www.linux-mtd.infradead.org/
 L:	linux-mtd@lists.infradead.org
-T:	git git://git.infradead.org/mtd-2.6.git
+T:	git git.infradead.org/mtd-2.6.git
 S:	Maintained
 F:	drivers/mtd/
 F:	include/linux/mtd/
 F:	include/mtd/
 
 MICROTEK X6 SCANNER
 P:	Oliver Neukum
 M:	oliver@neukum.name
 S:	Maintained
 F:	drivers/usb/image/microtek.*
 
 MIPS
 P:	Ralf Baechle
 M:	ralf@linux-mips.org
 W:	http://www.linux-mips.org/
 L:	linux-mips@linux-mips.org
-T:	git www.linux-mips.org:/pub/scm/linux.git
+T:	git www.linux-mips.org/pub/scm/linux.git
 S:	Supported
 F:	Documentation/mips/
 F:	arch/mips/
 
 MISCELLANEOUS MCA-SUPPORT
 P:	James Bottomley
 M:	James.Bottomley@HansenPartnership.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/ia64/mca.txt
 F:	Documentation/mca.txt
 F:	drivers/mca/
 F:	include/linux/mca*
 
 MODULE SUPPORT
 P:	Rusty Russell
 M:	rusty@rustcorp.com.au
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	include/linux/module.h
@@ -3654,104 +3654,104 @@ P:	Ralf Baechle
 M:	ralf@linux-mips.org
 L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained
 F:	include/linux/netrom.h
 F:	include/net/netrom.h
 F:	net/netrom/
 
 NETWORK BLOCK DEVICE (NBD)
 P:	Paul Clements
 M:	Paul.Clements@steeleye.com
 S:	Maintained
 F:	Documentation/nbd.txt
 F:	drivers/block/nbd.c
 F:	include/linux/nbd.h
 
 NETWORK DEVICE DRIVERS
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
 L:	netdev@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
 S:	Maintained
 F:	drivers/net/
 
 NETWORKING [GENERAL]
 P:	Networking Team
 M:	netdev@vger.kernel.org
 L:	netdev@vger.kernel.org
 W:	http://linux-net.osdl.org/
 S:	Maintained
 F:	net/
 F:	include/net/
 
 NETWORKING [IPv4/IPv6]
 P:	David S. Miller
 M:	davem@davemloft.net
 P:	Alexey Kuznetsov
 M:	kuznet@ms2.inr.ac.ru
 P:	Pekka Savola (ipv6)
 M:	pekkas@netcore.fi
 P:	James Morris
 M:	jmorris@namei.org
 P:	Hideaki YOSHIFUJI
 M:	yoshfuji@linux-ipv6.org
 P:	Patrick McHardy
 M:	kaber@trash.net
 L:	netdev@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
 S:	Maintained
 F:	net/ipv4/
 F:	net/ipv6/
 F:	include/net/ip*
 
 NETWORKING [LABELED] (NetLabel, CIPSO, Labeled IPsec, SECMARK)
 P:	Paul Moore
 M:	paul.moore@hp.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 
 NETWORKING [WIRELESS]
 P:	John W. Linville
 M:	linville@tuxdriver.com
 L:	linux-wireless@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
 F:	net/ieee80211/
 F:	net/wireless/
 F:	include/net/ieee80211*
 F:	include/net/wireless*
 
 NETXEN (1/10) GbE SUPPORT
 P:	Dhananjay Phadke
 M:	dhananjay@netxen.com
 L:	netdev@vger.kernel.org
 W:	http://www.netxen.com
 S:	Supported
 F:	drivers/net/netxen/
 
 NFS, SUNRPC, AND LOCKD CLIENTS
 P:	Trond Myklebust
 M:	Trond.Myklebust@netapp.com
 L:	linux-nfs@vger.kernel.org
 W:	http://client.linux-nfs.org
-T:	git git://git.linux-nfs.org/pub/linux/nfs-2.6.git
+T:	git git.linux-nfs.org/pub/linux/nfs-2.6.git
 S:	Maintained
 F:	fs/lockd/
 F:	fs/nfs/
 F:	fs/nfs_common/
 F:	net/sunrpc/
 F:	include/linux/lockd/
 F:	include/linux/nfs*
 F:	include/linux/sunrpc/
 
 NI5010 NETWORK DRIVER
 P:	Jan-Pascal van Best
 M:	janpascal@vanbest.org
 P:	Andreas Mohr
 M:	andi@lisas.de
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ni5010.*
 
 NINJA SCSI-3 / NINJA SCSI-32Bi (16bit/CardBus) PCMCIA SCSI HOST ADAPTER DRIVER
 P:	YOKOTA Hiroshi
@@ -3760,41 +3760,41 @@ W:	http://www.netlab.is.tsukuba.ac.jp/~yokota/izumi/ninja/
 S:	Maintained
 F:	Documentation/scsi/NinjaSCSI.txt
 F:	drivers/scsi/pcmcia/nsp_*
 
 NINJA SCSI-32Bi/UDE PCI/CARDBUS SCSI HOST ADAPTER DRIVER
 P:	GOTO Masanori
 M:	gotom@debian.or.jp
 P:	YOKOTA Hiroshi
 M:	yokota@netlab.is.tsukuba.ac.jp
 W:	http://www.netlab.is.tsukuba.ac.jp/~yokota/izumi/ninja/
 S:	Maintained
 F:	Documentation/scsi/NinjaSCSI.txt
 F:	drivers/scsi/nsp32*
 
 NTFS FILESYSTEM
 P:	Anton Altaparmakov
 M:	aia21@cantab.net
 L:	linux-ntfs-dev@lists.sourceforge.net
 L:	linux-kernel@vger.kernel.org
 W:	http://www.linux-ntfs.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/aia21/ntfs-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/aia21/ntfs-2.6.git
 S:	Maintained
 F:	Documentation/filesystems/ntfs.txt
 F:	fs/ntfs/
 
 NVIDIA (rivafb and nvidiafb) FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/video/riva/
 F:	drivers/video/nvidia/
 
 OMFS FILESYSTEM
 P:	Bob Copeland
 M:	me@bobcopeland.com
 L:	linux-karma-devel@lists.sourceforge.net
 S:	Maintained
 F:	Documentation/filesystems/omfs.txt
 F:	fs/omfs/
 
@@ -3842,67 +3842,67 @@ L:	i2c@lm-sensors.org
 S:	Maintained
 F:	Documentation/i2c/busses/i2c-ocores
 F:	drivers/i2c/busses/i2c-ocores.c
 
 OPROFILE
 P:	Robert Richter
 M:	robert.richter@amd.com
 L:	oprofile-list@lists.sf.net
 S:	Maintained
 F:	arch/*/oprofile/
 F:	drivers/oprofile/
 F:	include/linux/oprofile.h
 
 ORACLE CLUSTER FILESYSTEM 2 (OCFS2)
 P:	Mark Fasheh
 M:	mfasheh@suse.com
 P:	Joel Becker
 M:	joel.becker@oracle.com
 L:	ocfs2-devel@oss.oracle.com (moderated for non-subscribers)
 W:	http://oss.oracle.com/projects/ocfs2/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git
 S:	Supported
 F:	Documentation/filesystems/ocfs2.txt
 F:	Documentation/filesystems/dlmfs.txt
 F:	fs/ocfs2/
 
 ORINOCO DRIVER
 P:	Pavel Roskin
 M:	proski@gnu.org
 P:	David Gibson
 M:	hermes@gibson.dropbear.id.au
 L:	linux-wireless@vger.kernel.org
 L:	orinoco-users@lists.sourceforge.net
 L:	orinoco-devel@lists.sourceforge.net
 W:	http://www.nongnu.org/orinoco/
 S:	Maintained
 F:	drivers/net/wireless/orinoco*
 F:	drivers/net/wireless/airport*
 F:	drivers/net/wireless/spectrum*
 F:	drivers/net/wireless/hermes*
 
 P54 WIRELESS DRIVER
 P:	Michael Wu
 M:	flamingice@sourmilk.net
 L:	linux-wireless@vger.kernel.org
 W:	http://prism54.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
 S:	Maintained
 
 PA SEMI ETHERNET DRIVER
 P:	Olof Johansson
 M:	olof@lixom.net
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/pasemi_mac.*
 
 PA SEMI SMBUS DRIVER
 P:	Olof Johansson
 M:	olof@lixom.net
 L:	i2c@lm-sensors.org
 S:	Maintained
 F:	drivers/i2c/busses/i2c-pasemi.c
 
 PANASONIC LAPTOP ACPI EXTRAS DRIVER
 P:	Harald Welte
 M:	laforge@gnumonks.org
 S:	Maintained
@@ -3941,92 +3941,92 @@ F:	arch/*/kernel/paravirt*
 F:	arch/*/include/asm/paravirt.h
 
 PARIDE DRIVERS FOR PARALLEL PORT IDE DEVICES
 P:	Tim Waugh
 M:	tim@cyberelk.net
 L:	linux-parport@lists.infradead.org (subscribers-only)
 W:	http://www.torque.net/linux-pp.html
 S:	Maintained
 F:	Documentation/paride.txt
 F:	drivers/block/paride/
 
 PARISC ARCHITECTURE
 P:	Kyle McMartin
 M:	kyle@mcmartin.ca
 P:	Matthew Wilcox
 M:	matthew@wil.cx
 P:	Grant Grundler
 M:	grundler@parisc-linux.org
 L:	linux-parisc@vger.kernel.org
 W:	http://www.parisc-linux.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/kyle/parisc-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/kyle/parisc-2.6.git
 S:	Maintained
 F:	arch/parisc/
 F:	drivers/parisc/
 F:	include/asm-parisc/
 
 PC87360 HARDWARE MONITORING DRIVER
 P:	Jim Cromie
 M:	jim.cromie@gmail.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/pc87360
 F:	drivers/hwmon/pc87360.c
 
 PC8736x GPIO DRIVER
 P:	Jim Cromie
 M:	jim.cromie@gmail.com
 S:	Maintained
 F:	drivers/char/pc8736x_gpio.c
 
 PCI ERROR RECOVERY
 P:	Linas Vepstas
 M:	linas@austin.ibm.com
 L:	linux-kernel@vger.kernel.org
 L:	linux-pci@vger.kernel.org
 S:	Supported
 F:	Documentation/PCI/pci-error-recovery.txt
 F:	Documentation/powerpc/eeh-pci-error-recovery.txt
 
 PCI SUBSYSTEM
 P:	Jesse Barnes
 M:	jbarnes@virtuousgeek.org
 L:	linux-kernel@vger.kernel.org
 L:	linux-pci@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
 S:	Supported
 F:	Documentation/PCI/
 F:	drivers/pci/
 F:	include/linux/pci*
 
 PCIE HOTPLUG DRIVER
 P:	Kristen Carlson Accardi
 M:	kristen.c.accardi@intel.com
 L:	linux-pci@vger.kernel.org
 S:	Supported
 F:	drivers/pci/pcie/
 
 PCMCIA SUBSYSTEM
 P:	Linux PCMCIA Team
 L:	linux-pcmcia@lists.infradead.org
 W:	http://lists.infradead.org/mailman/listinfo/linux-pcmcia
-T:	git kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
 S:	Maintained
 F:	Documentation/pcmcia/
 F:	drivers/pcmcia/
 F:	include/pcmcia/
 
 PCNET32 NETWORK DRIVER
 P:	Don Fry
 M:	pcnet32@verizon.net
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/pcnet32.c
 
 PER-TASK DELAY ACCOUNTING
 P:	Balbir Singh
 M:	balbir@linux.vnet.ibm.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	include/linux/delayacct.h
 F:	kernel/delayacct.c
 
@@ -4223,41 +4223,41 @@ RADEON FRAMEBUFFER DISPLAY DRIVER
 P:	Benjamin Herrenschmidt
 M:	benh@kernel.crashing.org
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/video/aty/radeon*
 F:	include/linux/radeonfb.h
 
 RAGE128 FRAMEBUFFER DISPLAY DRIVER
 P:	Paul Mackerras
 M:	paulus@samba.org
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/video/aty/aty128fb.c
 
 RALINK RT2X00 WIRELESS LAN DRIVER
 P:	rt2x00 project
 L:	linux-wireless@vger.kernel.org
 L:	rt2400-devel@lists.sourceforge.net
 W:	http://rt2x00.serialmonkey.com/
 S:	Maintained
-T:	git kernel.org:/pub/scm/linux/kernel/git/ivd/rt2x00.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git
 F:	drivers/net/wireless/rt2x00/
 
 RAMDISK RAM BLOCK DEVICE DRIVER
 P:	Nick Piggin
 M:	npiggin@suse.de
 S:	Maintained
 F:	drivers/block/brd.c
 
 RANDOM NUMBER DRIVER
 P:	Matt Mackall
 M:	mpm@selenic.com
 S:	Maintained
 F:	drivers/char/random.c
 
 RAPIDIO SUBSYSTEM
 P:	Matt Porter
 M:	mporter@kernel.crashing.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/rapidio/
@@ -4344,41 +4344,41 @@ S:	Maintained
 F:	Documentation/rocket.txt
 F:	drivers/char/rocket*
 
 ROSE NETWORK LAYER
 P:	Ralf Baechle
 M:	ralf@linux-mips.org
 L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained
 F:	include/linux/rose.h
 F:	include/net/rose.h
 F:	net/rose/
 
 RTL818X WIRELESS DRIVER
 P:	Michael Wu
 M:	flamingice@sourmilk.net
 P:	Andrea Merello
 M:	andreamrl@tiscali.it
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
 S:	Maintained
 F:	drivers/net/wireless/rtl818*
 
 S3 SAVAGE FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/video/savage/
 
 S390
 P:	Martin Schwidefsky
 M:	schwidefsky@de.ibm.com
 P:	Heiko Carstens
 M:	heiko.carstens@de.ibm.com
 M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
 F:	arch/s390/
@@ -4453,43 +4453,43 @@ SCSI CDROM DRIVER
 P:	Jens Axboe
 M:	axboe@kernel.dk
 L:	linux-scsi@vger.kernel.org
 W:	http://www.kernel.dk
 S:	Maintained
 F:	drivers/scsi/sr*
 
 SCSI SG DRIVER
 P:	Doug Gilbert
 M:	dgilbert@interlog.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.torque.net/sg
 S:	Maintained
 F:	drivers/scsi/sg.c
 F:	include/scsi/sg.h
 
 SCSI SUBSYSTEM
 P:	James E.J. Bottomley
 M:	James.Bottomley@HansenPartnership.com
 L:	linux-scsi@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
-T:	git kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
-T:	git kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-pending-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-pending-2.6.git
 S:	Maintained
 F:	drivers/scsi/
 F:	include/scsi/
 
 SCSI TAPE DRIVER
 P:	Kai Mäkisara
 M:	Kai.Makisara@kolumbus.fi
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	Documentation/scsi/st.txt
 F:	drivers/scsi/st*
 
 SCTP PROTOCOL
 P:	Vlad Yasevich
 M:	vladislav.yasevich@hp.com
 P:	Sridhar Samudrala
 M:	sri@us.ibm.com
 L:	linux-sctp@vger.kernel.org
 W:	http://lksctp.sourceforge.net
 S:	Supported
@@ -4534,57 +4534,57 @@ P:	Pierre Ossman
 M:	drzeus-sdhci@drzeus.cx
 L:	sdhci-devel@list.drzeus.cx
 S:	Maintained
 F:	drivers/mmc/host/sdhci.*
 
 SECURITY CONTACT
 P:	Security Officers
 M:	security@kernel.org
 S:	Supported
 
 SELINUX SECURITY MODULE
 P:	Stephen Smalley
 M:	sds@tycho.nsa.gov
 P:	James Morris
 M:	jmorris@namei.org
 P:	Eric Paris
 M:	eparis@parisplace.org
 L:	linux-kernel@vger.kernel.org (kernel issues)
 L:	selinux@tycho.nsa.gov (subscribers-only, general discussion)
 W:	http://selinuxproject.org
-T:	git kernel.org:pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
 S:	Supported
 F:	include/linux/selinux*
 F:	security/selinux/
 
 SENSABLE PHANTOM
 P:	Jiri Slaby
 M:	jirislaby@gmail.com
 S:	Maintained
 F:	drivers/misc/phantom.c
 F:	include/linux/phantom.h
 
 SERIAL ATA (SATA) SUBSYSTEM
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
 L:	linux-ide@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
 S:	Supported
 F:	drivers/ata/
 
 SFC NETWORK DRIVER
 P:	Steve Hodgson
 P:	Ben Hutchings
 P:	Robert Stonehouse
 M:	linux-net-drivers@solarflare.com
 S:	Supported
 F:	drivers/net/sfc/
 
 SGI GRU DRIVER
 P:	Jack Steiner
 M:	steiner@sgi.com
 S:	Maintained
 F:	drivers/misc/sgi-gru/
 
 SGI SN-IA64 (Altix) SERIAL CONSOLE DRIVER
 P:	Pat Gefre
 M:	pfg@sgi.com
@@ -4888,41 +4888,41 @@ STRADIS MPEG-2 DECODER DRIVER
 P:	Nathan Laredo
 M:	laredo@gnu.org
 W:	http://www.stradis.com/
 S:	Maintained
 F:	drivers/media/video/stradis.c
 
 SUN3/3X
 P:	Sam Creasey
 M:	sammy@sammy.net
 W:	http://sammy.net/sun3/
 S:	Maintained
 F:	arch/m68k/kernel/*sun3*
 F:	arch/m68k/sun3*/
 F:	include/asm-m68k/sun3*
 
 SUPERH
 P:	Paul Mundt
 M:	lethal@linux-sh.org
 L:	linux-sh@vger.kernel.org
 W:	http://www.linux-sh.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git
 S:	Supported
 F:	arch/sh/
 
 SUSPEND TO RAM
 P:	Len Brown
 M:	len.brown@intel.com
 P:	Pavel Machek
 M:	pavel@suse.cz
 P:	Rafael J. Wysocki
 M:	rjw@sisk.pl
 L:	linux-pm@lists.linux-foundation.org
 S:	Supported
 F:	Documentation/power/
 F:	arch/x86/kernel/acpi/
 F:	drivers/base/power/
 F:	kernel/power/
 F:	include/linux/suspend.h
 F:	include/linux/freezer.h
 F:	include/linux/pm.h
 F:	include/asm-*/suspend.h
@@ -5016,41 +5016,41 @@ M:	linux-omap@vger.kernel.org
 W:	http://linux.omap.com
 W:	http://www.muru.com/linux/omap/
 S:	Maintained
 
 TI OMAP RANDOM NUMBER GENERATOR SUPPORT
 P:	Deepak Saxena
 M:	dsaxena@plexity.net
 S:	Maintained
 F:	drivers/char/hw_random/omap-rng.c
 
 TIPC NETWORK LAYER
 P:	Per Liden
 M:	per.liden@ericsson.com
 P:	Jon Maloy
 M:	jon.maloy@ericsson.com
 P:	Allan Stephens
 M:	allan.stephens@windriver.com
 L:	tipc-discussion@lists.sourceforge.net
 W:	http://tipc.sourceforge.net/
 W:	http://tipc.cslab.ericsson.net/
-T:	git tipc.cslab.ericsson.net:/pub/git/tipc.git
+T:	git tipc.cslab.ericsson.net/pub/git/tipc.git
 S:	Maintained
 F:	include/linux/tipc*.h
 F:	include/net/tipc/
 F:	net/tipc/
 
 TLAN NETWORK DRIVER
 P:	Samuel Chessman
 M:	chessman@tux.org
 L:	tlan-devel@lists.sourceforge.net (subscribers-only)
 W:	http://sourceforge.net/projects/tlan/
 S:	Maintained
 F:	Documentation/networking/tlan.txt
 F:	drivers/net/tlan.*
 
 TOSHIBA ACPI EXTRAS DRIVER
 P:	John Belmonte
 M:	toshiba_acpi@memebeam.org
 W:	http://memebeam.org/toys/ToshibaAcpiDriver
 S:	Maintained
 F:	drivers/acpi/toshiba_acpi.c
@@ -5110,109 +5110,109 @@ F:	arch/um/os-Linux/drivers/
 TURBOCHANNEL SUBSYSTEM
 P:	Maciej W. Rozycki
 M:	macro@linux-mips.org
 S:	Maintained
 F:	drivers/tc/
 F:	include/linux/tc.h
 
 U14-34F SCSI DRIVER
 P:	Dario Ballabio
 M:	ballabio_dario@emc.com
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/u14-34f.c
 
 UBI FILE SYSTEM (UBIFS)
 P:	Artem Bityutskiy
 M:	dedekind@infradead.org
 P:	Adrian Hunter
 M:	ext-adrian.hunter@nokia.com
 L:	linux-mtd@lists.infradead.org
-T:	git git://git.infradead.org/~dedekind/ubifs-2.6.git
+T:	git git.infradead.org/~dedekind/ubifs-2.6.git
 W:	http://www.linux-mtd.infradead.org/doc/ubifs.html
 S:	Maintained
 F:	Documentation/filesystems/ubifs.txt
 F:	fs/ubifs/
 
 UCLINUX (AND M68KNOMMU)
 P:	Greg Ungerer
 M:	gerg@uclinux.org
 W:	http://www.uclinux.org/
 L:	uclinux-dev@uclinux.org  (subscribers-only)
 S:	Maintained
 F:	arch/m68knommu/
 
 UCLINUX FOR RENESAS H8/300
 P:	Yoshinori Sato
 M:	ysato@users.sourceforge.jp
 W:	http://uclinux-h8.sourceforge.jp/
 S:	Supported
 
 UDF FILESYSTEM
 P:	Jan Kara
 M:	jack@suse.cz
 W:	http://linux-udf.sourceforge.net
 S:	Maintained
 F:	Documentation/filesystems/udf.txt
 F:	fs/udf/
 
 UFS FILESYSTEM
 P:	Evgeniy Dushistov
 M:	dushistov@mail.ru
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/ufs.txt
 F:	fs/ufs/
 
 UltraSPARC (sparc64)
 P:	David S. Miller
 M:	davem@davemloft.net
 L:	sparclinux@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-2.6.git
 S:	Maintained
 F:	arch/sparc64/
 
 ULTRA-WIDEBAND (UWB) SUBSYSTEM:
 P:	David Vrabel
 M:	david.vrabel@csr.com
 L:	linux-usb@vger.kernel.org
 S:	Supported
 F:	drivers/uwb/*
 F:	include/linux/uwb.h
 F:	include/linux/uwb/
 
 UNIFORM CDROM DRIVER
 P:	Jens Axboe
 M:	axboe@kernel.dk
 L:	linux-kernel@vger.kernel.org
 W:	http://www.kernel.dk
 S:	Maintained
 F:	Documentation/cdrom/
 F:	drivers/cdrom/cdrom.c
 F:	include/linux/cdrom.h
 
 UNSORTED BLOCK IMAGES (UBI)
 P:	Artem Bityutskiy
 M:	dedekind@infradead.org
 W:	http://www.linux-mtd.infradead.org/
 L:	linux-mtd@lists.infradead.org
-T:	git git://git.infradead.org/~dedekind/ubi-2.6.git
+T:	git git.infradead.org/~dedekind/ubi-2.6.git
 S:	Maintained
 F:	drivers/mtd/ubi
 F:	include/linux/mtd/ubi.h
 F:	include/mtd/ubi-*
 
 USB ACM DRIVER
 P:	Oliver Neukum
 M:	oliver@neukum.name
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	Documentation/usb/acm.txt
 F:	drivers/usb/class/cdc-acm.*
 
 USB BLOCK DRIVER (UB ub)
 P:	Pete Zaitcev
 M:	zaitcev@redhat.com
 L:	linux-kernel@vger.kernel.org
 L:	linux-usb@vger.kernel.org
 S:	Supported
 F:	drivers/block/ub.c
@@ -5262,41 +5262,41 @@ P:	Luca Risolia
 M:	luca.risolia@studio.unibo.it
 L:	linux-usb@vger.kernel.org
 L:	video4linux-list@redhat.com
 W:	http://www.linux-projects.org
 S:	Maintained
 F:	drivers/media/video/et61x251/
 
 USB GADGET/PERIPHERAL SUBSYSTEM
 P:	David Brownell
 M:	dbrownell@users.sourceforge.net
 L:	linux-usb@vger.kernel.org
 W:	http://www.linux-usb.org/gadget
 S:	Maintained
 F:	drivers/usb/gadget/
 F:	include/linux/usb/gadget*
 
 USB HID/HIDBP DRIVERS (USB KEYBOARDS, MICE, REMOTE CONTROLS, ...)
 P:	Jiri Kosina
 M:	jkosina@suse.cz
 L:	linux-usb@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
 F:	Documentation/usb/hiddev.txt
 F:	drivers/hid/usbhid/
 
 USB ISP116X DRIVER
 P:	Olav Kongas
 M:	ok@artecdesign.ee
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	drivers/usb/host/isp116x*
 F:	include/linux/usb/isp116x.h
 
 USB KAWASAKI LSI DRIVER
 P:	Oliver Neukum
 M:	oliver@neukum.name
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	drivers/usb/serial/kl5kusb105.*
 
 USB MASS STORAGE DRIVER
@@ -5536,41 +5536,41 @@ F:	Documentation/uml/
 F:	arch/um/
 F:	fs/hostfs/
 F:	fs/hppfs/
 
 USERSPACE I/O (UIO)
 P:	Hans J. Koch
 M:	hjk@linutronix.de
 P:	Greg Kroah-Hartman
 M:	gregkh@suse.de
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/DocBook/uio-howto.tmpl
 F:	drivers/uio/
 F:	include/linux/uio*.h
 
 UTIL-LINUX-NG PACKAGE
 P:	Karel Zak
 M:	kzak@redhat.com
 L:	util-linux-ng@vger.kernel.org
 W:	http://kernel.org/~kzak/util-linux-ng/
-T:	git://git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git
+T:	git git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git
 S:	Maintained
 
 UVESAFB DRIVER
 P:	Michal Januszewski
 M:	spock@gentoo.org
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://dev.gentoo.org/~spock/projects/uvesafb/
 S:	Maintained
 F:	Documentation/fb/uvesafb.txt
 F:	drivers/video/uvesafb.*
 
 VFAT/FAT/MSDOS FILESYSTEM
 P:	OGAWA Hirofumi
 M:	hirofumi@mail.parknet.co.jp
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/vfat.txt
 F:	fs/fat/
 F:	fs/msdos/
 F:	fs/vfat/
@@ -5593,67 +5593,67 @@ VIA UNICHROME(PRO)/CHROME9 FRAMEBUFFER DRIVER
 P:	Joseph Chan
 M:	JosephChan@via.com.tw
 P:	Scott Fang
 M:	ScottFang@viatech.com.cn
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
 VIA VELOCITY NETWORK DRIVER
 P:	Francois Romieu
 M:	romieu@fr.zoreil.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/via-velocity.*
 
 VIDEO FOR LINUX (V4L)
 P:	Mauro Carvalho Chehab
 M:	mchehab@infradead.org
 M:	v4l-dvb-maintainer@linuxtv.org
 L:	video4linux-list@redhat.com
 W:	http://linuxtv.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
 F:	Documentation/video4linux/
 F:	drivers/media/video/
 F:	drivers/media/radio/
 F:	include/linux/video_decoder.h
 F:	include/linux/videodev.h
 F:	include/linux/videodev2.h
 F:	include/media/
 
 VLAN (802.1Q)
 P:	Patrick McHardy
 M:	kaber@trash.net
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/macvlan.c
 F:	include/linux/if_*vlan.h
 F:	net/8021q/
 
 VOLTAGE AND CURRENT REGULATOR FRAMEWORK
 P:	Liam Girdwood
 M:	lrg@slimlogic.co.uk
 P:	Mark Brown
 M:	broonie@opensource.wolfsonmicro.com
 W:	http://opensource.wolfsonmicro.com/node/15
 W:	http://www.slimlogic.co.uk/?page_id=5
-T:	git kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git
 S:	Supported
 F:	drivers/regulator/
 F:	include/linux/regulator/
 
 VT1211 HARDWARE MONITOR DRIVER
 P:	Juerg Haefliger
 M:	juergh@gmail.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/vt1211
 F:	drivers/hwmon/vt1211.c
 
 VT8231 HARDWARE MONITOR DRIVER
 P:	Roger Lucas
 M:	vt8231@hiddenengine.co.uk
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	drivers/hwmon/vt8231.c
 
 W1 DALLAS'S 1-WIRE BUS
@@ -5672,41 +5672,41 @@ F:	Documentation/hwmon/w83791d
 F:	drivers/hwmon/w83791d.c
 
 W83793 HARDWARE MONITORING DRIVER
 P:	Rudolf Marek
 M:	r.marek@assembler.cz
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/w83793
 F:	drivers/hwmon/w83793.c
 
 W83L51xD SD/MMC CARD INTERFACE DRIVER
 P:	Pierre Ossman
 M:	drzeus-wbsd@drzeus.cx
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/host/wbsd.*
 
 WATCHDOG DEVICE DRIVERS
 P:	Wim Van Sebroeck
 M:	wim@iguana.be
-T:	git kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
 S:	Maintained
 F:	Documentation/watchdog/
 F:	drivers/watchdog/
 F:	include/linux/watchdog.h
 
 WAVELAN NETWORK DRIVER & WIRELESS EXTENSIONS
 P:	Jean Tourrilhes
 M:	jt@hpl.hp.com
 L:	linux-wireless@vger.kernel.org
 W:	http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/
 S:	Maintained
 F:	Documentation/networking/wavelan.txt
 F:	drivers/net/wireless/wavelan*
 
 WD7000 SCSI DRIVER
 P:	Miroslav Zagorac
 M:	zaga@fly.cc.fer.hr
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/wd7000.c
@@ -5721,87 +5721,87 @@ F:	drivers/uwb/wlp/
 WISTRON LAPTOP BUTTON DRIVER
 P:	Miloslav Trmac
 M:	mitr@volny.cz
 S:	Maintained
 F:	drivers/input/misc/wistron_btns.c
 
 WL3501 WIRELESS PCMCIA CARD DRIVER
 P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net
 L:	linux-wireless@vger.kernel.org
 W:	http://oops.ghostprotocols.net:81/blog
 S:	Maintained
 F:	drivers/net/wireless/wl3501*
 
 WM97XX TOUCHSCREEN DRIVERS
 P:	Mark Brown
 M:	broonie@opensource.wolfsonmicro.com
 P:	Liam Girdwood
 M:	lrg@slimlogic.co.uk
 L:	linux-input@vger.kernel.org
-T:	git git://opensource.wolfsonmicro.com/linux-2.6-touch
+T:	git opensource.wolfsonmicro.com/linux-2.6-touch
 W:	http://opensource.wolfsonmicro.com/node/7
 S:	Supported
 
 X.25 NETWORK LAYER
 P:	Henner Eisen
 M:	eis@baty.hanse.de
 L:	linux-x25@vger.kernel.org
 S:	Maintained
 F:	Documentation/networking/x25*
 F:	include/net/x25*
 F:	net/x25/
 
 X86 ARCHITECTURE (32-BIT AND 64-BIT)
 P:	Thomas Gleixner
 M:	tglx@linutronix.de
 P:	Ingo Molnar
 M:	mingo@redhat.com
 P:	H. Peter Anvin
 M:	hpa@zytor.com
 L:	linux-kernel@vger.kernel.org
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
 S:	Maintained
 F:	Documentation/x86/
 F:	arch/x86/
 
 XEN HYPERVISOR INTERFACE
 P:	Jeremy Fitzhardinge
 M:	jeremy@xensource.com
 P:	Chris Wright
 M:	chrisw@sous-sol.org
 L:	virtualization@lists.osdl.org
 L:	xen-devel@lists.xensource.com
 S:	Supported
 F:	arch/x86/xen/
 F:	drivers/*/xen-*front.c
 F:	drivers/xen/
 F:	arch/x86/include/asm/xen/
 F:	include/xen/
 
 XFS FILESYSTEM
 P:	Silicon Graphics Inc
 P:	Tim Shimmin
 M:	xfs-masters@oss.sgi.com
 L:	xfs@oss.sgi.com
 W:	http://oss.sgi.com/projects/xfs
-T:	git git://oss.sgi.com:8090/xfs/xfs-2.6.git
+T:	git oss.sgi.com:8090/xfs/xfs-2.6.git
 S:	Supported
 F:	Documentation/filesystems/xfs.txt
 F:	fs/xfs/
 
 XILINX SYSTEMACE DRIVER
 P:	Grant Likely
 M:	grant.likely@secretlab.ca
 W:	http://www.secretlab.ca/
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/block/xsysace.c
 
 XILINX UARTLITE SERIAL DRIVER
 P:	Peter Korsgaard
 M:	jacmet@sunsite.dk
 L:	linux-serial@vger.kernel.org
 S:	Maintained
 F:	drivers/serial/uartlite.c
 
 YAM DRIVER FOR AX.25
-- 
1.6.0.2

