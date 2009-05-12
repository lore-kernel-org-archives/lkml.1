Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbZELHNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbZELHNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 03:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755775AbZELHNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 03:13:44 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:36404 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbZELHNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 03:13:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=ggRUPgWEH8tAkilbro9ZvSiB1z9J8AspQHcd7P6bPYk2EvTUx2m5MzuP7rQii0OB2P
         1mBjiQP/K+vY5aWKaZgGJ1FaSPcKn8fM1v0KdTnT/68lXmADf/GQqIVrRt5YyClqRuuO
         cbYOw5DLgiQtO+C6LQRfD3tUzUn9VG4H2qQek=
Subject: [PATCH] Trivial spelling fix in ppc code comments
From: Sankar P <sankar.curiosity@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "trivial@kernel.org" <trivial@kernel.org>, linuxppc-dev@ozlabs.org
Content-Type: text/plain
Date: Tue, 12 May 2009 12:41:13 +0530
Message-Id: <1242112273.736.6.camel@blr-psankar.blr.novell.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a trivial spelling error in powerpc code comments. 

Signed-off-by: Sankar P <sankar.curiosity@gmail.com>

---
diff --git a/arch/powerpc/mm/slb.c b/arch/powerpc/mm/slb.c
index 89497fb..3b52c80 100644
--- a/arch/powerpc/mm/slb.c
+++ b/arch/powerpc/mm/slb.c
@@ -2,7 +2,7 @@
  * PowerPC64 SLB support.
  *
  * Copyright (C) 2004 David Gibson <dwg@au.ibm.com>, IBM
- * Based on earlier code writteh by:
+ * Based on earlier code written by:
  * Dave Engebretsen and Mike Corrigan {engebret|mikejc}@us.ibm.com
  *    Copyright (c) 2001 Dave Engebretsen
  * Copyright (C) 2002 Anton Blanchard <anton@au.ibm.com>, IBM


