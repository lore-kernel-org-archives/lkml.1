Return-Path: <linux-kernel-owner+w=401wt.eu-S942937AbXHMHxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942937AbXHMHxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966380AbXHMG1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:27:18 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4304 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966463AbXHMG1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:16 -0400
Date: Sun, 12 Aug 2007 23:26:52 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dougthompson@xmission.com, bluesmoke-devel@lists.sourceforge.net,
       akpm@linux-foundation.org
Subject: [PATCH] [171/2many] MAINTAINERS - EDAC-CORE
Message-ID: <46bff9ac.WLlw8+K3hdwRL7yr%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d4325c7..78e5b0c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1662,6 +1662,9 @@ M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Supported
+F:	Documentation/drivers/edac/edac.txt
+F:	drivers/edac/edac_*
+F:	include/linux/edac.h
 
 EDAC-E752X
 P:	Mark Gross
