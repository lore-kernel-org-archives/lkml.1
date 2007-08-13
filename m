Return-Path: <linux-kernel-owner+w=401wt.eu-S968450AbXHMH5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968450AbXHMH5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966485AbXHMG11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:27:27 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4332 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966372AbXHMG1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:23 -0400
Date: Sun, 12 Aug 2007 23:27:05 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, tim@buttersideup.com,
       linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net,
       akpm@linux-foundation.org
Subject: [PATCH] [178/2many] MAINTAINERS - EDAC-R82600
Message-ID: <46bff9b9.HAJkCMlvUhEYWH8+%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 08e62f1..84f6f6b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1731,6 +1731,7 @@ M:	tim@buttersideup.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/r82600_edac.c
 
 EEPRO100 NETWORK DRIVER
 P:	Andrey V. Savochkin
