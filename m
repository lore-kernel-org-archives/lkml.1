Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbYAARcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbYAARcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 12:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbYAARcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 12:32:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:16869 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbYAARcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 12:32:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=TfQa/u8eskR1P067ATDapK0cRJ9g4cXbv8X4wkcCz/y0DIutGgdSDRMkGpIXJFWPkCYnmBLFEpeIneo7fqy6Z2+0I+bxkfhicLwhajvVSVeF+N+QU4AXBk9Pa1PunLnuPQiKplxLbxBAq3sKn9Pw0k+etc8qc+OzIJrKClq6jWI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/3] ide: update/add my Copyrights
Date: Tue, 1 Jan 2008 18:42:40 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801011842.40134.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The last years stuff and a trip down memory lane...

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c       |    8 ++++----
 drivers/ide/ide-disk.c     |    9 +++++----
 drivers/ide/ide-dma.c      |    7 +++----
 drivers/ide/ide-floppy.c   |    5 +++--
 drivers/ide/ide-probe.c    |    3 ++-
 drivers/ide/ide-tape.c     |    3 ++-
 drivers/ide/ide-taskfile.c |    8 ++++----
 drivers/ide/ide.c          |    3 ++-
 drivers/ide/setup-pci.c    |    5 +++--
 drivers/scsi/ide-scsi.c    |    3 ++-
 10 files changed, 30 insertions(+), 24 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1,10 +1,10 @@
 /*
  * ATAPI CD-ROM driver.
  *
- * Copyright (C) 1994-1996  Scott Snyder <snyder@fnald0.fnal.gov>
- * Copyright (C) 1996-1998  Erik Andersen <andersee@debian.org>
- * Copyright (C) 1998-2000  Jens Axboe <axboe@suse.de>
- * Copyright (C)      2007  Bartlomiej Zolnierkiewicz
+ * Copyright (C) 1994-1996   Scott Snyder <snyder@fnald0.fnal.gov>
+ * Copyright (C) 1996-1998   Erik Andersen <andersee@debian.org>
+ * Copyright (C) 1998-2000   Jens Axboe <axboe@suse.de>
+ * Copyright (C) 2005, 2007  Bartlomiej Zolnierkiewicz
  *
  * May be copied or modified under the terms of the GNU General Public
  * License.  See linux/COPYING for more information.
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -1,8 +1,9 @@
 /*
- *  Copyright (C) 1994-1998  Linus Torvalds & authors (see below)
- *  Copyright (C) 1998-2002  Linux ATA Development
- *				Andre Hedrick <andre@linux-ide.org>
- *  Copyright (C) 2003	     Red Hat <alan@redhat.com>
+ *  Copyright (C) 1994-1998	   Linus Torvalds & authors (see below)
+ *  Copyright (C) 1998-2002	   Linux ATA Development
+ *				      Andre Hedrick <andre@linux-ide.org>
+ *  Copyright (C) 2003		   Red Hat <alan@redhat.com>
+ *  Copyright (C) 2003-2005, 2007  Bartlomiej Zolnierkiewicz
  */
 
 /*
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -1,14 +1,13 @@
 /*
- *  Copyright (c) 1999-2000	Andre Hedrick <andre@linux-ide.org>
+ *  Copyright (C) 1995-1998   Mark Lord
+ *  Copyright (C) 1999-2000   Andre Hedrick <andre@linux-ide.org>
+ *  Copyright (C) 2004, 2007  Bartlomiej Zolnierkiewicz
  *
  *  May be copied or modified under the terms of the GNU General Public License
  */
 
 /*
  *  Special Thanks to Mark for his Six years of work.
- *
- *  Copyright (c) 1995-1998  Mark Lord
- *  May be copied or modified under the terms of the GNU General Public License
  */
 
 /*
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -1,6 +1,7 @@
 /*
- * Copyright (C) 1996 - 1999 Gadi Oxman <gadio@netvision.net.il>
- * Copyright (C) 2000 - 2002 Paul Bristow <paul@paulbristow.net>
+ * Copyright (C) 1996-1999  Gadi Oxman <gadio@netvision.net.il>
+ * Copyright (C) 2000-2002  Paul Bristow <paul@paulbristow.net>
+ * Copyright (C) 2005       Bartlomiej Zolnierkiewicz
  */
 
 /*
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1,5 +1,6 @@
 /*
- *  Copyright (C) 1994-1998  Linus Torvalds & authors (see below)
+ *  Copyright (C) 1994-1998   Linus Torvalds & authors (see below)
+ *  Copyright (C) 2005, 2007  Bartlomiej Zolnierkiewicz
  */
 
 /*
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1,5 +1,6 @@
 /*
- * Copyright (C) 1995 - 1999 Gadi Oxman <gadio@netvision.net.il>
+ * Copyright (C) 1995-1999  Gadi Oxman <gadio@netvision.net.il>
+ * Copyright (C) 2003-2005  Bartlomiej Zolnierkiewicz
  *
  * $Header$
  *
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -1,9 +1,9 @@
 /*
- *  Copyright (C) 2000-2002	Michael Cornwell <cornwell@acm.org>
- *  Copyright (C) 2000-2002	Andre Hedrick <andre@linux-ide.org>
- *  Copyright (C) 2001-2002	Klaus Smolin
+ *  Copyright (C) 2000-2002	   Michael Cornwell <cornwell@acm.org>
+ *  Copyright (C) 2000-2002	   Andre Hedrick <andre@linux-ide.org>
+ *  Copyright (C) 2001-2002	   Klaus Smolin
  *					IBM Storage Technology Division
- *  Copyright (C) 2003-2004	Bartlomiej Zolnierkiewicz
+ *  Copyright (C) 2003-2004, 2007  Bartlomiej Zolnierkiewicz
  *
  *  The big the bad and the ugly.
  */
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1,5 +1,6 @@
 /*
- *  Copyright (C) 1994-1998  Linus Torvalds & authors (see below)
+ *  Copyright (C) 1994-1998	    Linus Torvalds & authors (see below)
+ *  Copyrifht (C) 2003-2005, 2007   Bartlomiej Zolnierkiewicz
  */
 
 /*
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -1,6 +1,7 @@
 /*
- *  Copyright (c) 1998-2000  Andre Hedrick <andre@linux-ide.org>
- *  Copyright (c) 1995-1998  Mark Lord
+ *  Copyright (C) 1998-2000  Andre Hedrick <andre@linux-ide.org>
+ *  Copyright (C) 1995-1998  Mark Lord
+ *  Copyright (C)      2007  Bartlomiej Zolnierkiewicz
  *
  *  May be copied or modified under the terms of the GNU General Public License
  */
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -1,5 +1,6 @@
 /*
- * Copyright (C) 1996 - 1999 Gadi Oxman <gadio@netvision.net.il>
+ * Copyright (C) 1996-1999  Gadi Oxman <gadio@netvision.net.il>
+ * Copyright (C) 2004-2005  Bartlomiej Zolnierkiewicz
  */
 
 /*
