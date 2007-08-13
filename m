Return-Path: <linux-kernel-owner+w=401wt.eu-S1761141AbXHMJ5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761141AbXHMJ5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967144AbXHMGd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:57 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1401 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967131AbXHMGdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:40 -0400
Date: Sun, 12 Aug 2007 23:33:27 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, tim@cyberelk.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [363/2many] MAINTAINERS - PARIDE DRIVERS FOR PARALLEL
 PORT IDE DEVICES
Message-ID: <46bffb37.uJKVC62Ju0tBtIp3%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 21a427e..0134f18 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3489,6 +3489,8 @@ M:	tim@cyberelk.net
 L:	linux-parport@lists.infradead.org (subscribers-only)
 W:	http://www.torque.net/linux-pp.html
 S:	Maintained
+F:	Documentation/paride.txt
+F:	drivers/block/paride/
 
 PARISC ARCHITECTURE
 P:	Matthew Wilcox
