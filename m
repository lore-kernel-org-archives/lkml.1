Return-Path: <linux-kernel-owner+w=401wt.eu-S971061AbXHMJFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971061AbXHMJFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966602AbXHMGbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:24 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4945 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966928AbXHMGbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:17 -0400
Date: Sun, 12 Aug 2007 23:31:03 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Subject: [PATCH] [288/2many] MAINTAINERS - LINUX FOR NCR VOYAGER
Message-ID: <46bffaa7.9ahuoTZtN1Yl0OMV%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f833a74..c643ebe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2762,6 +2762,11 @@ P:	James Bottomley
 M:	James.Bottomley@HansenPartnership.com
 W:	http://www.hansenpartnership.com/voyager
 S:	Maintained
+F:	Documentation/voyager.txt
+F:	arch/i386/boot/voyager.c
+F:	arch/i386/mach-voyager/
+F:	include/asm-i386/mach-voyager/
+F:	include/asm-i386/voyager.h
 
 LINUX FOR POWERPC
 P:	Paul Mackerras
