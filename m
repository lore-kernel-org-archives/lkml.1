Return-Path: <linux-kernel-owner+w=401wt.eu-S969247AbXHMIY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969247AbXHMIY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966659AbXHMG3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:29:06 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4576 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966752AbXHMG3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:03 -0400
Date: Sun, 12 Aug 2007 23:28:48 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, perex@suse.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [224/2many] MAINTAINERS - HP100:	Driver for HP 10/100
 Mbit/s Voice Grade Network Adapter Series
Message-ID: <46bffa20.TXBpE43gYknY6uD2%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3efcecf..cb82b56 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2144,6 +2144,7 @@ HP100:	Driver for HP 10/100 Mbit/s Voice Grade Network Adapter Series
 P:	Jaroslav Kysela
 M:	perex@suse.cz
 S:	Maintained
+F:	drivers/net/hp100.*
 
 HPET:	High Precision Event Timers driver (hpet.c)
 P:	Clemens Ladisch
