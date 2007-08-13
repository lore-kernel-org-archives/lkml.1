Return-Path: <linux-kernel-owner+w=401wt.eu-S938401AbXHMK1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938401AbXHMK1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967277AbXHMGfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:33 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1696 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967216AbXHMGfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:20 -0400
Date: Sun, 12 Aug 2007 23:35:00 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, flamingice@sourmilk.net,
       andreamrl@tiscali.it, akpm@linux-foundation.org
Subject: [PATCH] [410/2many] MAINTAINERS - RTL818X WIRELESS DRIVER
Message-ID: <46bffb94.2CBFGZIXkk4N62oJ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 5bc5769..c1596d6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3911,6 +3911,7 @@ L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
 S:	Maintained
+F:	drivers/net/wireless/rtl818*
 
 S3 SAVAGE FRAMEBUFFER DRIVER
 P:	Antonino Daplas
