Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbYKRRQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbYKRRQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbYKRRNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:13:45 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4536 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbYKRRNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:13:42 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@strlen.de>,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH 06/10] MAINTAINERS - Standardize "T:	git urls"
Date: Tue, 18 Nov 2008 09:13:18 -0800
Message-Id: <1227028402-1548-7-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1227028402-1548-1-git-send-email-joe@perches.com>
References: <1227028402-1548-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |  142 +++++++++++++++++++++++++++++-----------------------------
 1 files changed, 71 insertions(+), 71 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e9a148b..46ad2df 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -178,7 +178,7 @@ P:	Latchesar Ionkov
 M:	lucho@ionkov.net
 L:	v9fs-developer@lists.sourceforge.net
 W:	http://swik.net/v9fs
-T:	git kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git
 S:	Maintained
 F:	fs/9p/
 
@@ -232,7 +232,7 @@ P:	Len Brown
 M:	lenb@kernel.org
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
-T:	git kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
 S:	Supported
 F:	drivers/acpi/
 F:	drivers/pnp/pnpacpi/
@@ -324,7 +324,7 @@ P:	Michael Wu
 M:	flamingice@sourmilk.net
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
 S:	Maintained
 F:	drivers/net/wireless/adm8211.*
 
@@ -366,7 +366,7 @@ F:	net/rxrpc/af_rxrpc.c
 AGPGART DRIVER
 P:	David Airlie
 M:	airlied@linux.ie
-T:	git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
 F:	drivers/char/agp/
 F:	include/linux/agp*
@@ -449,7 +449,7 @@ AMD IOMMU (AMD-VI)
 P:	Joerg Roedel
 M:	joerg.roedel@amd.com
 L:	iommu@lists.linux-foundation.org
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git
 S:	Supported
 
 AMD MICROCODE UPDATE SUPPORT
@@ -1093,7 +1093,7 @@ BLOCK LAYER
 P:	Jens Axboe
 M:	axboe@kernel.dk
 L:	linux-kernel@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
 S:	Maintained
 F:	block/
 
@@ -1117,7 +1117,7 @@ P:	Marcel Holtmann
 M:	marcel@holtmann.org
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/holtmann/bluetooth-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/holtmann/bluetooth-2.6.git
 S:	Maintained
 F:	net/bluetooth/
 F:	include/net/bluetooth/
@@ -1181,7 +1181,7 @@ M:	mchehab@infradead.org
 M:	v4l-dvb-maintainer@linuxtv.org
 L:	video4linux-list@redhat.com
 W:	http://linuxtv.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
 F:	Documentation/video4linux/bttv/
 F:	drivers/media/video/bt8xx/bttv*
@@ -1323,7 +1323,7 @@ M:	sfrench@samba.org
 L:	linux-cifs-client@lists.samba.org
 L:	samba-technical@lists.samba.org
 W:	http://linux-cifs.samba.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
 S:	Supported
 F:	fs/cifs/
 
@@ -1409,7 +1409,7 @@ P:	Dave Jones
 M:	davej@redhat.com
 L:	cpufreq@vger.kernel.org
 W:	http://www.codemonkey.org.uk/projects/cpufreq/
-T:	git kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git
 S:	Maintained
 F:	arch/x86/kernel/cpu/cpufreq/
 F:	drivers/cpufreq/
@@ -1455,7 +1455,7 @@ M:	herbert@gondor.apana.org.au
 P:	David S. Miller
 M:	davem@davemloft.net
 L:	linux-crypto@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
 S:	Maintained
 F:	crypto/
 
@@ -1669,7 +1669,7 @@ P:	David Teigland
 M:	teigland@redhat.com
 L:	cluster-devel@redhat.com
 W:	http://sources.redhat.com/cluster/
-T:	git kernel.org:/pub/scm/linux/kernel/git/teigland/dlm.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git
 S:	Supported
 F:	fs/dlm/
 
@@ -1744,7 +1744,7 @@ DRM DRIVERS
 P:	David Airlie
 M:	airlied@linux.ie
 L:	dri-devel@lists.sourceforge.net
-T:	git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
 F:	drivers/gpu/drm/
 
@@ -1760,7 +1760,7 @@ P:	LinuxTV.org Project
 M:	v4l-dvb-maintainer@linuxtv.org
 L:	linux-dvb@linuxtv.org (subscription required)
 W:	http://linuxtv.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
 F:	Documentation/dvb/
 F:	drivers/media/dvb/
@@ -2048,7 +2048,7 @@ P:	Stefan Richter
 M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
 F:	drivers/firewire/
 F:	include/linux/firewire*.h
@@ -2233,8 +2233,8 @@ P:	Steven Whitehouse
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
@@ -2378,7 +2378,7 @@ HID CORE LAYER
 P:	Jiri Kosina
 M:	jkosina@suse.cz
 L:	linux-input@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
 F:	drivers/hid/
 F:	include/linux/hid*
@@ -2522,7 +2522,7 @@ S:	Maintained
 i386 SETUP CODE / CPU ERRATA WORKAROUNDS
 P:	H. Peter Anvin
 M:	hpa@zytor.com
-T:	git.kernel.org:/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git
 S:	Maintained
 
 IA64 (Itanium) PLATFORM
@@ -2530,7 +2530,7 @@ P:	Tony Luck
 M:	tony.luck@intel.com
 L:	linux-ia64@vger.kernel.org
 W:	http://www.ia64-linux.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6.git
 S:	Maintained
 
 IBM MCA SCSI SUBSYSTEM DRIVER
@@ -2606,7 +2606,7 @@ P:	Stefan Richter
 M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
 F:	drivers/ieee1394/
 
@@ -2633,7 +2633,7 @@ P:	Hal Rosenstock
 M:	hal.rosenstock@gmail.com
 L:	general@lists.openfabrics.org
 W:	http://www.openib.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git
 S:	Supported
 F:	Documentation/infiniband/
 F:	drivers/infiniband/
@@ -2654,7 +2654,7 @@ P:	Dmitry Torokhov
 M:	dmitry.torokhov@gmail.com
 M:	dtor@mail.ru
 L:	linux-input@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/dtor/input.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
 S:	Maintained
 F:	drivers/input/
 
@@ -2699,7 +2699,7 @@ INTEL IOMMU (VT-d)
 P:	David Woodhouse
 M:	dwmw2@infradead.org
 L:	iommu@lists.linux-foundation.org
-T:	git://git.infradead.org/iommu-2.6.git
+T:	git git.infradead.org/iommu-2.6.git
 S:	Supported
 F:	drivers/pci/intel-iommu.c
 F:	include/linux/intel-iommu.h
@@ -2782,7 +2782,7 @@ M:	reinette.chatre@intel.com
 L:	linux-wireless@vger.kernel.org
 L:	ipw3945-devel@lists.sourceforge.net
 W:	http://intellinuxwireless.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
 S:	Supported
 F:	drivers/net/wireless/iwlwifi/
 
@@ -2821,7 +2821,7 @@ IPATH DRIVER
 P:	Ralph Campbell
 M:	infinipath@qlogic.com
 L:	general@lists.openfabrics.org
-T:	git git://git.qlogic.com/ipath-linux-2.6
+T:	git git.qlogic.com/ipath-linux-2.6
 S:	Supported
 F:	drivers/infiniband/hw/ipath/
 
@@ -2862,7 +2862,7 @@ M:	jkosina@suse.cz
 P:	David Sterba
 M:	dsterba@suse.cz
 S:	Maintained
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/jikos/ipwireless_cs.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/jikos/ipwireless_cs.git
 F:	drivers/char/pcmcia/ipwireless/
 
 IPX NETWORK LAYER
@@ -2898,7 +2898,7 @@ P:	Mike Christie
 M:	michaelc@cs.wisc.edu
 L:	open-iscsi@googlegroups.com
 W:	www.open-iscsi.org
-T:	git kernel.org:/pub/scm/linux/kernel/mnc/linux-2.6-iscsi.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/mnc/linux-2.6-iscsi.git
 S:	Maintained
 F:	drivers/scsi/*iscsi*
 F:	include/scsi/*iscsi*
@@ -2908,7 +2908,7 @@ P:	Karsten Keil
 M:	kkeil@suse.de
 L:	isdn4linux@listserv.isdn4linux.de (subscribers-only)
 W:	http://www.isdn4linux.de
-T:	git kernel.org:/pub/scm/linux/kernel/kkeil/isdn-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/kkeil/isdn-2.6.git
 S:	Maintained
 F:	Documentation/isdn/
 F:	drivers/isdn/
@@ -2940,7 +2940,7 @@ P:	Dave Kleikamp
 M:	shaggy@austin.ibm.com
 L:	jfs-discussion@lists.sourceforge.net
 W:	http://jfs.sourceforge.net/
-T:	git kernel.org:/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git
 S:	Supported
 F:	Documentation/filesystems/jfs.txt
 F:	fs/jfs/
@@ -3016,8 +3016,8 @@ F:	fs/autofs4/
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
@@ -3207,7 +3207,7 @@ P:	Benjamin Herrenschmidt
 M:	benh@kernel.crashing.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/paulus/powerpc.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git
 S:	Supported
 
 LINUX FOR POWER MACINTOSH
@@ -3232,7 +3232,7 @@ P:	Matt Porter
 M:	mporter@kernel.crashing.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jwboyer/powerpc.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/jwboyer/powerpc.git
 S:	Maintained
 
 LINUX FOR POWERPC EMBEDDED XILINX VIRTEX
@@ -3269,7 +3269,7 @@ LINUX SECURITY MODULE (LSM) FRAMEWORK
 P:	Chris Wright
 M:	chrisw@sous-sol.org
 L:	linux-security-module@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
 S:	Supported
 
 LLC (802.2)
@@ -3308,7 +3308,7 @@ M:	peterz@infradead.org
 P:	Ingo Molnar
 M:	mingo@redhat.com
 L:	linux-kernel@vger.kernel.org
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git
 S:	Maintained
 F:	Documentation/lockdep-design.txt
 F:	Documentation/lockstat.txt
@@ -3348,7 +3348,7 @@ P:	Mike Frysinger
 M:	vapier@gentoo.org
 L:	ltp-list@lists.sourceforge.net (subscribers-only)
 W:	http://ltp.sourceforge.net/
-T:	git kernel.org/pub/scm/linux/kernel/git/galak/ltp.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/galak/ltp.git
 S:	Maintained
 
 M32R ARCHITECTURE
@@ -3395,7 +3395,7 @@ P:	Michael Wu
 M:	flamingice@sourmilk.net
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
 F:	Documentation/networking/mac80211-injection.txt
 F:	include/net/mac80211.h
@@ -3408,7 +3408,7 @@ P:	Mattias Nissler
 M:	mattias.nissler@gmx.de
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/en/developers/Documentation/mac80211/RateControl/PID
-T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
 F:	net/mac80211/rc80211_pid*
 
@@ -3501,7 +3501,7 @@ P:	David Woodhouse
 M:	dwmw2@infradead.org
 W:	http://www.linux-mtd.infradead.org/
 L:	linux-mtd@lists.infradead.org
-T:	git git://git.infradead.org/mtd-2.6.git
+T:	git git.infradead.org/mtd-2.6.git
 S:	Maintained
 F:	drivers/mtd/
 F:	include/linux/mtd/
@@ -3518,7 +3518,7 @@ P:	Ralf Baechle
 M:	ralf@linux-mips.org
 W:	http://www.linux-mips.org/
 L:	linux-mips@linux-mips.org
-T:	git www.linux-mips.org:/pub/scm/linux.git
+T:	git www.linux-mips.org/pub/scm/linux.git
 S:	Supported
 F:	Documentation/mips/
 F:	arch/mips/
@@ -3739,7 +3739,7 @@ NETWORK DEVICE DRIVERS
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
 L:	netdev@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
 S:	Maintained
 F:	drivers/net/
 
@@ -3766,7 +3766,7 @@ M:	yoshfuji@linux-ipv6.org
 P:	Patrick McHardy
 M:	kaber@trash.net
 L:	netdev@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
 S:	Maintained
 F:	net/ipv4/
 F:	net/ipv6/
@@ -3782,7 +3782,7 @@ NETWORKING [WIRELESS]
 P:	John W. Linville
 M:	linville@tuxdriver.com
 L:	linux-wireless@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
 F:	net/ieee80211/
 F:	net/wireless/
@@ -3802,7 +3802,7 @@ P:	Trond Myklebust
 M:	Trond.Myklebust@netapp.com
 L:	linux-nfs@vger.kernel.org
 W:	http://client.linux-nfs.org
-T:	git git://git.linux-nfs.org/pub/linux/nfs-2.6.git
+T:	git git.linux-nfs.org/pub/linux/nfs-2.6.git
 S:	Maintained
 F:	fs/lockd/
 F:	fs/nfs/
@@ -3845,7 +3845,7 @@ M:	aia21@cantab.net
 L:	linux-ntfs-dev@lists.sourceforge.net
 L:	linux-kernel@vger.kernel.org
 W:	http://www.linux-ntfs.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/aia21/ntfs-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/aia21/ntfs-2.6.git
 S:	Maintained
 F:	Documentation/filesystems/ntfs.txt
 F:	fs/ntfs/
@@ -3927,7 +3927,7 @@ P:	Joel Becker
 M:	joel.becker@oracle.com
 L:	ocfs2-devel@oss.oracle.com (moderated for non-subscribers)
 W:	http://oss.oracle.com/projects/ocfs2/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git
 S:	Supported
 F:	Documentation/filesystems/ocfs2.txt
 F:	Documentation/filesystems/dlmfs.txt
@@ -3953,7 +3953,7 @@ P:	Michael Wu
 M:	flamingice@sourmilk.net
 L:	linux-wireless@vger.kernel.org
 W:	http://prism54.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
 S:	Maintained
 
 PA SEMI ETHERNET DRIVER
@@ -4026,7 +4026,7 @@ P:	Grant Grundler
 M:	grundler@parisc-linux.org
 L:	linux-parisc@vger.kernel.org
 W:	http://www.parisc-linux.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/kyle/parisc-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/kyle/parisc-2.6.git
 S:	Maintained
 F:	arch/parisc/
 F:	drivers/parisc/
@@ -4059,7 +4059,7 @@ P:	Jesse Barnes
 M:	jbarnes@virtuousgeek.org
 L:	linux-kernel@vger.kernel.org
 L:	linux-pci@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
 S:	Supported
 F:	Documentation/PCI/
 F:	drivers/pci/
@@ -4076,7 +4076,7 @@ PCMCIA SUBSYSTEM
 P:	Linux PCMCIA Team
 L:	linux-pcmcia@lists.infradead.org
 W:	http://lists.infradead.org/mailman/listinfo/linux-pcmcia
-T:	git kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
 S:	Maintained
 F:	Documentation/pcmcia/
 F:	drivers/pcmcia/
@@ -4310,7 +4310,7 @@ L:	linux-wireless@vger.kernel.org
 L:	rt2400-devel@lists.sourceforge.net
 W:	http://rt2x00.serialmonkey.com/
 S:	Maintained
-T:	git kernel.org:/pub/scm/linux/kernel/git/ivd/rt2x00.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git
 F:	drivers/net/wireless/rt2x00/
 
 RAMDISK RAM BLOCK DEVICE DRIVER
@@ -4434,7 +4434,7 @@ P:	Andrea Merello
 M:	andreamrl@tiscali.it
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
 S:	Maintained
 F:	drivers/net/wireless/rtl818*
 
@@ -4543,9 +4543,9 @@ SCSI SUBSYSTEM
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
@@ -4624,7 +4624,7 @@ M:	eparis@parisplace.org
 L:	linux-kernel@vger.kernel.org (kernel issues)
 L:	selinux@tycho.nsa.gov (subscribers-only, general discussion)
 W:	http://selinuxproject.org
-T:	git kernel.org:pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
 S:	Supported
 F:	include/linux/selinux*
 F:	security/selinux/
@@ -4640,7 +4640,7 @@ SERIAL ATA (SATA) SUBSYSTEM
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
 L:	linux-ide@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
 S:	Supported
 F:	drivers/ata/
 
@@ -4977,7 +4977,7 @@ P:	Paul Mundt
 M:	lethal@linux-sh.org
 L:	linux-sh@vger.kernel.org
 W:	http://www.linux-sh.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git
 S:	Supported
 F:	arch/sh/
 
@@ -5105,7 +5105,7 @@ M:	allan.stephens@windriver.com
 L:	tipc-discussion@lists.sourceforge.net
 W:	http://tipc.sourceforge.net/
 W:	http://tipc.cslab.ericsson.net/
-T:	git tipc.cslab.ericsson.net:/pub/git/tipc.git
+T:	git tipc.cslab.ericsson.net/pub/git/tipc.git
 S:	Maintained
 F:	include/linux/tipc*.h
 F:	include/net/tipc/
@@ -5199,7 +5199,7 @@ M:	dedekind@infradead.org
 P:	Adrian Hunter
 M:	ext-adrian.hunter@nokia.com
 L:	linux-mtd@lists.infradead.org
-T:	git git://git.infradead.org/~dedekind/ubifs-2.6.git
+T:	git git.infradead.org/~dedekind/ubifs-2.6.git
 W:	http://www.linux-mtd.infradead.org/doc/ubifs.html
 S:	Maintained
 F:	Documentation/filesystems/ubifs.txt
@@ -5239,7 +5239,7 @@ UltraSPARC (sparc64)
 P:	David S. Miller
 M:	davem@davemloft.net
 L:	sparclinux@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-2.6.git
 S:	Maintained
 F:	arch/sparc64/
 
@@ -5267,7 +5267,7 @@ P:	Artem Bityutskiy
 M:	dedekind@infradead.org
 W:	http://www.linux-mtd.infradead.org/
 L:	linux-mtd@lists.infradead.org
-T:	git git://git.infradead.org/~dedekind/ubi-2.6.git
+T:	git git.infradead.org/~dedekind/ubi-2.6.git
 S:	Maintained
 F:	drivers/mtd/ubi
 F:	include/linux/mtd/ubi.h
@@ -5351,7 +5351,7 @@ USB HID/HIDBP DRIVERS (USB KEYBOARDS, MICE, REMOTE CONTROLS, ...)
 P:	Jiri Kosina
 M:	jkosina@suse.cz
 L:	linux-usb@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
 F:	Documentation/usb/hiddev.txt
 F:	drivers/hid/usbhid/
@@ -5626,7 +5626,7 @@ P:	Karel Zak
 M:	kzak@redhat.com
 L:	util-linux-ng@vger.kernel.org
 W:	http://kernel.org/~kzak/util-linux-ng/
-T:	git://git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git
+T:	git git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git
 S:	Maintained
 
 UVESAFB DRIVER
@@ -5684,7 +5684,7 @@ M:	mchehab@infradead.org
 M:	v4l-dvb-maintainer@linuxtv.org
 L:	video4linux-list@redhat.com
 W:	http://linuxtv.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
 F:	Documentation/video4linux/
 F:	drivers/media/video/
@@ -5710,7 +5710,7 @@ P:	Mark Brown
 M:	broonie@opensource.wolfsonmicro.com
 W:	http://opensource.wolfsonmicro.com/node/15
 W:	http://www.slimlogic.co.uk/?page_id=5
-T:	git kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git
 S:	Supported
 F:	drivers/regulator/
 F:	include/linux/regulator/
@@ -5763,7 +5763,7 @@ F:	drivers/mmc/host/wbsd.*
 WATCHDOG DEVICE DRIVERS
 P:	Wim Van Sebroeck
 M:	wim@iguana.be
-T:	git kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
 S:	Maintained
 F:	Documentation/watchdog/
 F:	drivers/watchdog/
@@ -5812,7 +5812,7 @@ M:	broonie@opensource.wolfsonmicro.com
 P:	Liam Girdwood
 M:	lrg@slimlogic.co.uk
 L:	linux-input@vger.kernel.org
-T:	git git://opensource.wolfsonmicro.com/linux-2.6-touch
+T:	git opensource.wolfsonmicro.com/linux-2.6-touch
 W:	http://opensource.wolfsonmicro.com/node/7
 S:	Supported
 
@@ -5833,7 +5833,7 @@ M:	mingo@redhat.com
 P:	H. Peter Anvin
 M:	hpa@zytor.com
 L:	linux-kernel@vger.kernel.org
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
+T:	git git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
 S:	Maintained
 F:	Documentation/x86/
 F:	arch/x86/
@@ -5858,7 +5858,7 @@ P:	Tim Shimmin
 M:	xfs-masters@oss.sgi.com
 L:	xfs@oss.sgi.com
 W:	http://oss.sgi.com/projects/xfs
-T:	git git://oss.sgi.com:8090/xfs/xfs-2.6.git
+T:	git oss.sgi.com:8090/xfs/xfs-2.6.git
 S:	Supported
 F:	Documentation/filesystems/xfs.txt
 F:	fs/xfs/
-- 
1.6.0.2

