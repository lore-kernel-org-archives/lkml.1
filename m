Return-Path: <linux-kernel-owner+w=401wt.eu-S968529AbXHMH6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968529AbXHMH6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965757AbXHMG13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:27:29 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4346 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966501AbXHMG10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:26 -0400
Date: Sun, 12 Aug 2007 23:27:01 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, rdesikan@jetzbroadband.com,
       linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net,
       arvind@acarlab.com, akpm@linux-foundation.org
Subject: [PATCH] [176/2many] MAINTAINERS - EDAC-I82975X
Message-ID: <46bff9b5.TZH103TWbdbm/d1A%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c2ef686..569f89f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1715,6 +1715,7 @@ M:	arvind@acarlab.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/i82975x_edac.c
 
 EDAC-PASEMI
 P:	Egor Martovetsky
