Return-Path: <linux-kernel-owner+w=401wt.eu-S970686AbXHMI4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970686AbXHMI4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966891AbXHMGbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:01 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4882 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966878AbXHMGa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:30:57 -0400
Date: Sun, 12 Aug 2007 23:30:43 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, sam@ravnborg.org,
       linux-kernel@vger.kernel.org, kai@germaschewski.name,
       akpm@linux-foundation.org
Subject: [PATCH] [278/2many] MAINTAINERS - KERNEL BUILD (kbuild: Makefile, scripts/Makefile.*)
Message-ID: <46bffa93.ANdf+CbKle29L7ck%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index fc719d2..0ac42ee 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2657,6 +2657,9 @@ P:	Sam Ravnborg
 M:	sam@ravnborg.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild.git
 S:	Maintained
+F:	Documentation/kbuild/
+F:	Makefile
+F:	scripts/Makefile.*
 
 KERNEL JANITORS
 P:	Several
