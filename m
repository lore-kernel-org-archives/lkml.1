Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbXHMKHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbXHMKHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966948AbXHMGeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:22 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1465 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967156AbXHMGd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:56 -0400
Date: Sun, 12 Aug 2007 23:33:42 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kristen.c.accardi@intel.com, akpm@linux-foundation.org
Subject: [PATCH] [371/2many] MAINTAINERS - PCI HOTPLUG CORE
Message-ID: <46bffb46.EvsU/6IHJ7uw25Bo%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 86e2e6c..15815b3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3568,9 +3568,12 @@ F:	drivers/pci/
 F:	include/linux/pci*
 
 PCI HOTPLUG CORE
-P: 	Kristen Carlson Accardi
+P:	Kristen Carlson Accardi
 M:	kristen.c.accardi@intel.com
 S:	Supported
+F:	drivers/pci/hotplug/
+F:	drivers/pci/hotplug.c
+F:	include/linux/pci_hotplug.h
 
 PCIE HOTPLUG DRIVER
 P:	Kristen Carlson Accardi
