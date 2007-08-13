Return-Path: <linux-kernel-owner+w=401wt.eu-S969139AbXHMIgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969139AbXHMIgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966765AbXHMG3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:29:48 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4695 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966678AbXHMG3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:47 -0400
Date: Sun, 12 Aug 2007 23:29:31 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       lethal@chaoticdreams.org, akpm@linux-foundation.org
Subject: [PATCH] [246/2many] MAINTAINERS - IMS TWINTURBO FRAMEBUFFER
 DRIVER
Message-ID: <46bffa4b.q+9UlAQLDOAakatO%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 7889eb8..afc7780 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2328,6 +2328,7 @@ P:	Paul Mundt
 M:	lethal@chaoticdreams.org
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	drivers/video/imsttfb.c
 
 INFINIBAND SUBSYSTEM
 P:	Roland Dreier
