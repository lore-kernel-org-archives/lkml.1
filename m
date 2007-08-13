Return-Path: <linux-kernel-owner+w=401wt.eu-S933325AbXHMHfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbXHMHfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966254AbXHMG0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:09 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4100 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966252AbXHMG0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:05 -0400
Date: Sun, 12 Aug 2007 23:25:50 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [141/2many] MAINTAINERS - CYBERPRO FB DRIVER
Message-ID: <46bff96e.xEoD4RsjRAkgRDG3%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 26eeef8..aee6296 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1365,6 +1365,7 @@ P:	Russell King
 M:	rmk@arm.linux.org.uk
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
+F:	drivers/video/cyber2000fb.*
 
 CYBLAFB FRAMEBUFFER DRIVER
 P:	Knut Petersen
