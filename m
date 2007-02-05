Return-Path: <linux-kernel-owner+w=401wt.eu-S1752720AbXBEFh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbXBEFh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 00:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbXBEFh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 00:37:58 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:26114 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbXBEFh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 00:37:57 -0500
Date: Sun, 4 Feb 2007 21:33:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net
Cc: bugzilla.kernel.org@beej.org, airlied@linux.ie, akpm <akpm@osdl.org>
Subject: [PATCH] update README.drm (bugzilla #7933)
Message-Id: <20070204213356.05737487.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Update URLs in drivers/char/drm/README.drm, to take care of
kernel bugzilla #7933.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/char/drm/README.drm |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- linux-2620-pv.orig/drivers/char/drm/README.drm
+++ linux-2620-pv/drivers/char/drm/README.drm
@@ -1,6 +1,6 @@
 ************************************************************
 * For the very latest on DRI development, please see:      *
-*     http://dri.sourceforge.net/                          *
+*     http://dri.freedesktop.org/wiki/FrontPage            *
 ************************************************************
 
 The Direct Rendering Manager (drm) is a device-independent kernel-level
@@ -26,21 +26,20 @@ ways:
 
 
 Documentation on the DRI is available from:
-    http://precisioninsight.com/piinsights.html
+    http://dri.freedesktop.org/wiki/Documentation
+    http://sourceforge.net/project/showfiles.php?group_id=387
+    http://dri.sourceforge.net/doc/
 
 For specific information about kernel-level support, see:
 
     The Direct Rendering Manager, Kernel Support for the Direct Rendering
     Infrastructure
-    http://precisioninsight.com/dr/drm.html
+    http://dri.sourceforge.net/doc/drm_low_level.html
 
     Hardware Locking for the Direct Rendering Infrastructure
-    http://precisioninsight.com/dr/locking.html
+    http://dri.sourceforge.net/doc/hardware_locking_low_level.html
 
     A Security Analysis of the Direct Rendering Infrastructure
-    http://precisioninsight.com/dr/security.html
+    http://dri.sourceforge.net/doc/security_low_level.html
 
 ************************************************************
-* For the very latest on DRI development, please see:      *
-*     http://dri.sourceforge.net/                          *
-************************************************************
