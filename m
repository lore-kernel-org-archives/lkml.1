Return-Path: <linux-kernel-owner+w=401wt.eu-S1761706AbZDHFWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761706AbZDHFWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759817AbZDHFU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:20:28 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4367 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759813AbZDHFUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:20:21 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] MAINTAINERS - Remove cyblafb frame buffer no longer in tree
Date: Tue,  7 Apr 2009 22:17:52 -0700
Message-Id: <1239167872-8179-11-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1239167872-8179-1-git-send-email-joe@perches.com>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 702a98e..d6979e6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1582,12 +1582,6 @@ W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	drivers/video/cyber2000fb.*
 
-CYBLAFB FRAMEBUFFER DRIVER
-P:	Knut Petersen
-M:	Knut_Petersen@t-online.de
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
-S:	Maintained
-
 CYCLADES 2X SYNC CARD DRIVER
 P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net
-- 
1.6.0.2

