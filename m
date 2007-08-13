Return-Path: <linux-kernel-owner+w=401wt.eu-S968686AbXHMH75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968686AbXHMH75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966498AbXHMG1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:27:33 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4355 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966373AbXHMG13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:29 -0400
Date: Sun, 12 Aug 2007 23:27:16 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, philb@gnu.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [184/2many] MAINTAINERS - ETHEREXPRESS-16 NETWORK DRIVER
Message-ID: <46bff9c4.pMPQodovpWqf//FD%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 6fe987d..27eb5be 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1774,6 +1774,7 @@ P:	Philip Blundell
 M:	philb@gnu.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/eexpress.*
 
 ETHERNET BRIDGE
 P:	Stephen Hemminger
