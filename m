Return-Path: <linux-kernel-owner+w=401wt.eu-S965702AbXHMLMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965702AbXHMLMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939090AbXHMGh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:37:56 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2075 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966714AbXHMGhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:33 -0400
Date: Sun, 12 Aug 2007 23:37:19 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, netdev@vger.kernel.org, mikep@linuxtr.net,
       linux-tr@linuxtr.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [478/2many] MAINTAINERS - TOKEN-RING NETWORK DRIVER
Message-ID: <46bffc1f.jeLQtdRi39eTOfu9%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index fda287c..b5dc1ac 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4539,6 +4539,8 @@ L:	netdev@vger.kernel.org
 L:	linux-tr@linuxtr.net
 W:	http://www.linuxtr.net
 S:	Maintained
+F:	drivers/net/tokenring/
+F:	net/802/tr.c
 
 TOSHIBA ACPI EXTRAS DRIVER
 P:	John Belmonte
