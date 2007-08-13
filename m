Return-Path: <linux-kernel-owner+w=401wt.eu-S1761646AbXHMLDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646AbXHMLDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967396AbXHMGhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:37:25 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2001 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965350AbXHMGhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:08 -0400
Date: Sun, 12 Aug 2007 23:36:51 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       lethal@linux-sh.org, akpm@linux-foundation.org
Subject: [PATCH] [464/2many] MAINTAINERS - SUPERH (sh)
Message-ID: <46bffc03.4E2RshjUw+dyxP1/%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3e51fc6..f42712c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4414,6 +4414,8 @@ M:	lethal@linux-sh.org
 L:	linuxsh-dev@lists.sourceforge.net (subscribers-only)
 W:	http://www.linux-sh.org
 S:	Maintained
+F:	arch/sh/
+F:	arch/asm-sh/
 
 SUPERH64 (sh64)
 P:	Paul Mundt
