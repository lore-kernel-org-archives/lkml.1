Return-Path: <linux-kernel-owner+w=401wt.eu-S944959AbXHMLzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944959AbXHMLzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967473AbXHMGjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:46 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2407 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967469AbXHMGjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:44 -0400
Date: Sun, 12 Aug 2007 23:39:30 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, juergh@gmail.com,
       akpm@linux-foundation.org
Subject: [PATCH] [535/2many] MAINTAINERS - VT1211 HARDWARE MONITOR DRIVER
Message-ID: <46bffca2.MZVCmUtcDSpkWn9z%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 25bc39a..52b7742 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5056,6 +5056,8 @@ P:	Juerg Haefliger
 M:	juergh@gmail.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/vt1211
+F:	drivers/hwmon/vt1211.c
 
 VT8231 HARDWARE MONITOR DRIVER
 P:	Roger Lucas
