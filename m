Return-Path: <linux-kernel-owner+w=401wt.eu-S940028AbXHMG6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940028AbXHMG6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966025AbXHMGX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:57 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3727 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966017AbXHMGX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:56 -0400
Date: Sun, 12 Aug 2007 23:23:41 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       ecashin@coraid.com, akpm@linux-foundation.org
Subject: [PATCH] [73/2many] MAINTAINERS - ATA OVER ETHERNET DRIVER
Message-ID: <46bff8ed.gfAxHwWrSc/PwGwN%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index a165698..b8bb108 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -740,6 +740,8 @@ P:	Ed L. Cashin
 M:	ecashin@coraid.com
 W:	http://www.coraid.com/support/linux
 S:	Supported
+F:	Documentation/aoe/
+F:	drivers/block/aoe/
 
 ATL1 ETHERNET DRIVER
 P:	Jay Cliburn
