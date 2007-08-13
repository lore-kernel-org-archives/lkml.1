Return-Path: <linux-kernel-owner+w=401wt.eu-S971044AbXHMJjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971044AbXHMJjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966723AbXHMGc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:58 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1256 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967058AbXHMGcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:55 -0400
Date: Sun, 12 Aug 2007 23:32:39 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       akpm@linux-foundation.org
Subject: [PATCH] [338/2many] MAINTAINERS - NETWORK DEVICE DRIVERS
Message-ID: <46bffb07.hBQUdSyYubZ66f1I%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d9e9813..b67dda3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3243,6 +3243,7 @@ M:	jgarzik@pobox.com
 L:	netdev@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
 S:	Maintained
+F:	drivers/net/
 
 NETWORKING [GENERAL]
 P:	Networking Team
