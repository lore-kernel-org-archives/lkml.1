Return-Path: <linux-kernel-owner+w=401wt.eu-S943744AbXHMLAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943744AbXHMLAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967296AbXHMGhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:37:19 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1955 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967381AbXHMGgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:52 -0400
Date: Sun, 12 Aug 2007 23:36:38 -0700
From: joe@perches.com
To: wli@holomorphy.com, torvalds@linux-foundation.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [457/2many] MAINTAINERS - SPARC (sparc32):
Message-ID: <46bffbf6.K2JGi26y4RBCa+g4%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index aab0075..a91f3af 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4362,6 +4362,8 @@ P:	William L. Irwin
 M:	wli@holomorphy.com
 L:	sparclinux@vger.kernel.org
 S:	Maintained
+F:	arch/sparc/
+F:	include/asm-sparc/
 
 SPECIALIX IO8+ MULTIPORT SERIAL CARD DRIVER
 P:	Roger Wolff
