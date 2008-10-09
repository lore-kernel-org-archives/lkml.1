Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbYJIXzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbYJIXzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 19:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYJIXy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 19:54:59 -0400
Received: from xenotime.net ([66.160.160.81]:37305 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751984AbYJIXy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 19:54:57 -0400
Date: Thu, 09 Oct 2008 16:52:35 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] docs: fix CDROM missing test program reference
Message-ID: <12235963553813@xenotime.net>
In-Reply-To: <12235963551043@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Reported-by: Nick Warne <nick@ukfsn.org>
The sbpcd tester program is not included in the kernel source tree,
so remove the reference to it.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/cdrom/ide-cd |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.27-rc9-git2.orig/Documentation/cdrom/ide-cd
+++ linux-2.6.27-rc9-git2/Documentation/cdrom/ide-cd
@@ -145,8 +145,7 @@ useful for reading photocds.
 
 To play an audio CD, you should first unmount and remove any data
 CDROM.  Any of the CDROM player programs should then work (workman,
-workbone, cdplayer, etc.).  Lacking anything else, you could use the
-cdtester program in Documentation/cdrom/sbpcd.
+workbone, cdplayer, etc.).
 
 On a few drives, you can read digital audio directly using a program
 such as cdda2wav.  The only types of drive which I've heard support


-- 

