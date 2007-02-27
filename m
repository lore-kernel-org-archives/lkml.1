Return-Path: <linux-kernel-owner+w=401wt.eu-S1750719AbXB0LBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750719AbXB0LBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 06:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750742AbXB0LBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 06:01:35 -0500
Received: from havoc.gtf.org ([69.61.125.42]:43470 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbXB0LBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 06:01:34 -0500
Date: Tue, 27 Feb 2007 06:01:33 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] remove JFFS from MAINTAINERS
Message-ID: <20070227110133.GA14115@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'jffs-maint' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git jffs-maint

to receive the following updates:

 MAINTAINERS |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

Adrian Bunk (1):
      remove the jffs MAINTAINERS entry

diff --git a/MAINTAINERS b/MAINTAINERS
index 10054b4..06d2087 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1906,13 +1906,6 @@ L:	isdn4linux@listserv.isdn4linux.de
 W:	http://www.melware.de
 S:	Maintained
 
-JOURNALLING FLASH FILE SYSTEM (JFFS)
-P:	Axis Communications AB
-M:	jffs-dev@axis.com
-L:	jffs-dev@axis.com
-W:	http://www.developer.axis.com/software/jffs/
-S:	Maintained
-
 JOURNALLING FLASH FILE SYSTEM V2 (JFFS2)
 P:	David Woodhouse
 M:	dwmw2@infradead.org
