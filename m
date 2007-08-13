Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbXHMHCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbXHMHCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966080AbXHMGYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:14 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3774 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965942AbXHMGYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:12 -0400
Date: Sun, 12 Aug 2007 23:23:43 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jcliburn@gmail.com, csnook@redhat.com, atl1-devel@lists.sourceforge.net,
       akpm@linux-foundation.org
Subject: [PATCH] [74/2many] MAINTAINERS - ATL1 ETHERNET DRIVER
Message-ID: <46bff8ef./PAU8OU4FL0OGX8r%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b8bb108..d9d1bcc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -752,6 +752,7 @@ L:	atl1-devel@lists.sourceforge.net
 W:	http://sourceforge.net/projects/atl1
 W:	http://atl1.sourceforge.net
 S:	Maintained
+F:	drivers/net/atl1*
 
 ATM
 P:	Chas Williams
