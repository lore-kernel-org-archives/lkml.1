Return-Path: <linux-kernel-owner+w=401wt.eu-S939526AbXHMK7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939526AbXHMK7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967197AbXHMGhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:37:12 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1982 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967314AbXHMGhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:01 -0400
Date: Sun, 12 Aug 2007 23:35:59 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, josejx@gentoo.org,
       johannes@sipsolutions.net, dsd@gentoo.org, akpm@linux-foundation.org
Subject: [PATCH] [441/2many] MAINTAINERS - SOFTMAC LAYER (IEEE 802.11)
Message-ID: <46bffbcf.xlboi9FGEwHN78S0%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 2bda79d..d17ae3d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4195,6 +4195,8 @@ M:	dsd@gentoo.org
 W:	http://softmac.sipsolutions.net/
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
+F:	include/net/ieee80211softmac*
+F:	net/ieee80211/softmac/
 
 SOFTWARE RAID (Multiple Disks) SUPPORT
 P:	Ingo Molnar
