Return-Path: <linux-kernel-owner+w=401wt.eu-S939599AbXHMKnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939599AbXHMKnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967326AbXHMGgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:18 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1842 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967316AbXHMGgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:10 -0400
Date: Sun, 12 Aug 2007 23:35:57 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mhoffman@lightlink.com,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [440/2many] MAINTAINERS - SMSC47B397 HARDWARE MONITOR
 DRIVER
Message-ID: <46bffbcd.ByWqlMNDQcr1aAxq%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 140eb07..2bda79d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4182,6 +4182,8 @@ P:	Mark M. Hoffman
 M:	mhoffman@lightlink.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/smsc47b397
+F:	drivers/hwmon/smsc47b397.c
 
 SOFTMAC LAYER (IEEE 802.11)
 P:	Johannes Berg
