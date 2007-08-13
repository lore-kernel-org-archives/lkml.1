Return-Path: <linux-kernel-owner+w=401wt.eu-S944349AbXHMLRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944349AbXHMLRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966246AbXHMGiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:07 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2102 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937284AbXHMGhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:42 -0400
Date: Sun, 12 Aug 2007 23:37:30 -0700
From: joe@perches.com
To: tulip-users@lists.sourceforge.net, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [483/2many] MAINTAINERS - TULIP NETWORK DRIVER
Message-ID: <46bffc2a.ruErqJOsVbJkM+7r%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 473d852..b8806b8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4586,6 +4586,7 @@ TULIP NETWORK DRIVER
 L:	tulip-users@lists.sourceforge.net
 W:	http://sourceforge.net/projects/tulip/
 S:	Orphan
+F:	drivers/net/tulip/
 
 TUN/TAP driver
 P:	Maxim Krasnyansky
