Return-Path: <linux-kernel-owner+w=401wt.eu-S971524AbXHMJRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971524AbXHMJRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967008AbXHMGcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:04 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1089 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966999AbXHMGb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:56 -0400
Date: Sun, 12 Aug 2007 23:31:43 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, rroesler@syskonnect.de,
       mlindner@syskonnect.de, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [309/2many] MAINTAINERS - MARVELL YUKON / SYSKONNECT
 DRIVER
Message-ID: <46bffacf.D+ikNVslWOyJFTr8%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b4d6651..68b22f3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2971,11 +2971,11 @@ F:	include/linux/if_macvlan.h
 
 MARVELL YUKON / SYSKONNECT DRIVER
 P:	Mirko Lindner
-M: 	mlindner@syskonnect.de
+M:	mlindner@syskonnect.de
 P:	Ralph Roesler
-M: 	rroesler@syskonnect.de
-W: 	http://www.syskonnect.com
-S: 	Supported
+M:	rroesler@syskonnect.de
+W:	http://www.syskonnect.com
+S:	Supported
 
 MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2, 3, 4, 5, and 7
 P:	Michael Kerrisk
