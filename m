Return-Path: <linux-kernel-owner+w=401wt.eu-S939237AbXHMGiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939237AbXHMGiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965570AbXHMGWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:22:52 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3530 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965749AbXHMGWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:46 -0400
Date: Sun, 12 Aug 2007 23:22:18 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, khali@linux-fr.org,
       akpm@linux-foundation.org
Subject: [PATCH] [29/2many] MAINTAINERS - ADM1025 HARDWARE MONITOR DRIVER
Message-ID: <46bff89a.xYL7oyBOdTr8eyH/%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 4faf1ce..91bc5cd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -307,6 +307,7 @@ P:	Jean Delvare
 M:	khali@linux-fr.org
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	drivers/hwmon/adm1025.c
 
 ADM1029 HARDWARE MONITOR DRIVER
 P:	Corentin Labbe
