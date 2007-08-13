Return-Path: <linux-kernel-owner+w=401wt.eu-S936751AbXHMKwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936751AbXHMKwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967366AbXHMGgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:46 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1920 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758430AbXHMGgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:41 -0400
Date: Sun, 12 Aug 2007 23:36:25 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       akpm@linux-foundation.org
Subject: [PATCH] [452/2many] MAINTAINERS - UltraSPARC (sparc64):
Message-ID: <46bffbe9.HKclFFagHgDWmT4p%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e6d5c86..52c9db7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4313,6 +4313,8 @@ M:	davem@davemloft.net
 L:	sparclinux@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git
 S:	Maintained
+F:	arch/sparc64/
+F:	include/asm-sparc64/
 
 SHARP LH SUPPORT (LH7952X & LH7A40X)
 P:	Marc Singer
