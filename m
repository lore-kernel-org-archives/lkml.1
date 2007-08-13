Return-Path: <linux-kernel-owner+w=401wt.eu-S943643AbXHMLCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943643AbXHMLCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967303AbXHMGhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:37:23 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2006 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967226AbXHMGhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:08 -0400
Date: Sun, 12 Aug 2007 23:36:53 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linuxsh-shmedia-dev@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, lethal@linux-sh.org,
       akpm@linux-foundation.org
Subject: [PATCH] [465/2many] MAINTAINERS - SUPERH64 (sh64)
Message-ID: <46bffc05.Zi+AgReNUMWozyrG%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f42712c..df097fb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4423,6 +4423,8 @@ M:	lethal@linux-sh.org
 L:	linuxsh-shmedia-dev@lists.sourceforge.net
 W:	http://www.linux-sh.org
 S:	Maintained
+F:	arch/sh64/
+F:	arch/asm-sh64/
 
 SUN3/3X
 P:	Sam Creasey
