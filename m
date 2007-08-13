Return-Path: <linux-kernel-owner+w=401wt.eu-S966251AbXHMGae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966251AbXHMGae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965686AbXHMGWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:22:40 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3498 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965643AbXHMGWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:38 -0400
Date: Sun, 12 Aug 2007 23:21:55 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, j.w.r.degoede@hhs.nl,
       akpm@linux-foundation.org
Subject: [PATCH] [17/2many] MAINTAINERS - ABIT UGURU HARDWARE MONITOR
 DRIVER
Message-ID: <46bff883.o9E4xFtxERfeWZpB%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 2de2083..909875d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -209,6 +209,7 @@ P:	Hans de Goede
 M:	j.w.r.degoede@hhs.nl
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	drivers/hwmon/abitguru*
 
 ACENIC DRIVER
 P:	Jes Sorensen
