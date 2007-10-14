Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbXJNBzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbXJNBzu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 21:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbXJNBzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 21:55:42 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:34279
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbXJNBzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 21:55:41 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: akpm@linux-foundation.org
Subject: [PATCH] Update Jens Axboe's email in Documentation/*
Date: Sat, 13 Oct 2007 20:55:36 -0500
User-Agent: KMail/1.9.6
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200710132055.36663.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Jens Axboe's old email address bounces.

Signed-off-by: Rob Landley <rob@landley.net>
---

He's emailing from oracle.com these days, and the old one bounced with:

<axboe@suse.de>: host mx2.suse.de[195.135.220.15] said: 550 <axboe@suse.de>:
    Recipient address rejected: User has moved to <unknown> (in reply to RCPT
    TO command)

 Documentation/DMA-mapping.txt            |    2 +-
 Documentation/HOWTO                      |    2 +-
 Documentation/block/biodoc.txt           |    4 ++--
 Documentation/block/deadline-iosched.txt |    2 +-
 Documentation/block/ioprio.txt           |    2 +-
 Documentation/block/request.txt          |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff -r 79f0ea1e0e70 Documentation/DMA-mapping.txt
--- a/Documentation/DMA-mapping.txt	Tue Oct 09 21:00:40 2007 +0000
+++ b/Documentation/DMA-mapping.txt	Sat Oct 13 20:51:42 2007 -0500
@@ -782,5 +782,5 @@ following people:
 	Jay Estabrook <Jay.Estabrook@compaq.com>
 	Thomas Sailer <sailer@ife.ee.ethz.ch>
 	Andrea Arcangeli <andrea@suse.de>
-	Jens Axboe <axboe@suse.de>
+	Jens Axboe <jens.axboe@oracle.com>
 	David Mosberger-Tang <davidm@hpl.hp.com>
diff -r 79f0ea1e0e70 Documentation/HOWTO
--- a/Documentation/HOWTO	Tue Oct 09 21:00:40 2007 +0000
+++ b/Documentation/HOWTO	Sat Oct 13 20:51:42 2007 -0500
@@ -330,7 +330,7 @@ Here is a list of some of the different 
     - ACPI development tree, Len Brown <len.brown@intel.com>
 	git.kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
 
-    - Block development tree, Jens Axboe <axboe@suse.de>
+    - Block development tree, Jens Axboe <jens.axboe@oracle.com>
 	git.kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
 
     - DRM development tree, Dave Airlie <airlied@linux.ie>
diff -r 79f0ea1e0e70 Documentation/block/biodoc.txt
--- a/Documentation/block/biodoc.txt	Tue Oct 09 21:00:40 2007 +0000
+++ b/Documentation/block/biodoc.txt	Sat Oct 13 20:51:42 2007 -0500
@@ -2,7 +2,7 @@
 	=====================================================
 
 Notes Written on Jan 15, 2002:
-	Jens Axboe <axboe@suse.de>
+	Jens Axboe <jens.axboe@oracle.com>
 	Suparna Bhattacharya <suparna@in.ibm.com>
 
 Last Updated May 2, 2002
@@ -21,7 +21,7 @@ Credits:
 ---------
 
 2.5 bio rewrite:
-	Jens Axboe <axboe@suse.de>
+	Jens Axboe <jens.axboe@oracle.com>
 
 Many aspects of the generic block layer redesign were driven by and evolved
 over discussions, prior patches and the collective experience of several
diff -r 79f0ea1e0e70 Documentation/block/deadline-iosched.txt
--- a/Documentation/block/deadline-iosched.txt	Tue Oct 09 21:00:40 2007 +0000
+++ b/Documentation/block/deadline-iosched.txt	Sat Oct 13 20:51:42 2007 -0500
@@ -73,6 +73,6 @@ rbtree front sector lookup when the io s
 rbtree front sector lookup when the io scheduler merge function is called.
 
 
-Nov 11 2002, Jens Axboe <axboe@suse.de>
+Nov 11 2002, Jens Axboe <jens.axboe@oracle.com>
 
 
diff -r 79f0ea1e0e70 Documentation/block/ioprio.txt
--- a/Documentation/block/ioprio.txt	Tue Oct 09 21:00:40 2007 +0000
+++ b/Documentation/block/ioprio.txt	Sat Oct 13 20:51:42 2007 -0500
@@ -173,4 +173,4 @@ int main(int argc, char *argv[])
 ---> snip ionice.c tool <---
 
 
-March 11 2005, Jens Axboe <axboe@suse.de>
+March 11 2005, Jens Axboe <jens.axboe@oracle.com>
diff -r 79f0ea1e0e70 Documentation/block/request.txt
--- a/Documentation/block/request.txt	Tue Oct 09 21:00:40 2007 +0000
+++ b/Documentation/block/request.txt	Sat Oct 13 20:51:42 2007 -0500
@@ -1,7 +1,7 @@
 
 struct request documentation
 
-Jens Axboe <axboe@suse.de> 27/05/02
+Jens Axboe <jens.axboe@oracle.com> 27/05/02
 
 1.0
 Index

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
