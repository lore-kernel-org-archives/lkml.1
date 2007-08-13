Return-Path: <linux-kernel-owner+w=401wt.eu-S968077AbXHMGsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968077AbXHMGsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965837AbXHMGXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:22 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3629 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965849AbXHMGXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:21 -0400
Date: Sun, 12 Aug 2007 23:22:50 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, acme@ghostprotocols.net
Subject: [PATCH] [46/2many] MAINTAINERS - APPLETALK NETWORK LAYER
Message-ID: <46bff8ba.Jn9cCOPTNeEN69TN%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e9a72f3..966d1ec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -443,6 +443,8 @@ APPLETALK NETWORK LAYER
 P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net
 S:	Maintained
+F:	drivers/net/appletalk/
+F:	net/appletalk/
 
 ARC FRAMEBUFFER DRIVER
 P:	Jaya Kumar
