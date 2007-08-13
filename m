Return-Path: <linux-kernel-owner+w=401wt.eu-S970127AbXHMIiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970127AbXHMIiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966843AbXHMG3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:29:53 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4712 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966833AbXHMG3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:51 -0400
Date: Sun, 12 Aug 2007 23:29:38 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, sylvain.meyer@worldonline.fr,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [249/2many] MAINTAINERS - INTEL FRAMEBUFFER DRIVER
 (excluding 810 and 815)
Message-ID: <46bffa52.XCWGxsrarfXII06h%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 9608731..85dbec2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2369,6 +2369,8 @@ P:	Sylvain Meyer
 M:	sylvain.meyer@worldonline.fr
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	Documentation/fb/intelfb.txt
+F:	drivers/video/intelfb/
 
 INTEL 810/815 FRAMEBUFFER DRIVER
 P:	Antonino Daplas
