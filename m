Return-Path: <linux-kernel-owner+w=401wt.eu-S941342AbXHMIjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941342AbXHMIjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966516AbXHMG3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:29:55 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4714 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966840AbXHMG3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:53 -0400
Date: Sun, 12 Aug 2007 23:29:39 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, adaplas@gmail.com
Subject: [PATCH] [250/2many] MAINTAINERS - INTEL 810/815 FRAMEBUFFER
 DRIVER
Message-ID: <46bffa53.XSXQKJKDticFOiSe%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 85dbec2..34d406e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2377,6 +2377,7 @@ P:	Antonino Daplas
 M:	adaplas@gmail.com
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	drivers/video/i810/
 
 INTEL APIC/IOAPIC, LOWLEVEL X86 SMP SUPPORT
 P:	Ingo Molnar
