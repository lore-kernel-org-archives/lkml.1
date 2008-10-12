Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbYJLXNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbYJLXNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 19:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbYJLXNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 19:13:00 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:43498 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbYJLXM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 19:12:58 -0400
Date: Sun, 12 Oct 2008 16:11:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] MAINTAINERS: remove colon from headings
Message-Id: <20081012161158.36f89e45.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.2.00.0810121245260.3402@nehalem.linux-foundation.org>
References: <20081010235755.12643.43818.stgit@warthog.procyon.org.uk>
	<alpine.LFD.2.00.0810121245260.3402@nehalem.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Remove ending ':' from some of the Topic lines for consistency.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 MAINTAINERS |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- lin2627-g2-maint.orig/MAINTAINERS
+++ lin2627-g2-maint/MAINTAINERS
@@ -1386,7 +1386,7 @@ W:	http://www.win.tue.nl/~aeb/linux/zip/
 W:	http://www.win.tue.nl/~aeb/partitions/partition_types-1.html
 S:	Maintained
 
-DISKQUOTA:
+DISKQUOTA
 P:	Jan Kara
 M:	jack@suse.cz
 L:	linux-kernel@vger.kernel.org
@@ -1596,7 +1596,7 @@ EFS FILESYSTEM
 W:	http://aeschi.ch.eu.org/efs/
 S:	Orphan
 
-EHCA (IBM GX bus InfiniBand adapter) DRIVER:
+EHCA (IBM GX bus InfiniBand adapter) DRIVER
 P:	Hoang-Nam Nguyen
 M:	hnguyen@de.ibm.com
 P:	Christoph Raisch
@@ -1907,7 +1907,7 @@ L:	linux-nvidia@lists.surfsouth.com
 W:	http://drama.obuda.kando.hu/~fero/cgi-bin/hgafb.shtml
 S:	Maintained
 
-HIBERNATION (aka Software Suspend, aka swsusp):
+HIBERNATION (aka Software Suspend, aka swsusp)
 P:	Pavel Machek
 M:	pavel@suse.cz
 P:	Rafael J. Wysocki
@@ -2247,7 +2247,7 @@ M:	pfg@sgi.com
 L:	linux-mips@linux-mips.org
 S:	Maintained
 
-IP MASQUERADING:
+IP MASQUERADING
 P:	Juanjo Ciarlante
 M:	jjciarla@raiz.uncu.edu.ar
 S:	Maintained
@@ -2262,7 +2262,7 @@ M:	jesse@icplus.com.tw
 L:	netdev@vger.kernel.org
 S:	Maintained
 
-IPATH DRIVER:
+IPATH DRIVER
 P:	Ralph Campbell
 M:	infinipath@qlogic.com
 L:	general@lists.openfabrics.org
@@ -3682,7 +3682,7 @@ P:	Jiri Slaby
 M:	jirislaby@gmail.com
 S:	Maintained
 
-SERIAL ATA (SATA) SUBSYSTEM:
+SERIAL ATA (SATA) SUBSYSTEM
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
 L:	linux-ide@vger.kernel.org
@@ -3880,7 +3880,7 @@ L:	alsa-devel@alsa-project.org (subscrib
 W:	http://alsa-project.org/main/index.php/ASoC
 S:	Supported
 
-SPARC (sparc32):
+SPARC (sparc32)
 P:	William L. Irwin
 M:	wli@holomorphy.com
 L:	sparclinux@vger.kernel.org
@@ -3957,7 +3957,7 @@ W:	http://www.linux-sh.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git
 S:	Supported
 
-SUSPEND TO RAM:
+SUSPEND TO RAM
 P:	Len Brown
 M:	len.brown@intel.com
 P:	Pavel Machek
@@ -4011,7 +4011,7 @@ P:	Mark Gross
 M:	mark.gross@intel.com
 S:	Supported
 
-TENSILICA XTENSA PORT (xtensa):
+TENSILICA XTENSA PORT (xtensa)
 P:	Chris Zankel
 M:	chris@zankel.net
 S:	Maintained
@@ -4160,7 +4160,7 @@ M:	dushistov@mail.ru
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
-UltraSPARC (sparc64):
+UltraSPARC (sparc64)
 P:	David S. Miller
 M:	davem@davemloft.net
 L:	sparclinux@vger.kernel.org
@@ -4475,7 +4475,7 @@ W:	http://kernel.org/~kzak/util-linux-ng
 T:	git://git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git
 S:	Maintained
 
-VFAT/FAT/MSDOS FILESYSTEM:
+VFAT/FAT/MSDOS FILESYSTEM
 P:	OGAWA Hirofumi
 M:	hirofumi@mail.parknet.co.jp
 L:	linux-kernel@vger.kernel.org
