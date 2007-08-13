Return-Path: <linux-kernel-owner+w=401wt.eu-S939968AbXHMG5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939968AbXHMG5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965981AbXHMGXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:49 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3707 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965978AbXHMGXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:48 -0400
Date: Sun, 12 Aug 2007 23:23:36 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [70/2many] MAINTAINERS - ARPD SUPPORT
Message-ID: <46bff8e8.HhTQ7TBPy1zkcNfh%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 90c1b81..ac2226b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -697,6 +697,7 @@ ARPD SUPPORT
 P:	Jonathan Layes
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	net/ipv4/arp.c
 
 ASUS ACPI EXTRAS DRIVER
 P:	Corentin Chary
