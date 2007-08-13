Return-Path: <linux-kernel-owner+w=401wt.eu-S971303AbXHMJOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971303AbXHMJOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966996AbXHMGbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:52 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1069 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966994AbXHMGbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:50 -0400
Date: Sun, 12 Aug 2007 23:31:26 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, khali@linux-fr.org,
       akpm@linux-foundation.org
Subject: [PATCH] [300/2many] MAINTAINERS - LM90 HARDWARE MONITOR DRIVER
Message-ID: <46bffabe.ezGWPX+Et/7FTcVC%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 9a65d56..be709c1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2882,6 +2882,8 @@ P:	Jean Delvare
 M:	khali@linux-fr.org
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/lm90
+F:	drivers/hwmon/lm90.c
 
 LOGICAL DISK MANAGER SUPPORT (LDM, Windows 2000/XP/Vista Dynamic Disks)
 P:	Richard Russon (FlatCap)
