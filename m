Return-Path: <linux-kernel-owner+w=401wt.eu-S1759216AbXHMKxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216AbXHMKxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967367AbXHMGgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:47 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1924 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967346AbXHMGgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:41 -0400
Date: Sun, 12 Aug 2007 23:36:21 -0700
From: joe@perches.com
To: tpmdd-devel@lists.sourceforge.net, tpm@selhorst.net,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kjhall@us.ibm.com, akpm@linux-foundation.org
Subject: [PATCH] [450/2many] MAINTAINERS - TPM DEVICE DRIVER
Message-ID: <46bffbe5.GV+GkdQ7k/UTWFWW%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 14633c4..cd9cda4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4284,6 +4284,7 @@ M:	tpm@selhorst.net
 W:	http://www.prosec.rub.de/tpm/
 L:	tpmdd-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/char/tpm/
 
 Telecom Clock Driver for MCPL0010
 P:	Mark Gross
