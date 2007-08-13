Return-Path: <linux-kernel-owner+w=401wt.eu-S940980AbXHMKsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940980AbXHMKsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967302AbXHMGgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:25 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1860 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967325AbXHMGgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:16 -0400
Date: Sun, 12 Aug 2007 23:36:03 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, rjw@sisk.pl, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [443/2many] MAINTAINERS - HIBERNATION (aka Software
 Suspend, aka swsusp):
Message-ID: <46bffbd3.IqsNHrHU1Y9BF7Dd%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 29a2179..5ae90a2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4215,6 +4215,9 @@ P:	Rafael J. Wysocki
 M:	rjw@sisk.pl
 L:	linux-pm@lists.linux-foundation.org
 S:	Supported
+F:	Documentation/power/swsusp*
+F:	arch/i386/power/swsusp.S
+F:	kernel/power/
 
 SUSPEND TO RAM:
 P:	Pavel Machek
