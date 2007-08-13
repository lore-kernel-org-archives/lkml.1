Return-Path: <linux-kernel-owner+w=401wt.eu-S942962AbXHMHyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942962AbXHMHyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966383AbXHMG1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:27:21 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4315 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966244AbXHMG1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:18 -0400
Date: Sun, 12 Aug 2007 23:26:57 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       juhlenko@akamai.com, bluesmoke-devel@lists.sourceforge.net,
       akpm@linux-foundation.org
Subject: [PATCH] [174/2many] MAINTAINERS - EDAC-I3000
Message-ID: <46bff9b1.SvLoj3UoPCyo7tpM%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f1dfcd2..c26b346 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1697,6 +1697,7 @@ M:	juhlenko@akamai.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/i3000_edac.c
 
 EDAC-I5000
 P:	Doug Thompson
