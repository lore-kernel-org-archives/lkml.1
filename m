Return-Path: <linux-kernel-owner+w=401wt.eu-S940841AbXHMHgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940841AbXHMHgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966261AbXHMG0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:13 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4107 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966057AbXHMG0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:07 -0400
Date: Sun, 12 Aug 2007 23:25:14 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, rdunlap@xenotime.net,
       linux-kernel@vger.kernel.org, jschopp@austin.ibm.com, apw@shadowen.org,
       akpm@linux-foundation.org
Subject: [PATCH] [122/2many] MAINTAINERS - CHECKPATCH
Message-ID: <46bff94a.HzXjcz4XpSWqTMJs%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 9157b5d..1c014f1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1191,6 +1191,7 @@ M:	rdunlap@xenotime.net
 P:	Joel Schopp
 M:	jschopp@austin.ibm.com
 S:	Supported
+F:	scripts/checkpatch.pl
 
 COMMON INTERNET FILE SYSTEM (CIFS)
 P:	Steve French
