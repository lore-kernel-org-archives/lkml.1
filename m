Return-Path: <linux-kernel-owner+w=401wt.eu-S1764822AbXHMHch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764822AbXHMHch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966237AbXHMGZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:25:57 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4053 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966144AbXHMGZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:49 -0400
Date: Sun, 12 Aug 2007 23:25:36 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, r.marek@assembler.cz,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [134/2many] MAINTAINERS - CORETEMP HARDWARE MONITORING
 DRIVER
Message-ID: <46bff960.WIP0LRYr3U/rYI1a%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d0a436a..a51b89e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1294,6 +1294,7 @@ P:	Rudolf Marek
 M:	r.marek@assembler.cz
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	drivers/hwmon/coretemp.c
 
 COSA/SRP SYNC SERIAL DRIVER
 P:	Jan "Yenya" Kasprzak
