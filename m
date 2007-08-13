Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbXHMKFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbXHMKFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967168AbXHMGeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:07 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1471 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965988AbXHMGd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:58 -0400
Date: Sun, 12 Aug 2007 23:33:44 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, pcihpd-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com,
       akpm@linux-foundation.org
Subject: [PATCH] [372/2many] MAINTAINERS - PCIE HOTPLUG DRIVER
Message-ID: <46bffb48.46kqq0mThGE/jN7t%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 15815b3..b0cf0a7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3580,6 +3580,7 @@ P:	Kristen Carlson Accardi
 M:	kristen.c.accardi@intel.com
 L:	pcihpd-discuss@lists.sourceforge.net
 S:	Supported
+F:	drivers/pci/pcie/
 
 PCMCIA SUBSYSTEM
 P:	Linux PCMCIA Team
