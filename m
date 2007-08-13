Return-Path: <linux-kernel-owner+w=401wt.eu-S969523AbXHMI3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969523AbXHMI3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966792AbXHMG3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:29:25 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4629 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763498AbXHMG3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:23 -0400
Date: Sun, 12 Aug 2007 23:29:10 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [235/2many] MAINTAINERS - IA64 (Itanium) PLATFORM
Message-ID: <46bffa36.aUiLcDMm3snOLBwG%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 802960b..f68199b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2237,6 +2237,8 @@ L:	linux-ia64@vger.kernel.org
 W:	http://www.ia64-linux.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
 S:	Maintained
+F:	arch/ia64/
+F:	include/asm-ia64/*
 
 SN-IA64 (Itanium) SUB-PLATFORM
 P:	Jes Sorensen
