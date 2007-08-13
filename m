Return-Path: <linux-kernel-owner+w=401wt.eu-S941946AbXHMH3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941946AbXHMH3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966190AbXHMGZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:25:47 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4023 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966223AbXHMGZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:39 -0400
Date: Sun, 12 Aug 2007 23:25:21 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel@wantstofly.org,
       akpm@linux-foundation.org
Subject: [PATCH] [126/2many] MAINTAINERS - CIRRUS LOGIC EP93XX OHCI USB
 HOST DRIVER
Message-ID: <46bff951.54Sz/B/2E7PT2LJU%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 8b28143..7f16b33 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1229,6 +1229,7 @@ P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/usb/host/ohci-ep93xx.c
 
 CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER
 P:	Cirrus Logic Corporation (kernel 2.2 driver)
