Return-Path: <linux-kernel-owner+w=401wt.eu-S964903AbXHMHX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964903AbXHMHX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938989AbXHMGZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:25:23 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3969 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965974AbXHMGZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:18 -0400
Date: Sun, 12 Aug 2007 23:24:53 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       fubar@us.ibm.com, ctindel@users.sourceforge.net,
       bonding-devel@lists.sourceforge.net, akpm@linux-foundation.org
Subject: [PATCH] [111/2many] MAINTAINERS - BONDING DRIVER
Message-ID: <46bff935.qa3GpQ519F+Oumol%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3d198df..a21ccf1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1082,6 +1082,8 @@ M:	fubar@us.ibm.com
 L:	bonding-devel@lists.sourceforge.net
 W:	http://sourceforge.net/projects/bonding/
 S:	Supported
+F:	drivers/net/bonding/
+F:	include/linux/if_bonding.h
 
 BROADBAND PROCESSOR ARCHITECTURE
 P:	Arnd Bergmann
