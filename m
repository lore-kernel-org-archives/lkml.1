Return-Path: <linux-kernel-owner+w=401wt.eu-S1760396AbXHMJ6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760396AbXHMJ6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965215AbXHMGd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:58 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1444 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967089AbXHMGdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:51 -0400
Date: Sun, 12 Aug 2007 23:33:36 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, linas@austin.ibm.com,
       akpm@linux-foundation.org
Subject: [PATCH] [368/2many] MAINTAINERS - PCI ERROR RECOVERY
Message-ID: <46bffb40.7D/m17Ax02HusrIA%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c3bd8f8..93f385f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3543,6 +3543,8 @@ M:	linas@austin.ibm.com
 L:	linux-kernel@vger.kernel.org
 L:	linux-pci@atrey.karlin.mff.cuni.cz
 S:	Supported
+F:	Documentation/pci-error-recovery.txt
+F:	Documentation/powerpc/eeh-pci-error-recovery.txt
 
 PCI SOUND DRIVERS (ES1370, ES1371 and SONICVIBES)
 P:	Thomas Sailer
