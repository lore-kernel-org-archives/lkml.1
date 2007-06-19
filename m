Return-Path: <linux-kernel-owner+w=401wt.eu-S1763599AbXFSSwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763599AbXFSSwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763018AbXFSSwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:52:06 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59479 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762954AbXFSSwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:52:02 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 19 Jun 2007 20:51:43 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] Documentation/HOWTO: remove stale git URL
To: Greg Kroah-Hartman <greg@kroah.com>
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.eee40c572537b7ba@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

and mention MAINTAINERS as pointer to development trees.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 Documentation/HOWTO |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6.22-rc5/Documentation/HOWTO
===================================================================
--- linux-2.6.22-rc5.orig/Documentation/HOWTO
+++ linux-2.6.22-rc5/Documentation/HOWTO
@@ -336,9 +336,6 @@ Here is a list of some of the different 
     - ia64 development tree, Tony Luck <tony.luck@intel.com>
 	kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
 
-    - ieee1394 development tree, Jody McIntyre <scjody@modernduck.com>
-	kernel.org:/pub/scm/linux/kernel/git/scjody/ieee1394.git
-
     - infiniband, Roland Dreier <rolandd@cisco.com>
 	kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
 
@@ -354,14 +351,15 @@ Here is a list of some of the different 
     - SCSI, James Bottomley <James.Bottomley@SteelEye.com>
 	kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
 
-  Other git kernel trees can be found listed at http://kernel.org/git
-
   quilt trees:
     - USB, PCI, Driver Core, and I2C, Greg Kroah-Hartman <gregkh@suse.de>
 	kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
     - x86-64, partly i386, Andi Kleen <ak@suse.de>
         ftp.firstfloor.org:/pub/ak/x86_64/quilt/
 
+  Other kernel trees can be found listed at http://kernel.org/git and in
+  the MAINTAINERS file.
+
 Bug Reporting
 -------------
 

-- 
Stefan Richter
-=====-=-=== -==- =--==
http://arcgraph.de/sr/

