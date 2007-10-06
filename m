Return-Path: <linux-kernel-owner+w=401wt.eu-S1758785AbXJFIEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbXJFIEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 04:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbXJFIEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 04:04:13 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:33020 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbXJFIEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 04:04:10 -0400
Date: Sat, 6 Oct 2007 10:05:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Kai Germaschewski <kai@germaschewski.name>
Subject: [PATCH] kbuild: move Kai Germaschewski to CREDITS
Message-ID: <20071006080540.GA4798@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have just pushed following patch to kbuild.git.

And with this mail I want to give Kai all the thanks
he deserves for his major kbuild work during the 2.5
kernel series.
He left us a reliable and working kbuild to continue
to use and hack on.

THANKS!

	Sam

Subject: [PATCH] kbuild: move Kai Germaschewski to CREDITS

Kai is not active in kernel development these
days so give him credit for his major kbuild
contribution and ISDN work.

Acked-by: Kai Germaschewski <kai@germaschewski.name>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 CREDITS     |    6 ++++++
 MAINTAINERS |    4 ----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/CREDITS b/CREDITS
index 832436e..a305f0b 100644
--- a/CREDITS
+++ b/CREDITS
@@ -1149,6 +1149,12 @@ S: 600 North Bell Avenue, Suite 160
 S: Carnegie, Pennsylvania 15106-4304
 S: USA
 
+N: Kai Germaschewski
+E: kai@germaschewski.name
+D: Major kbuild rework during the 2.5 cycle
+D: ISDN Maintainer
+S: USA
+
 N: Philip Gladstone
 E: philip@gladstonefamily.net
 D: Kernel / timekeeping stuff
diff --git a/MAINTAINERS b/MAINTAINERS
index 9c54a5e..d09102b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2110,8 +2110,6 @@ S:	Maintained
 ISDN SUBSYSTEM
 P:	Karsten Keil
 M:	kkeil@suse.de
-P:	Kai Germaschewski
-M:	kai.germaschewski@gmx.de
 L:	isdn4linux@listserv.isdn4linux.de
 W:	http://www.isdn4linux.de
 T:	git kernel.org:/pub/scm/linux/kernel/kkeil/isdn-2.6.git
@@ -2180,8 +2178,6 @@ L:	autofs@linux.kernel.org
 S:	Maintained
 
 KERNEL BUILD (kbuild: Makefile, scripts/Makefile.*)
-P:	Kai Germaschewski
-M:	kai@germaschewski.name
 P:	Sam Ravnborg
 M:	sam@ravnborg.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild.git
-- 
1.5.2.4

