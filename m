Return-Path: <linux-kernel-owner+w=401wt.eu-S939507AbXHMJG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939507AbXHMJG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966875AbXHMGbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:25 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4960 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966933AbXHMGbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:21 -0400
Date: Sun, 12 Aug 2007 23:31:07 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       akpm@linux-foundation.org
Subject: [PATCH] [290/2many] MAINTAINERS - LINUX FOR POWER MACINTOSH
Message-ID: <46bffaab.+AAMCKKz1NEHjs/c%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 1d1da70..8282088 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2784,6 +2784,8 @@ M:	benh@kernel.crashing.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
 S:	Maintained
+F:	arch/powerpc/platforms/powermac
+F:	include/asm-powerpc/pmac_*
 
 LINUX FOR POWERPC EMBEDDED MPC52XX
 P:	Sylvain Munaut
