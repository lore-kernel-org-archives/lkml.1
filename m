Return-Path: <linux-kernel-owner+w=401wt.eu-S1761876AbXHMKpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761876AbXHMKpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967301AbXHMGgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:23 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1712 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967236AbXHMGf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:26 -0400
Date: Sun, 12 Aug 2007 23:35:13 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, rml@tech9.net, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [417/2many] MAINTAINERS - SCHEDULER
Message-ID: <46bffba1.B+0kfTaqietfqTdo%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e7524a0..c08c8af 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3973,6 +3973,7 @@ P:	Robert Love    [the preemptible kernel bits]
 M:	rml@tech9.net
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	kernel/sched*
 
 SCSI CDROM DRIVER
 P:	Jens Axboe
