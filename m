Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYHVQCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYHVQCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 12:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYHVQCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 12:02:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34809 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbYHVQCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 12:02:09 -0400
Subject: [PATCH] TPM: include subscribers-only notation in MAINTAINERS
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com, tpm@selhorst.net
Content-Type: text/plain
Date: Fri, 22 Aug 2008 11:55:19 -0400
Message-Id: <1219420519.3613.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include subscribers-only notation in the MAINTAINERS information for the
tpm development mailing list so people like me don't get rejected
sending mails to closed lists next time.

---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 663485b..44f8006 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4132,7 +4132,7 @@ W:	http://tpmdd.sourceforge.net
 P:	Marcel Selhorst
 M:	tpm@selhorst.net
 W:	http://www.prosec.rub.de/tpm/
-L:	tpmdd-devel@lists.sourceforge.net
+L:	tpmdd-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 
 TRIVIAL PATCHES


