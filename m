Return-Path: <linux-kernel-owner+w=401wt.eu-S941744AbXHMHhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941744AbXHMHhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965876AbXHMG0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:14 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4113 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966258AbXHMG0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:07 -0400
Date: Sun, 12 Aug 2007 23:25:52 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Knut_Petersen@t-online.de
Subject: [PATCH] [142/2many] MAINTAINERS - CYBLAFB FRAMEBUFFER DRIVER
Message-ID: <46bff970.4ojjGbkTVi9aDwkX%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index aee6296..062e662 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1372,6 +1372,7 @@ P:	Knut Petersen
 M:	Knut_Petersen@t-online.de
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	drivers/video/cyblafb.c
 
 CYCLADES 2X SYNC CARD DRIVER
 P:	Arnaldo Carvalho de Melo
