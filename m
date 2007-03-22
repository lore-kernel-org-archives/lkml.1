Return-Path: <linux-kernel-owner+w=401wt.eu-S965549AbXCVA1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965549AbXCVA1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 20:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965553AbXCVA1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 20:27:30 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:45019 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965549AbXCVA13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 20:27:29 -0400
Date: Wed, 21 Mar 2007 17:25:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: [PATCH] More "deprecated" spellos
Message-Id: <20070321172508.6aa66aa4.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0702220437370.22382@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0702220437370.22382@CPE00045a9c397f-CM001225dbafb6>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007 04:39:40 -0500 (EST) Robert P. J. Day wrote:

>   Fix remaining misspellings of "depreciated" to "deprecated."

More of these.
---

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix more "deprecated" spellos.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/fb/aty128fb.txt      |    4 ++--
 Documentation/filesystems/proc.txt |    2 +-
 drivers/pci/pci-driver.c           |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.21-rc4-git5.orig/drivers/pci/pci-driver.c
+++ linux-2.6.21-rc4-git5/drivers/pci/pci-driver.c
@@ -133,7 +133,7 @@ static inline int pci_create_newid_file(
  * system is in its list of supported devices.  Returns the matching
  * pci_device_id structure or %NULL if there is no match.
  *
- * Depreciated, don't use this as it will not catch any dynamic ids
+ * Deprecated, don't use this as it will not catch any dynamic ids
  * that a driver might want to check for.
  */
 const struct pci_device_id *pci_match_id(const struct pci_device_id *ids,
--- linux-2.6.21-rc4-git5.orig/Documentation/fb/aty128fb.txt
+++ linux-2.6.21-rc4-git5/Documentation/fb/aty128fb.txt
@@ -54,8 +54,8 @@ Accepted options:
 
 noaccel  - do not use acceleration engine. It is default.
 accel    - use acceleration engine. Not finished.
-vmode:x  - chooses PowerMacintosh video mode <x>. Depreciated.
-cmode:x  - chooses PowerMacintosh colour mode <x>. Depreciated.
+vmode:x  - chooses PowerMacintosh video mode <x>. Deprecated.
+cmode:x  - chooses PowerMacintosh colour mode <x>. Deprecated.
 <XxX@X>  - selects startup videomode. See modedb.txt for detailed
 	   explanation. Default is 640x480x8bpp.
 
--- linux-2.6.21-rc4-git5.orig/Documentation/filesystems/proc.txt
+++ linux-2.6.21-rc4-git5/Documentation/filesystems/proc.txt
@@ -228,7 +228,7 @@ Table 1-3: Kernel info in /proc 
  mounts      Mounted filesystems                               
  net         Networking info (see text)                        
  partitions  Table of partitions known to the system           
- pci	     Depreciated info of PCI bus (new way -> /proc/bus/pci/, 
+ pci	     Deprecated info of PCI bus (new way -> /proc/bus/pci/,
              decoupled by lspci					(2.4)
  rtc         Real time clock                                   
  scsi        SCSI info (see text)                              
