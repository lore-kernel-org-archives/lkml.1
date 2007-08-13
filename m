Return-Path: <linux-kernel-owner+w=401wt.eu-S942924AbXHMKzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942924AbXHMKzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967225AbXHMGfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:18 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1624 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967216AbXHMGe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:56 -0400
Date: Sun, 12 Aug 2007 23:34:41 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, corey@world.std.com,
       akpm@linux-foundation.org
Subject: [PATCH] [400/2many] MAINTAINERS - RAYLINK/WEBGEAR 802.11 WIRELESS LAN DRIVER
Message-ID: <46bffb81.3Y36j03eTK6yltNK%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index da61adc..e62a648 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3822,6 +3822,7 @@ P:	Corey Thomas
 M:	corey@world.std.com
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
+F:	drivers/net/wireless/ray*
 
 RANDOM NUMBER DRIVER
 P:	Matt Mackall
