Return-Path: <linux-kernel-owner+w=401wt.eu-S941286AbXHMJHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941286AbXHMJHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966934AbXHMGb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:27 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4966 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965028AbXHMGbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:25 -0400
Date: Sun, 12 Aug 2007 23:31:11 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mporter@kernel.crashing.org,
       linuxppc-embedded@ozlabs.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [292/2many] MAINTAINERS - LINUX FOR POWERPC EMBEDDED
 PPC4XX
Message-ID: <46bffaaf.2ObqORfh5YL/9ILj%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0862965..38810b7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2804,6 +2804,8 @@ M:	mporter@kernel.crashing.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-embedded@ozlabs.org
 S:	Maintained
+F:	arch/ppc/syslib/ppc4xx_*
+F:	include/asm-ppc/ppc4xx_*
 
 LINUX FOR POWERPC BOOT CODE
 P:	Tom Rini
