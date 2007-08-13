Return-Path: <linux-kernel-owner+w=401wt.eu-S942875AbXHMHu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942875AbXHMHu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966177AbXHMG07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:59 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4248 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966436AbXHMG05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:57 -0400
Date: Sun, 12 Aug 2007 23:26:36 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       airlied@linux.ie
Subject: [PATCH] [163/2many] MAINTAINERS - DRM DRIVERS
Message-ID: <46bff99c.j7Uza8PxFmcsoMq3%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 5a96fac..48a734c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1593,6 +1593,7 @@ M:	airlied@linux.ie
 L:	dri-devel@lists.sourceforge.net
 T:	git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
+F:	drivers/char/drm/
 
 DSCC4 DRIVER
 P:	Francois Romieu
