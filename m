Return-Path: <linux-kernel-owner+w=401wt.eu-S969161AbXHMIXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969161AbXHMIXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966563AbXHMG27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:59 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4566 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966599AbXHMG26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:58 -0400
Date: Sun, 12 Aug 2007 23:28:33 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-nvidia@lists.surfsouth.com,
       linux-kernel@vger.kernel.org, fero@drama.obuda.kando.hu,
       akpm@linux-foundation.org
Subject: [PATCH] [216/2many] MAINTAINERS - HGA FRAMEBUFFER DRIVER
Message-ID: <46bffa11.PDitL0kohwTckB4J%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 48d6b69..bdbf999 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2063,6 +2063,7 @@ M:	fero@drama.obuda.kando.hu
 L:	linux-nvidia@lists.surfsouth.com
 W:	http://drama.obuda.kando.hu/~fero/cgi-bin/hgafb.shtml
 S:	Maintained
+F:	drivers/video/hgafb.c
 
 HID CORE LAYER
 P:	Jiri Kosina
