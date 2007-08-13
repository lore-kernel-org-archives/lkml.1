Return-Path: <linux-kernel-owner+w=401wt.eu-S968229AbXHMH5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968229AbXHMH5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966500AbXHMG10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:27:26 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4333 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966485AbXHMG1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:23 -0400
Date: Sun, 12 Aug 2007 23:27:03 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       egor@pasemi.com, bluesmoke-devel@lists.sourceforge.net,
       akpm@linux-foundation.org
Subject: [PATCH] [177/2many] MAINTAINERS - EDAC-PASEMI
Message-ID: <46bff9b7.YOpxeQjK7ftqm673%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 569f89f..08e62f1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1723,6 +1723,7 @@ M:	egor@pasemi.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/pasemi_edac.c
 
 EDAC-R82600
 P:	Tim Small
