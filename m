Return-Path: <linux-kernel-owner+w=401wt.eu-S967370AbXHMHb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967370AbXHMHb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966156AbXHMGZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:25:54 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4044 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965821AbXHMGZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:46 -0400
Date: Sun, 12 Aug 2007 23:25:25 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jaharkes@cs.cmu.edu, codalist@TELEMANN.coda.cs.cmu.edu, coda@cs.cmu.edu,
       akpm@linux-foundation.org
Subject: [PATCH] [128/2many] MAINTAINERS - CODA FILE SYSTEM
Message-ID: <46bff955.dOIo2OfUogJvWPCn%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index de652f5..6721969 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1245,6 +1245,8 @@ M:	coda@cs.cmu.edu
 L:	codalist@coda.cs.cmu.edu
 W:	http://www.coda.cs.cmu.edu/
 S:	Maintained
+F:	fs/coda/
+F:	include/linux/coda*.h
 
 COMPACTPCI HOTPLUG CORE
 P:	Scott Murray
