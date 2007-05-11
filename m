Return-Path: <linux-kernel-owner+w=401wt.eu-S1760956AbXEKGmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760956AbXEKGmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 02:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbXEKGmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 02:42:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39622 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642AbXEKGmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 02:42:10 -0400
Date: Fri, 11 May 2007 16:42:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: kjhall@us.ibm.com, tpm@selhorst.net
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: remove invalid list address for TPM
Message-Id: <20070511164207.24b1437e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This address bounces with "550 Unknown user".

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/MAINTAINERS b/MAINTAINERS
index bd558ac..421740d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3269,7 +3269,6 @@ W:	http://tpmdd.sourceforge.net
 P:	Marcel Selhorst
 M:	tpm@selhorst.net
 W:	http://www.prosec.rub.de/tpm/
-L:	tpmdd-devel@lists.sourceforge.net
 S:	Maintained
 
 Telecom Clock Driver for MCPL0010
-- 
1.5.1.4

