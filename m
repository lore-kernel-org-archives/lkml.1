Return-Path: <linux-kernel-owner+w=401wt.eu-S1765741AbYESNlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765741AbYESNlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762714AbYESNdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:33:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50471 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762665AbYESNdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:33:40 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] MAINTAINERS needs further order fixing
To: linux-kernel@vger.kernel.org, torvalds@osdl.org
Date: Mon, 19 May 2008 14:21:51 +0100
Message-ID: <20080519132144.692.4829.stgit@core>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>


---

 MAINTAINERS |   72 ++++++++++++++++++++++++++++++-----------------------------
 1 files changed, 36 insertions(+), 36 deletions(-)


diff --git a/MAINTAINERS b/MAINTAINERS
index f5583dc..deda30e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4010,12 +4010,41 @@ M:	ballabio_dario@emc.com
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 
+UCLINUX (AND M68KNOMMU)
+P:	Greg Ungerer
+M:	gerg@uclinux.org
+W:	http://www.uclinux.org/
+L:	uclinux-dev@uclinux.org  (subscribers-only)
+S:	Maintained
+
+UCLINUX FOR NEC V850
+P:	Miles Bader
+
+UCLINUX FOR RENESAS H8/300
+P:	Yoshinori Sato
+M:	ysato@users.sourceforge.jp
+W:	http://uclinux-h8.sourceforge.jp/
+S:	Supported
+
 UDF FILESYSTEM
 P:	Jan Kara
 M:	jack@suse.cz
 W:	http://linux-udf.sourceforge.net
 S:	Maintained
 
+UFS FILESYSTEM
+P:	Evgeniy Dushistov
+M:	dushistov@mail.ru
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
+UltraSPARC (sparc64):
+P:	David S. Miller
+M:	davem@davemloft.net
+L:	sparclinux@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git
+S:	Maintained
+
 UNIFORM CDROM DRIVER
 P:	Jens Axboe
 M:	axboe@kernel.dk
@@ -4062,6 +4091,13 @@ L:	netdev@vger.kernel.org
 W:	http://www.linux-usb.org/usbnet
 S:	Maintained
 
+USB DIAMOND RIO500 DRIVER
+P:	Cesar Miquel
+M:	miquel@df.uba.ar
+L:	rio500-users@lists.sourceforge.net
+W:	http://rio500.sourceforge.net
+S:	Maintained
+
 USB EHCI DRIVER
 P:	David Brownell
 M:	dbrownell@users.sourceforge.net
@@ -4316,42 +4352,6 @@ M:	romieu@fr.zoreil.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 
-UCLINUX (AND M68KNOMMU)
-P:	Greg Ungerer
-M:	gerg@uclinux.org
-W:	http://www.uclinux.org/
-L:	uclinux-dev@uclinux.org  (subscribers-only)
-S:	Maintained
-
-UCLINUX FOR NEC V850
-P:	Miles Bader
-
-UCLINUX FOR RENESAS H8/300
-P:	Yoshinori Sato
-M:	ysato@users.sourceforge.jp
-W:	http://uclinux-h8.sourceforge.jp/
-S:	Supported
-
-UFS FILESYSTEM
-P:	Evgeniy Dushistov
-M:	dushistov@mail.ru
-L:	linux-kernel@vger.kernel.org
-S:	Maintained
-
-UltraSPARC (sparc64):
-P:	David S. Miller
-M:	davem@davemloft.net
-L:	sparclinux@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git
-S:	Maintained
-
-USB DIAMOND RIO500 DRIVER
-P:	Cesar Miquel
-M:	miquel@df.uba.ar
-L:	rio500-users@lists.sourceforge.net
-W:	http://rio500.sourceforge.net
-S:	Maintained
-
 VIDEO FOR LINUX
 P:	Mauro Carvalho Chehab
 M:	mchehab@infradead.org

