Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYATQav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYATQav (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 11:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbYATQam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 11:30:42 -0500
Received: from mail.acc.umu.se ([130.239.18.156]:54937 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbYATQal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 11:30:41 -0500
X-Greylist: delayed 1231 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jan 2008 11:30:41 EST
Date: Sun, 20 Jan 2008 17:10:01 +0100
From: Linus Nilsson <lajnold@acc.umu.se>
To: torvalds@linux-foundation.org
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] Makefile: Change typoed 'behavour' to 'behaviour'
Message-ID: <20080120160957.GA21527@montezuma.acc.umu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Nilsson <lajnold@acc.umu.se>

Change two occurances of "behavour" to "behaviour".

Signed-off-by: Linus Nilsson <lajnold@acc.umu.se>

---
 Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- kernel/Makefile.orig     2008-01-20 15:08:34.000000000 +0100
+++ kernel/Makefile  2008-01-20 15:11:59.000000000 +0100
@@ -12,7 +12,7 @@ NAME = Arr Matey! A Hairy Bilge Rat!
 
 # Do not:
 # o  use make's built-in rules and variables
-#    (this increases performance and avoid hard-to-debug behavour);
+#    (this increases performance and avoid hard-to-debug behaviour);
 # o  print "Entering directory ...";
 MAKEFLAGS += -rR --no-print-directory
 
@@ -1329,7 +1329,7 @@ else
 ALLINCLUDE_ARCHS := $(SRCARCH)
 endif
 else
-#Allow user to specify only ALLSOURCE_PATHS on the command line, keeping existing behavour.
+#Allow user to specify only ALLSOURCE_PATHS on the command line, keeping existing behaviour.
 ALLINCLUDE_ARCHS := $(ALLSOURCE_ARCHS)
 endif

