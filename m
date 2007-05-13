Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbXEMHiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbXEMHiS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 03:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757294AbXEMHiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 03:38:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44677 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757239AbXEMHiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 03:38:09 -0400
Date: Sun, 13 May 2007 17:37:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: Kylene Hall <kjhall@us.ibm.com>, Marcel Selhorst <tpm@selhorst.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Revert "MAINTAINERS: remove invalid list address for TPM"
Message-Id: <20070513173714.8dfab28d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit b6d1c9a44744224d83125a5a89c1a6cc4db27361.

Others tell me that this address has worked for them, so I can only
assume that I hit a glitch in the sourceforge mail system.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kylene Hall <kjhall@us.ibm.com>
Cc: Marcel Selhorst <tpm@selhorst.net>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/MAINTAINERS b/MAINTAINERS
index 68a56ad..975f263 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3269,6 +3269,7 @@ W:	http://tpmdd.sourceforge.net
 P:	Marcel Selhorst
 M:	tpm@selhorst.net
 W:	http://www.prosec.rub.de/tpm/
+L:	tpmdd-devel@lists.sourceforge.net
 S:	Maintained
 
 Telecom Clock Driver for MCPL0010
-- 
1.5.1.4

