Return-Path: <linux-kernel-owner+w=401wt.eu-S940235AbXHMHI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940235AbXHMHI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966016AbXHMGYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:33 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3814 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965848AbXHMGY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:27 -0400
Date: Sun, 12 Aug 2007 23:24:13 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, t.sailer@alumni.ethz.ch,
       linux-kernel@vger.kernel.org, linux-hams@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [90/2many] MAINTAINERS - BAYCOM/HDLCDRV DRIVERS FOR AX.25
Message-ID: <46bff90d.plfo6g1GxV70T8ko%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 589e469..90689a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -920,6 +920,7 @@ M:	t.sailer@alumni.ethz.ch
 L:	linux-hams@vger.kernel.org
 W:	http://www.baycom.org/~tom/ham/ham.html
 S:	Maintained
+F:	drivers/net/hamradio/baycom*
 
 BCM43XX WIRELESS DRIVER (SOFTMAC BASED VERSION)
 P:	Larry Finger
