Return-Path: <linux-kernel-owner+w=401wt.eu-S938446AbXHMKlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938446AbXHMKlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967324AbXHMGgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:17 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1837 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967261AbXHMGgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:08 -0400
Date: Sun, 12 Aug 2007 23:35:53 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, penberg@cs.helsinki.fi, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, clameter@sgi.com,
       akpm@linux-foundation.org
Subject: [PATCH] [438/2many] MAINTAINERS - SLAB ALLOCATOR
Message-ID: <46bffbc9.9Jtz7kOTKn1mqlkq%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b2dd6f5..a3c6123 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4168,6 +4168,8 @@ P:	Pekka Enberg
 M:	penberg@cs.helsinki.fi
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	include/linux/slab*
+F:	mm/slab.c
 
 SMC91x ETHERNET DRIVER
 P:	Nicolas Pitre
