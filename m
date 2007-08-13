Return-Path: <linux-kernel-owner+w=401wt.eu-S966291AbXHMItZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966291AbXHMItZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966490AbXHMGac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:30:32 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4808 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966816AbXHMGab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:30:31 -0400
Date: Sun, 12 Aug 2007 23:30:18 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, samuel@sortiz.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [266/2many] MAINTAINERS - IRDA SUBSYSTEM
Message-ID: <46bffa7a.ZCAHxia8uoXEL5se%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b97c776..3d726c8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2543,6 +2543,10 @@ M:	samuel@sortiz.org
 L:	irda-users@lists.sourceforge.net (subscribers-only)
 W:	http://irda.sourceforge.net/
 S:	Maintained
+F:	Documentation/networking/irda.txt
+F:	drivers/net/irda/
+F:	include/net/irda/
+F:	net/irda/
 
 ISAPNP
 P:	Jaroslav Kysela
