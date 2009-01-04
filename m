Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbZADL6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbZADL6X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZADL6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:58:13 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:49582 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbZADL6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:58:12 -0500
Date: Sun, 4 Jan 2009 12:59:47 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "David S. Miller" <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>, wli@holomorphy.com,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] MAINTAINERS: update sparc maintainer
Message-ID: <20090104115947.GA32643@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reflect the current situation where David Miller
is the sparc maintainer.

I have tried to contact Bill on following adresses:

    wli@holomorphy.com
    wlirwin@us.ibm.com

with no success and Bill has not been active on the
sparclinux mailing list for a long time.

As sparc and sparc64 are unified I unified the two entries
in the MAINTAINERS file too.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---

I added Bill to this mail to do a second attempt on the holomorphy address.

Note: This patch should have an ack from David before it goes in.

	Sam

diff --git a/MAINTAINERS b/MAINTAINERS
index befacf0..141aff6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4015,10 +4015,12 @@ L:	alsa-devel@alsa-project.org (subscribers-only)
 W:	http://alsa-project.org/main/index.php/ASoC
 S:	Supported
 
-SPARC (sparc32)
-P:	William L. Irwin
-M:	wli@holomorphy.com
+SPARC + UltraSPARC (sparc/sparc64)
+P:	David S. Miller
+M:	davem@davemloft.net
 L:	sparclinux@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git
+T:	git kernel.org:/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git
 S:	Maintained
 
 SPECIALIX IO8+ MULTIPORT SERIAL CARD DRIVER
@@ -4302,13 +4304,6 @@ M:	dushistov@mail.ru
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
-UltraSPARC (sparc64)
-P:	David S. Miller
-M:	davem@davemloft.net
-L:	sparclinux@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git
-S:	Maintained
-
 ULTRA-WIDEBAND (UWB) SUBSYSTEM:
 P:	David Vrabel
 M:	david.vrabel@csr.com
