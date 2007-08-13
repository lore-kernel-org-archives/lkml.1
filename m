Return-Path: <linux-kernel-owner+w=401wt.eu-S965822AbXHMGXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965822AbXHMGXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936536AbXHMGVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:21:50 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3377 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935796AbXHMGVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:21:45 -0400
Date: Sun, 12 Aug 2007 23:21:33 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, dave@thedillows.org,
       akpm@linux-foundation.org
Subject: [PATCH] [5/2many] MAINTAINERS - 3CR990 NETWORK DRIVER
Message-ID: <46bff86d.3nPB+/nZUm72NBI6%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3fbc13a..30f8ef5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -110,6 +110,7 @@ P:	David Dillow
 M:	dave@thedillows.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/typhoon*
 
 3W-XXXX ATA-RAID CONTROLLER DRIVER
 P:	Adam Radford
