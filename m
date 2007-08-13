Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbXHMKC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbXHMKC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967173AbXHMGeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:11 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1480 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967075AbXHMGeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:01 -0400
Date: Sun, 12 Aug 2007 23:33:48 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, pcnet32@verizon.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [374/2many] MAINTAINERS - PCNET32 NETWORK DRIVER
Message-ID: <46bffb4c.nrqicrPs7IJXlgQ0%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f6b84d2..7f5b7c2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3599,6 +3599,7 @@ P:	Don Fry
 M:	pcnet32@verizon.net
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/pcnet32.c
 
 PER-TASK DELAY ACCOUNTING
 P:	Shailabh Nagar
