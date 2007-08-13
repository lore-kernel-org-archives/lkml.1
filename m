Return-Path: <linux-kernel-owner+w=401wt.eu-S940590AbXHMHZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940590AbXHMHZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965954AbXHMGZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:25:18 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3949 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966058AbXHMGZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:12 -0400
Date: Sun, 12 Aug 2007 23:24:58 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, netdev@vger.kernel.org, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [114/2many] MAINTAINERS - BROADCOM TG3 GIGABIT ETHERNET
 DRIVER
Message-ID: <46bff93a.pQTTtI4jcY9K0iRl%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 976e6d0..0ee8069 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1111,6 +1111,7 @@ P:	Michael Chan
 M:	mchan@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	drivers/net/tg3.*
 
 BSG (block layer generic sg v4 driver)
 P:	FUJITA Tomonori
