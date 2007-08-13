Return-Path: <linux-kernel-owner+w=401wt.eu-S942078AbXHMKvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942078AbXHMKvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967298AbXHMGgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:44 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1702 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967249AbXHMGfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:22 -0400
Date: Sun, 12 Aug 2007 23:35:09 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, michael@mihu.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [415/2many] MAINTAINERS - SAA7146 VIDEO4LINUX-2 DRIVER
Message-ID: <46bffb9d.B1xtUi7MXBBoHbCH%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 02a59dc..20b6f25 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3956,6 +3956,9 @@ P:	Michael Hunold
 M:	michael@mihu.de
 W:	http://www.mihu.de/linux/saa7146
 S:	Maintained
+F:	drivers/media/common/saa7146*
+F:	drivers/media/video/*7146*
+F:	include/media/*7146*
 
 SC1200 WDT DRIVER
 P:	Zwane Mwaikambo
