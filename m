Return-Path: <linux-kernel-owner+w=401wt.eu-S942051AbXHMH3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942051AbXHMH3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966224AbXHMGZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:25:49 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4039 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966210AbXHMGZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:45 -0400
Date: Sun, 12 Aug 2007 23:25:31 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, scottm@somanetworks.com, scott@spiteful.org,
       pcihpd-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [131/2many] MAINTAINERS - COMPACTPCI HOTPLUG GENERIC
 DRIVER
Message-ID: <46bff95b.ibxq/wxhlADgEiOT%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index bc16c7a..4898b55 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1270,6 +1270,7 @@ M:	scottm@somanetworks.com
 M:	scott@spiteful.org
 L:	pcihpd-discuss@lists.sourceforge.net
 S:	Supported
+F:	drivers/pci/hotplug/cpcihp_generic.c
 
 COMPUTONE INTELLIPORT MULTIPORT CARD
 P:	Michael H. Warfield
