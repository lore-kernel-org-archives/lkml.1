Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbYJ0PPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbYJ0PPC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:15:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYJ0POx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:14:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52876 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751299AbYJ0POw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:14:52 -0400
Date: Mon, 27 Oct 2008 15:14:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i2o: Switch all my stuff to a single common address
Message-ID: <20081027151457.0e8fdf4e@lxorguk.ukuu.org.uk>
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

diff --git a/drivers/message/i2o/exec-osm.c b/drivers/message/i2o/exec-osm.c
index 56faef1..06c655c 100644
--- a/drivers/message/i2o/exec-osm.c
+++ b/drivers/message/i2o/exec-osm.c
@@ -19,7 +19,7 @@
  *		Auvo Häkkinen <Auvo.Hakkinen@cs.Helsinki.FI>
  *		Deepak Saxena <deepak@plexity.net>
  *		Boji T Kannanthanam <boji.t.kannanthanam@intel.com>
- *		Alan Cox <alan@redhat.com>:
+ *		Alan Cox <alan@lxorguk.ukuu.org.uk>:
  *			Ported to Linux 2.5.
  *		Markus Lidel <Markus.Lidel@shadowconnect.com>:
  *			Minor fixes for 2.6.
diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index a3fabdb..3f08f01 100644
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
index be2b592..9ac7cd3 100644
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
