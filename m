Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbXJWWVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbXJWWVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbXJWWVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:21:10 -0400
Received: from palrel13.hp.com ([156.153.255.238]:43474 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbXJWWVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:21:08 -0400
X-Greylist: delayed 1153 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Oct 2007 18:21:08 EDT
Date: Tue, 23 Oct 2007 16:54:59 -0500
From: Mike Miller <mike.miller@hp.com>
To: jens.axboe@oracle.com
Cc: linux-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: [PATCH 1/1] cciss: update copyright notices
Message-ID: <20071023215459.GA5861@roadking.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PATCH 1 of 1

This patch updates the copyright information for the cciss driver. It
includes extending the year to 2007 (how timely) and some minor corrections
deemed necessary by HP legal and the Open Source Review Board. Please
consider this patch for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
--------------------------------------------------------------------------------
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index e330c26..cd37e92 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1,20 +1,20 @@
 /*
- *    Disk Array driver for HP SA 5xxx and 6xxx Controllers
- *    Copyright 2000, 2006 Hewlett-Packard Development Company, L.P.
+ *    Disk Array driver for HP Smart Array controllers.
+ *    (C) Copyright 2000, 2007 Hewlett-Packard Development Company, L.P.
  *
  *    This program is free software; you can redistribute it and/or modify
  *    it under the terms of the GNU General Public License as published by
- *    the Free Software Foundation; either version 2 of the License, or
- *    (at your option) any later version.
+ *    the Free Software Foundation; version 2 of the License.
  *
  *    This program is distributed in the hope that it will be useful,
  *    but WITHOUT ANY WARRANTY; without even the implied warranty of
- *    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *    NON INFRINGEMENT.  See the GNU General Public License for more details.
+ *    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ *    General Public License for more details.
  *
  *    You should have received a copy of the GNU General Public License
  *    along with this program; if not, write to the Free Software
- *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ *    02111-1307, USA.
  *
  *    Questions/Comments/Bugfixes to iss_storagedev@hp.com
  *
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 4aca7dd..63ee6c0 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -1,20 +1,20 @@
 /*
- *    Disk Array driver for Compaq SA53xx Controllers, SCSI Tape module
- *    Copyright 2001 Compaq Computer Corporation
+ *    Disk Array driver for HP Smart Array controllers, SCSI Tape module.
+ *    (C) Copyright 2001, 2007 Hewlett-Packard Development Company, L.P.
  *
  *    This program is free software; you can redistribute it and/or modify
  *    it under the terms of the GNU General Public License as published by
- *    the Free Software Foundation; either version 2 of the License, or
- *    (at your option) any later version.
+ *    the Free Software Foundation; version 2 of the License.
  *
  *    This program is distributed in the hope that it will be useful,
  *    but WITHOUT ANY WARRANTY; without even the implied warranty of
- *    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *    NON INFRINGEMENT.  See the GNU General Public License for more details.
+ *    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ *    General Public License for more details.
  *
  *    You should have received a copy of the GNU General Public License
  *    along with this program; if not, write to the Free Software
- *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *    Foundation, Inc., 59 Temple Place, Suite 300, Boston, MA
+ *    02111-1307, USA.
  *
  *    Questions/Comments/Bugfixes to iss_storagedev@hp.com
  *    
diff --git a/drivers/block/cciss_scsi.h b/drivers/block/cciss_scsi.h
index 5e7e06c..d9c2c58 100644
--- a/drivers/block/cciss_scsi.h
+++ b/drivers/block/cciss_scsi.h
@@ -1,20 +1,20 @@
 /*
- *    Disk Array driver for Compaq SA53xx Controllers, SCSI Tape module
- *    Copyright 2001 Compaq Computer Corporation
+ *    Disk Array driver for HP Smart Array controllers, SCSI Tape module.
+ *    (C) Copyright 2001, 2007 Hewlett-Packard Development Company, L.P.
  *
  *    This program is free software; you can redistribute it and/or modify
  *    it under the terms of the GNU General Public License as published by
- *    the Free Software Foundation; either version 2 of the License, or
- *    (at your option) any later version.
+ *    the Free Software Foundation; version 2 of the License.
  *
  *    This program is distributed in the hope that it will be useful,
  *    but WITHOUT ANY WARRANTY; without even the implied warranty of
- *    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *    NON INFRINGEMENT.  See the GNU General Public License for more details.
+ *    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ *    General Public License for more details.
  *
  *    You should have received a copy of the GNU General Public License
  *    along with this program; if not, write to the Free Software
- *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *    Foundation, Inc., 59 Temple Place, Suite 300, Boston, MA
+ *    02111-1307, USA.
  *
  *    Questions/Comments/Bugfixes to iss_storagedev@hp.com
  *
