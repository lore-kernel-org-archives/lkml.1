Return-Path: <linux-kernel-owner+w=401wt.eu-S935542AbXHMKjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935542AbXHMKjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966928AbXHMGgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:12 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1824 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965881AbXHMGgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:04 -0400
Date: Sun, 12 Aug 2007 23:35:49 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, thomas@winischhofer.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [436/2many] MAINTAINERS - SIS FRAMEBUFFER DRIVER
Message-ID: <46bffbc5.fKvGJ1xX/9bPMTzh%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 761029d..08d0b06 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4150,6 +4150,9 @@ P:	Thomas Winischhofer
 M:	thomas@winischhofer.net
 W:	http://www.winischhofer.net/linuxsisvga.shtml
 S:	Maintained
+F:	Documentation/fb/sisfb.txt
+F:	drivers/video/sis/
+F:	include/video/sisfb.h
 
 SIS USB2VGA DRIVER
 P:	Thomas Winischhofer
