Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbZABEfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbZABEfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 23:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbZABEfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 23:35:03 -0500
Received: from ozlabs.org ([203.10.76.45]:45214 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586AbZABEfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 23:35:01 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18781.39270.35009.235687@cargo.ozlabs.ibm.com>
Date: Fri, 2 Jan 2009 15:34:46 +1100
From: Paul Mackerras <paulus@samba.org>
To: torvalds@linux-foundation.org
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, benh@kernel.crashing.org
Subject: [PATCH] Update powerpc maintainers
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Herrenschmidt is taking over as the primary powerpc architecture
maintainer.  I'll still be around as his backup/deputy.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---

diff --git a/MAINTAINERS b/MAINTAINERS
index ceb32ee..ef777d2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2635,10 +2635,10 @@ W:	http://www.hansenpartnership.com/voyager
 S:	Maintained
 
 LINUX FOR POWERPC (32-BIT AND 64-BIT)
-P:	Paul Mackerras
-M:	paulus@samba.org
 P:	Benjamin Herrenschmidt
 M:	benh@kernel.crashing.org
+P:	Paul Mackerras
+M:	paulus@samba.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/paulus/powerpc.git
