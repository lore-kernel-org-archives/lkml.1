Return-Path: <linux-kernel-owner+w=401wt.eu-S1756291AbXHMKBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbXHMKBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967100AbXHMGeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:09 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1474 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967161AbXHMGd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:59 -0400
Date: Sun, 12 Aug 2007 23:33:46 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [373/2many] MAINTAINERS - PCMCIA SUBSYSTEM
Message-ID: <46bffb4a.T4iLrjVaXLCXPxXL%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b0cf0a7..f6b84d2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3585,9 +3585,14 @@ F:	drivers/pci/pcie/
 PCMCIA SUBSYSTEM
 P:	Linux PCMCIA Team
 L:	linux-pcmcia@lists.infradead.org
-L:	http://lists.infradead.org/mailman/listinfo/linux-pcmcia
+W:	http://lists.infradead.org/mailman/listinfo/linux-pcmcia
 T:	git kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
 S:	Maintained
+F:	Documentation/pcmcia/
+F:	drivers/*/pcmcia/
+F:	drivers/pcmcia/
+F:	include/pcmcia/
+F:	sound/pcmcia/
 
 PCNET32 NETWORK DRIVER
 P:	Don Fry
