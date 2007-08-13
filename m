Return-Path: <linux-kernel-owner+w=401wt.eu-S934523AbXHMHxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934523AbXHMHxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966468AbXHMG1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:27:17 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4301 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966462AbXHMG1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:15 -0400
Date: Sun, 12 Aug 2007 23:26:56 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, tim@buttersideup.com,
       linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net,
       akpm@linux-foundation.org
Subject: [PATCH] [173/2many] MAINTAINERS - EDAC-I82443BXGX
Message-ID: <46bff9b0.9D/6y4yqs/baIclk%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 678cca3..f1dfcd2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1689,6 +1689,7 @@ M:	tim@buttersideup.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/i82443bxgx_edac.c
 
 EDAC-I3000
 P:	Jason Uhlenkott
