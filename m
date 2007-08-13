Return-Path: <linux-kernel-owner+w=401wt.eu-S943475AbXHMMIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943475AbXHMMIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967537AbXHMGka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:40:30 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2495 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967423AbXHMGkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:40:12 -0400
Date: Sun, 12 Aug 2007 23:39:22 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       gerg@uclinux.org, akpm@linux-foundation.org
Subject: [PATCH] [531/2many] MAINTAINERS - UCLINUX (AND M68KNOMMU)
Message-ID: <46bffc9a.N6KOopoLanD1PsL/%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index be3d826..671bb8d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5010,6 +5010,8 @@ M:	gerg@uclinux.org
 W:	http://www.uclinux.org/
 L:	uclinux-dev@uclinux.org  (subscribers-only)
 S:	Maintained
+F:	arch/m68knommu/
+F:	include/asm-m68knommu/
 
 UCLINUX FOR NEC V850
 P:	Miles Bader
