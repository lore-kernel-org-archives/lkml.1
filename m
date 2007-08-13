Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbXHMKAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbXHMKAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967112AbXHMGeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:06 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1461 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967154AbXHMGd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:56 -0400
Date: Sun, 12 Aug 2007 23:33:40 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
Subject: [PATCH] [370/2many] MAINTAINERS - PCI SUBSYSTEM
Message-ID: <46bffb44.cxVxpLtQYfiDVMDe%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 59ba494..86e2e6c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3563,6 +3563,9 @@ L:	linux-kernel@vger.kernel.org
 L:	linux-pci@atrey.karlin.mff.cuni.cz
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 S:	Supported
+F:	Documentation/pci.txt
+F:	drivers/pci/
+F:	include/linux/pci*
 
 PCI HOTPLUG CORE
 P: 	Kristen Carlson Accardi
