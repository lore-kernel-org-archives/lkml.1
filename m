Return-Path: <linux-kernel-owner+w=401wt.eu-S943334AbXHMJXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943334AbXHMJXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966183AbXHMGb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:59 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1088 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967001AbXHMGb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:56 -0400
Date: Sun, 12 Aug 2007 23:31:40 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kaber@trash.net,
       akpm@linux-foundation.org
Subject: [PATCH] [308/2many] MAINTAINERS - MACVLAN DRIVER
Message-ID: <46bffacc.oLbMW/xdn72uEebz%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 07fb80f..b4d6651 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2966,6 +2966,8 @@ P:	Patrick McHardy
 M:	kaber@trash.net
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/macvlan.c
+F:	include/linux/if_macvlan.h
 
 MARVELL YUKON / SYSKONNECT DRIVER
 P:	Mirko Lindner
