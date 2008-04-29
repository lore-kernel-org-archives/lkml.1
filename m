Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbYD2Nra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbYD2Nra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbYD2NrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:47:22 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59173 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752261AbYD2NrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:47:21 -0400
Date: Tue, 29 Apr 2008 14:39:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Sort ordering
Message-ID: <20080429143950.4f75b517@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems we have various confused entries around S and T. Sort them all out
and also add myself as tty maintainer (which is how I noticed it)

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/MAINTAINERS linux-2.6.25-mm1/MAINTAINERS
--- linux.vanilla-2.6.25-mm1/MAINTAINERS	2008-04-28 11:36:47.000000000 +0100
+++ linux-2.6.25-mm1/MAINTAINERS	2008-04-28 14:14:24.000000000 +0100
@@ -3703,42 +3703,6 @@
 L:	stable@kernel.org
 S:	Maintained
 
-TPM DEVICE DRIVER
-P:	Kylene Hall
-M:	tpmdd-devel@lists.sourceforge.net
-W:	http://tpmdd.sourceforge.net
-P:	Marcel Selhorst
-M:	tpm@selhorst.net
-W:	http://www.prosec.rub.de/tpm/
-L:	tpmdd-devel@lists.sourceforge.net
-S:	Maintained
-
-Telecom Clock Driver for MCPL0010
-P:	Mark Gross
-M:	mark.gross@intel.com
-S:	Supported
-
-TENSILICA XTENSA PORT (xtensa):
-P:	Chris Zankel
-M:	chris@zankel.net
-S:	Maintained
-
-THINKPAD ACPI EXTRAS DRIVER
-P:	Henrique de Moraes Holschuh
-M:	ibm-acpi@hmh.eng.br
-L:	ibm-acpi-devel@lists.sourceforge.net
-W:	http://ibm-acpi.sourceforge.net
-W:	http://thinkwiki.org/wiki/Ibm-acpi
-T:	git repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git
-S:	Maintained
-
-UltraSPARC (sparc64):
-P:	David S. Miller
-M:	davem@davemloft.net
-L:	sparclinux@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git
-S:	Maintained
-
 SHARP LH SUPPORT (LH7952X & LH7A40X)
 P:	Marc Singer
 M:	elf@buici.com
@@ -3835,6 +3799,12 @@
 M:	hch@infradead.org
 S:	Maintained
 
+TASKSTATS STATISTICS INTERFACE
+P:	Shailabh Nagar
+M:	nagar@watson.ibm.com
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 TC CLASSIFIER
 P:	Jamal Hadi Salim
 M:	hadi@cyberus.ca
@@ -3857,6 +3827,25 @@
 L:	netdev@vger.kernel.org
 S:	Supported
 
+Telecom Clock Driver for MCPL0010
+P:	Mark Gross
+M:	mark.gross@intel.com
+S:	Supported
+
+TENSILICA XTENSA PORT (xtensa):
+P:	Chris Zankel
+M:	chris@zankel.net
+S:	Maintained
+
+THINKPAD ACPI EXTRAS DRIVER
+P:	Henrique de Moraes Holschuh
+M:	ibm-acpi@hmh.eng.br
+L:	ibm-acpi-devel@lists.sourceforge.net
+W:	http://ibm-acpi.sourceforge.net
+W:	http://thinkwiki.org/wiki/Ibm-acpi
+T:	git repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git
+S:	Maintained
+
 TI FLASH MEDIA INTERFACE DRIVER
 P:      Alex Dubov
 M:      oakad@yahoo.com
@@ -3874,12 +3863,6 @@
 M:	dsaxena@plexity.net
 S:	Maintained
 
-TASKSTATS STATISTICS INTERFACE
-P:	Shailabh Nagar
-M:	nagar@watson.ibm.com
-L:	linux-kernel@vger.kernel.org
-S:	Maintained
-
 TIPC NETWORK LAYER
 P:	Per Liden
 M:	per.liden@ericsson.com
@@ -3913,6 +3896,16 @@
 W:	http://www.buzzard.org.uk/toshiba/
 S:	Maintained
 
+TPM DEVICE DRIVER
+P:	Kylene Hall
+M:	tpmdd-devel@lists.sourceforge.net
+W:	http://tpmdd.sourceforge.net
+P:	Marcel Selhorst
+M:	tpm@selhorst.net
+W:	http://www.prosec.rub.de/tpm/
+L:	tpmdd-devel@lists.sourceforge.net
+S:	Maintained
+
 TRIDENT 4DWAVE/SIS 7018 PCI AUDIO CORE
 P:	Muli Ben-Yehuda
 M:	mulix@mulix.org
@@ -3925,6 +3918,12 @@
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
+TTY LAYER
+P:	Alan Cox
+M:	alan@lxorguk.ukuu.org.uk
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 TULIP NETWORK DRIVERS
 P:	Grant Grundler
 M:	grundler@parisc-linux.org
@@ -4102,6 +4101,20 @@
 W:	http://www.chello.nl/~j.vreeken/se401/
 S:	Maintained
 
+USB SERIAL BELKIN F5U103 DRIVER
+P:	William Greathouse
+M:	wgreathouse@smva.com
+L:      linux-usb@vger.kernel.org
+S:	Maintained
+
+USB SERIAL CYPRESS M8 DRIVER
+P:	Lonnie Mendez
+M:	dignome@gmail.com
+L:      linux-usb@vger.kernel.org
+S:	Maintained
+W:	http://geocities.com/i0xox0i
+W:	http://firstlight.net/cvs
+
 USB SERIAL CYBERJACK DRIVER
 P:	Matthias Bruestle and Harald Welte
 M:	support@reiner-sct.com
@@ -4121,20 +4134,6 @@
 L:      linux-usb@vger.kernel.org
 S:	Supported
 
-USB SERIAL BELKIN F5U103 DRIVER
-P:	William Greathouse
-M:	wgreathouse@smva.com
-L:      linux-usb@vger.kernel.org
-S:	Maintained
-
-USB SERIAL CYPRESS M8 DRIVER
-P:	Lonnie Mendez
-M:	dignome@gmail.com
-L:      linux-usb@vger.kernel.org
-S:	Maintained
-W:	http://geocities.com/i0xox0i
-W:	http://firstlight.net/cvs
-
 USB SERIAL EMPEG EMPEG-CAR MARK I/II DRIVER
 P:	Gary Brubaker
 M:	xavyer@ix.netcom.com
@@ -4237,7 +4236,7 @@
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
-FAT/VFAT/MSDOS FILESYSTEM:
+VFAT/FAT/MSDOS FILESYSTEM:
 P:	OGAWA Hirofumi
 M:	hirofumi@mail.parknet.co.jp
 L:	linux-kernel@vger.kernel.org
@@ -4282,6 +4281,13 @@
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
+UltraSPARC (sparc64):
+P:	David S. Miller
+M:	davem@davemloft.net
+L:	sparclinux@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git
+S:	Maintained
+
 USB DIAMOND RIO500 DRIVER
 P:	Cesar Miquel
 M:	miquel@df.uba.ar
