Return-Path: <linux-kernel-owner+w=401wt.eu-S942781AbXHMIRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942781AbXHMIRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966384AbXHMG2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:40 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4514 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966526AbXHMG2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:39 -0400
Date: Sun, 12 Aug 2007 23:28:18 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, tilman@imap.cc,
       linux-kernel@vger.kernel.org, hjlipp@web.de,
       gigaset307x-common@lists.sourceforge.net, akpm@linux-foundation.org
Subject: [PATCH] [209/2many] MAINTAINERS - GIGASET ISDN DRIVERS
Message-ID: <46bffa02.0UYAucbdMKEB13Zy%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b4183e7..e35e29c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2004,6 +2004,9 @@ M:	tilman@imap.cc
 L:	gigaset307x-common@lists.sourceforge.net
 W:	http://gigaset307x.sourceforge.net/
 S:	Maintained
+F:	Documentation/isdn/README.gigaset
+F:	drivers/isdn/gigaset/
+F:	include/linux/gigaset_dev.h
 
 HARDWARE MONITORING
 P:	Mark M. Hoffman
