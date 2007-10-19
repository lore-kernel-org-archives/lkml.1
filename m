Return-Path: <linux-kernel-owner+w=401wt.eu-S936206AbXJSUzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936206AbXJSUzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 16:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763297AbXJSUzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 16:55:23 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:48353 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758739AbXJSUzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 16:55:22 -0400
Date: Fri, 19 Oct 2007 21:55:16 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Add self for the dz serial driver
Message-ID: <Pine.LNX.4.64N.0710192151480.13279@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Now that I have got the necessary piece of hardware (thanks, Thiemo!), I
may well offer myself as the maintainer for the dz serial driver.  I hope 
nobody objects.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 Please apply,

  Maciej

patch-mips-2.6.23-rc5-20070904-dz-maint-0
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/MAINTAINERS linux-mips-2.6.23-rc5-20070904/MAINTAINERS
--- linux-mips-2.6.23-rc5-20070904.macro/MAINTAINERS	2007-09-04 04:55:16.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/MAINTAINERS	2007-10-13 23:49:58.000000000 +0000
@@ -1352,6 +1352,11 @@ W:	http://linuxtv.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
 
+DZ DECSTATION DZ11 SERIAL DRIVER
+P:	Maciej W. Rozycki
+M:	macro@linux-mips.org
+S:	Maintained
+
 EATA-DMA SCSI DRIVER
 P:	Michael Neuffer
 L:	linux-eata@i-connect.net, linux-scsi@vger.kernel.org
