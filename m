Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbYKKOsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbYKKOsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 09:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbYKKOsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 09:48:41 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47278 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755902AbYKKOsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 09:48:40 -0500
Date: Tue, 11 Nov 2008 14:48:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tty: trivial - fix up email addresses in tty related stuff
Message-ID: <20081111144844.2a22c505@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 7d30ee1..04e4549 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -7,12 +7,14 @@
  *	Original driver code supplied by Multi-Tech
  *
  *	Changes
- *	1/9/98	alan@redhat.com		Merge to 2.0.x kernel tree
+ *	1/9/98	alan@lxorguk.ukuu.org.uk
+ *					Merge to 2.0.x kernel tree
  *					Obtain and use official major/minors
  *					Loader switched to a misc device
  *					(fixed range check bug as a side effect)
  *					Printk clean up
- *	9/12/98	alan@redhat.com		Rough port to 2.1.x
+ *	9/12/98	alan@lxorguk.ukuu.org.uk
+ *					Rough port to 2.1.x
  *
  *	10/6/99 sameer			Merged the ISA and PCI drivers to
  *					a new unified driver.
diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 8beef50..0477669 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -14,7 +14,8 @@
  *      (at your option) any later version.
  *
  *	Fed through a cleanup, indent and remove of non 2.6 code by Alan Cox
- *	<alan@redhat.com>. The original 1.8 code is available on www.moxa.com.
+ *	<alan@lxorguk.ukuu.org.uk>. The original 1.8 code is available on
+ *	www.moxa.com.
  *	- Fixed x86_64 cleanness
  */
 
diff --git a/drivers/usb/serial/ir-usb.c b/drivers/usb/serial/ir-usb.c
index b679a55..4e2cda9 100644
--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -26,7 +26,7 @@
  *	Introduced common header to be used also in USB Gadget Framework.
  *	Still needs some other style fixes.
  *
- * 2007_Jun_21  Alan Cox <alan@redhat.com>
+ * 2007_Jun_21  Alan Cox <alan@lxorguk.ukuu.org.uk>
  *	Minimal cleanups for some of the driver problens and tty layer abuse.
  *	Still needs fixing to allow multiple dongles.
  *
