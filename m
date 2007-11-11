Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbXKKGsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbXKKGsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 01:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbXKKGsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 01:48:38 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:32853 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751605AbXKKGsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 01:48:37 -0500
Date: Sun, 11 Nov 2007 07:48:13 +0100
From: Adrian Bunk <bunk@kernel.org>
To: rgooch@atnf.csiro.au, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] MAINTAINERS: remove the MTRR entry
Message-ID: <20071111064813.GD21669@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't seen Richard doing MTRR related work for quite some time, and 
the "X86 ARCHITECTURE" entry in MAINTAINERS already covers the 
people currently responsible for this code.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
abbbf23fd306fc62d3b13c8e199142b3409d5ebd 
diff --git a/MAINTAINERS b/MAINTAINERS
index 1c7c229..66d60b3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2591,13 +2591,6 @@ L:	https://tango.0pointer.de/mailman/listinfo/s270-linux
 W:	http://0pointer.de/lennart/tchibo.html
 S:	Maintained
 
-MTRR AND SIMILAR SUPPORT [i386]
-P:	Richard Gooch
-M:	rgooch@atnf.csiro.au
-L:	linux-kernel@vger.kernel.org
-W:	http://www.atnf.csiro.au/~rgooch/linux/kernel-patches.html
-S:	Maintained
-
 MULTIMEDIA CARD (MMC), SECURE DIGITAL (SD) AND SDIO SUBSYSTEM
 P:	Pierre Ossman
 M:	drzeus-mmc@drzeus.cx

