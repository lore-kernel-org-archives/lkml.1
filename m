Return-Path: <linux-kernel-owner+w=401wt.eu-S969518AbXHMI50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969518AbXHMI50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966878AbXHMGbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:04 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4890 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965797AbXHMGbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:00 -0400
Date: Sun, 12 Aug 2007 23:30:41 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, raven@themaw.net,
       linux-kernel@vger.kernel.org, autofs@linux.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [277/2many] MAINTAINERS - KERNEL AUTOMOUNTER v4 (AUTOFS4)
Message-ID: <46bffa91.mhwtn3owiJ9Kj9Zh%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index dc0823d..fc719d2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2648,6 +2648,7 @@ P:	Ian Kent
 M:	raven@themaw.net
 L:	autofs@linux.kernel.org
 S:	Maintained
+F:	fs/autofs4/
 
 KERNEL BUILD (kbuild: Makefile, scripts/Makefile.*)
 P:	Kai Germaschewski
