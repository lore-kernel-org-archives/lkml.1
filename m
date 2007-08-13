Return-Path: <linux-kernel-owner+w=401wt.eu-S941013AbXHMHpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941013AbXHMHpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965682AbXHMG0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:42 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4199 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966352AbXHMG0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:41 -0400
Date: Sun, 12 Aug 2007 23:26:27 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, juergh@gmail.com,
       akpm@linux-foundation.org
Subject: [PATCH] [159/2many] MAINTAINERS - DME1737 HARDWARE MONITOR DRIVER
Message-ID: <46bff993.7OEwF3qQrioxyBDU%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 70e5070..2fafb83 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1553,6 +1553,7 @@ P:	Juerg Haefliger
 M:	juergh@gmail.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	drivers/hwmon/dme1737.c
 
 DOCBOOK FOR DOCUMENTATION
 P:	Randy Dunlap
