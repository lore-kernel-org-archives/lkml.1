Return-Path: <linux-kernel-owner+w=401wt.eu-S1761797AbXHMKYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761797AbXHMKYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967257AbXHMGf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:26 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1683 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967170AbXHMGfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:16 -0400
Date: Sun, 12 Aug 2007 23:35:02 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, adaplas@gmail.com
Subject: [PATCH] [411/2many] MAINTAINERS - S3 SAVAGE FRAMEBUFFER DRIVER
Message-ID: <46bffb96.HDOBOrizgAyaMs6m%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c1596d6..88bff1a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3918,6 +3918,7 @@ P:	Antonino Daplas
 M:	adaplas@gmail.com
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	drivers/video/savage/
 
 S390
 P:	Martin Schwidefsky
