Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbXGAQrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbXGAQrv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 12:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbXGAQrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 12:47:43 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:45728 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbXGAQrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 12:47:42 -0400
X-Originating-Ip: 72.143.66.27
Date: Sun, 1 Jul 2007 12:45:56 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: jkenisto@us.ibm.com, schwidefsky@de.ibm.com
Subject: [PATCH] Update kprobes.txt to list s390 as supporting kprobes.
Message-ID: <Pine.LNX.4.64.0707011241220.2684@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  BTW, avr32 also has some support for kprobes, but it's implemented
in a non-standard way so i thought i'd just ignore that here.  if
someone thinks it should be added, i'm good with that, too.

  i have *no* idea who should sign off on this one.


diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index da5404a..63f6734 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -139,6 +139,7 @@ architectures:
 - i386
 - x86_64 (AMD-64, EM64T)
 - ppc64
+- s390
 - ia64 (Does not support probes on instruction slot1.)
 - sparc64 (Return probes not yet implemented.)

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
