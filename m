Return-Path: <linux-kernel-owner+w=401wt.eu-S966463AbXHMG2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966463AbXHMG2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965629AbXHMGWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:22:34 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3462 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965525AbXHMGW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:28 -0400
Date: Sun, 12 Aug 2007 23:22:12 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, pcihpd-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com,
       akpm@linux-foundation.org
Subject: [PATCH] [26/2many] MAINTAINERS - ACPI PCI HOTPLUG DRIVER
Message-ID: <46bff894.Hq7pD9aego483mHU%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e99d959..aca4528 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -284,6 +284,7 @@ P:	Kristen Carlson Accardi
 M:	kristen.c.accardi@intel.com
 L:	pcihpd-discuss@lists.sourceforge.net
 S:	Supported
+F:	drivers/pci/hotplug/acip*
 
 ACPI THERMAL DRIVER
 P:	Konstantin A. Karasyov
