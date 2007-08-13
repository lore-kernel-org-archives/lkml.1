Return-Path: <linux-kernel-owner+w=401wt.eu-S966403AbXHMG3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966403AbXHMG3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965673AbXHMGWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:22:38 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3495 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965666AbXHMGWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:37 -0400
Date: Sun, 12 Aug 2007 23:21:50 -0700
From: joe@perches.com
To: v9fs-developer@lists.sourceforge.net, torvalds@linux-foundation.org,
       rminnich@lanl.gov, lucho@ionkov.net, linux-kernel@vger.kernel.org,
       ericvh@gmail.com, akpm@linux-foundation.org
Subject: [PATCH] [14/2many] MAINTAINERS - 9P FILE SYSTEM
Message-ID: <46bff87e.Hh3A1/WCUR2GcgBS%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f365b2e..acba68e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -186,6 +186,7 @@ L:	v9fs-developer@lists.sourceforge.net
 W:	http://v9fs.sf.net
 T:	git kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
 S:	Maintained
+F:	fs/9p/
 
 A2232 SERIAL BOARD DRIVER
 P:	Enver Haase
