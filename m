Return-Path: <linux-kernel-owner+w=401wt.eu-S967706AbXHMGmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967706AbXHMGmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965090AbXHMGXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:00 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3528 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965732AbXHMGWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:44 -0400
Date: Sun, 12 Aug 2007 23:21:57 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-acenic@sunsite.dk, jes@trained-monkey.org,
       akpm@linux-foundation.org
Subject: [PATCH] [18/2many] MAINTAINERS - ACENIC DRIVER
Message-ID: <46bff885.mB2LD2Mu8yjtR8xr%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 909875d..141b08a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -216,6 +216,7 @@ P:	Jes Sorensen
 M:	jes@trained-monkey.org
 L:	linux-acenic@sunsite.dk
 S:	Maintained
+F:	drivers/net/acenic*
 
 IPS SCSI RAID DRIVER
 P:	Adaptec OEM Raid Solutions
