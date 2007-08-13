Return-Path: <linux-kernel-owner+w=401wt.eu-S1760483AbXHMIOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760483AbXHMIOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966352AbXHMG2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:34 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4498 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966659AbXHMG2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:33 -0400
Date: Sun, 12 Aug 2007 23:28:20 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mhoffman@lightlink.com,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [210/2many] MAINTAINERS - HARDWARE MONITORING
Message-ID: <46bffa04.JW3S0ykNGAQACMv1%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e35e29c..f422277 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2015,6 +2015,7 @@ L:	lm-sensors@lm-sensors.org
 W:	http://www.lm-sensors.org/
 T:	git lm-sensors.org:/kernel/mhoffman/hwmon-2.6.git
 S:	Maintained
+F:	drivers/hwmon/
 
 HARDWARE RANDOM NUMBER GENERATOR CORE
 P:	Michael Buesch
