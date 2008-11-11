Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbYKKOuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbYKKOuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 09:50:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbYKKOuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 09:50:04 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47281 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755479AbYKKOuD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 09:50:03 -0500
Date: Tue, 11 Nov 2008 14:50:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i2o: trivial, fix up email addresses in i2o
Message-ID: <20081111145008.6cb93e14@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index f3384c3..efba702 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -19,7 +19,7 @@
  *		Changed ioctl_swdl(), implemented ioctl_swul() and ioctl_swdel()
  *	Deepak Saxena (11/18/1999):
  *		Added event managmenet support
- *	Alan Cox <alan@redhat.com>:
+ *	Alan Cox <alan@lxorguk.ukuu.org.uk>:
  *		2.4 rewrite ported to 2.5
  *	Markus Lidel <Markus.Lidel@shadowconnect.com>:
  *		Added pass-thru support for Adaptec's raidutils
diff --git a/drivers/message/i2o/iop.c b/drivers/message/i2o/iop.c
index 6e53a30..35c67d1 100644
--- a/drivers/message/i2o/iop.c
+++ b/drivers/message/i2o/iop.c
@@ -19,7 +19,7 @@
  *		Auvo Häkkinen <Auvo.Hakkinen@cs.Helsinki.FI>
  *		Deepak Saxena <deepak@plexity.net>
  *		Boji T Kannanthanam <boji.t.kannanthanam@intel.com>
- *		Alan Cox <alan@redhat.com>:
+ *		Alan Cox <alan@lxorguk.ukuu.org.uk>:
  *			Ported to Linux 2.5.
  *		Markus Lidel <Markus.Lidel@shadowconnect.com>:
  *			Minor fixes for 2.6.
diff --git a/drivers/message/i2o/pci.c b/drivers/message/i2o/pci.c
index 610ef12..25d6f23 100644
--- a/drivers/message/i2o/pci.c
+++ b/drivers/message/i2o/pci.c
@@ -19,7 +19,7 @@
  *		Auvo Häkkinen <Auvo.Hakkinen@cs.Helsinki.FI>
  *		Deepak Saxena <deepak@plexity.net>
  *		Boji T Kannanthanam <boji.t.kannanthanam@intel.com>
- *		Alan Cox <alan@redhat.com>:
+ *		Alan Cox <alan@lxorguk.ukuu.org.uk>:
  *			Ported to Linux 2.5.
  *		Markus Lidel <Markus.Lidel@shadowconnect.com>:
  *			Minor fixes for 2.6.
