Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbZCLViW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbZCLViW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 17:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZCLViN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 17:38:13 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:45553 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbZCLViM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 17:38:12 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
Date: Thu, 12 Mar 2009 17:39:23 -0400
From: Jody McIntyre <scjody@sun.com>
Subject: [PATCH] trivial: fix bad links in the ext2 and ext3 documentation
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Message-id: <20090312213922.GK8732@clouds>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial patch to fix bad links in the ext2 and ext3 documentation.

Signed-off-by: Jody McIntyre <scjody@sun.com>

Index: linux-2.6/Documentation/filesystems/ext2.txt
===================================================================
--- linux-2.6.orig/Documentation/filesystems/ext2.txt
+++ linux-2.6/Documentation/filesystems/ext2.txt
@@ -373,10 +373,10 @@ Filesystem Resizing	http://ext2resize.so
 Compression (*)		http://e2compr.sourceforge.net/
 
 Implementations for:
-Windows 95/98/NT/2000	http://uranus.it.swin.edu.au/~jn/linux/Explore2fs.htm
-Windows 95 (*)		http://www.yipton.demon.co.uk/content.html#FSDEXT2
+Windows 95/98/NT/2000	http://www.chrysocome.net/explore2fs
+Windows 95 (*)		http://www.yipton.net/content.html#FSDEXT2
 DOS client (*)		ftp://metalab.unc.edu/pub/Linux/system/filesystems/ext2/
-OS/2			http://perso.wanadoo.fr/matthieu.willm/ext2-os2/
-RISC OS client		ftp://ftp.barnet.ac.uk/pub/acorn/armlinux/iscafs/
+OS/2 (*)		ftp://metalab.unc.edu/pub/Linux/system/filesystems/ext2/
+RISC OS client		http://www.esw-heim.tu-clausthal.de/~marco/smorbrod/IscaFS/
 
-(*) no longer actively developed/supported (as of Apr 2001)
+(*) no longer actively developed/supported (as of Mar 2009)
Index: linux-2.6/Documentation/filesystems/ext3.txt
===================================================================
--- linux-2.6.orig/Documentation/filesystems/ext3.txt
+++ linux-2.6/Documentation/filesystems/ext3.txt
@@ -198,5 +198,5 @@ kernel source:	<file:fs/ext3/>
 programs: 	http://e2fsprogs.sourceforge.net/
 		http://ext2resize.sourceforge.net
 
-useful links:	http://www-106.ibm.com/developerworks/linux/library/l-fs7/
-		http://www-106.ibm.com/developerworks/linux/library/l-fs8/
+useful links:	http://www.ibm.com/developerworks/library/l-fs7.html
+		http://www.ibm.com/developerworks/library/l-fs8.html
