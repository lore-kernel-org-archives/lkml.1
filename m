Return-Path: <linux-kernel-owner+w=401wt.eu-S936297AbXHMKS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936297AbXHMKS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967224AbXHMGfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:04 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1618 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967212AbXHMGex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:53 -0400
Date: Sun, 12 Aug 2007 23:34:39 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, paulus@samba.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [399/2many] MAINTAINERS - RAGE128 FRAMEBUFFER DISPLAY
 DRIVER
Message-ID: <46bffb7f.MBC+BLOxcxJusFcu%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 5d45c74..da61adc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3815,6 +3815,7 @@ P:	Paul Mackerras
 M:	paulus@samba.org
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	drivers/video/aty/aty*
 
 RAYLINK/WEBGEAR 802.11 WIRELESS LAN DRIVER
 P:	Corey Thomas
