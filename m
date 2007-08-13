Return-Path: <linux-kernel-owner+w=401wt.eu-S939887AbXHMKmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939887AbXHMKmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965980AbXHMGgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:20 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1854 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967207AbXHMGgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:14 -0400
Date: Sun, 12 Aug 2007 23:36:01 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, neilb@suse.de, mingo@redhat.com,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [442/2many] MAINTAINERS - SOFTWARE RAID (Multiple Disks)
 SUPPORT
Message-ID: <46bffbd1.6OOR1+/x0yRKyfpY%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d17ae3d..29a2179 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4205,6 +4205,8 @@ P:	Neil Brown
 M:	neilb@suse.de
 L:	linux-raid@vger.kernel.org
 S:	Supported
+F:	drivers/md/
+F:	include/linux/raid/
 
 HIBERNATION (aka Software Suspend, aka swsusp):
 P:	Pavel Machek
