Return-Path: <linux-kernel-owner+w=401wt.eu-S937922AbXHMKXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937922AbXHMKXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967242AbXHMGfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:20 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1664 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967236AbXHMGfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:09 -0400
Date: Sun, 12 Aug 2007 23:34:56 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [408/2many] MAINTAINERS - ROCKETPORT DRIVER
Message-ID: <46bffb90.A10zk9KOMLJOpqtT%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 1a2d474..faba77e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3886,6 +3886,8 @@ ROCKETPORT DRIVER
 P:	Comtrol Corp.
 W:	http://www.comtrol.com
 S:	Maintained
+F:	Documentation/rocket.txt
+F:	drivers/char/rocket*
 
 ROSE NETWORK LAYER
 P:	Ralf Baechle
