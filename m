Return-Path: <linux-kernel-owner+w=401wt.eu-S966732AbXHMHaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966732AbXHMHaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965613AbXHMGZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:25:51 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4038 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965681AbXHMGZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:45 -0400
Date: Sun, 12 Aug 2007 23:25:27 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, scottm@somanetworks.com, scott@spiteful.org,
       pcihpd-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [129/2many] MAINTAINERS - COMPACTPCI HOTPLUG CORE
Message-ID: <46bff957.2LD9kVYAisjqMkFO%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 6721969..16714f8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1254,6 +1254,7 @@ M:	scottm@somanetworks.com
 M:	scott@spiteful.org
 L:	pcihpd-discuss@lists.sourceforge.net
 S:	Supported
+F:	drivers/pci/hotplug/cpci_hotplug*
 
 COMPACTPCI HOTPLUG ZIATECH ZT5550 DRIVER
 P:	Scott Murray
