Return-Path: <linux-kernel-owner+w=401wt.eu-S968325AbXHMH4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968325AbXHMH4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966492AbXHMG1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:27:25 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4331 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966296AbXHMG1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:23 -0400
Date: Sun, 12 Aug 2007 23:26:59 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dougthompson@xmission.com, bluesmoke-devel@lists.sourceforge.net,
       akpm@linux-foundation.org
Subject: [PATCH] [175/2many] MAINTAINERS - EDAC-I5000
Message-ID: <46bff9b3.1QuIhv0X2zL8aBq8%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c26b346..c2ef686 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1705,6 +1705,7 @@ M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/i5000_edac.c
 
 EDAC-I82975X
 P:	Ranganathan Desikan
