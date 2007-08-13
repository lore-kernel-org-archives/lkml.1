Return-Path: <linux-kernel-owner+w=401wt.eu-S969683AbXHMIcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969683AbXHMIcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966814AbXHMG3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:29:34 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4656 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966803AbXHMG3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:32 -0400
Date: Sun, 12 Aug 2007 23:28:47 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, j@w1.fi, akpm@linux-foundation.org
Subject: [PATCH] [223/2many] MAINTAINERS - HOST AP DRIVER
Message-ID: <46bffa1f.AhWwxXaebSiVEtFu%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 76bacfd..3efcecf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2138,6 +2138,7 @@ L:	hostap@shmoo.com (subscribers-only)
 L:	linux-wireless@vger.kernel.org
 W:	http://hostap.epitest.fi/
 S:	Maintained
+F:	drivers/net/wireless/hostap/
 
 HP100:	Driver for HP 10/100 Mbit/s Voice Grade Network Adapter Series
 P:	Jaroslav Kysela
