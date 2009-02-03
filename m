Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbZBCMH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbZBCMH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 07:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZBCMHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 07:07:11 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:50028 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998AbZBCMHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 07:07:10 -0500
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Feb 2009 07:07:09 EST
X-IronPort-AV: E=Sophos;i="4.37,372,1231110000"; 
   d="scan'208";a="23496661"
Date: Tue, 3 Feb 2009 12:57:12 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, torvalds@osdl.org
Subject: [PATCH, TRIVIAL] Fix my email address in qd65xx.[ch]
Message-ID: <20090203115712.GC4996@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	torvalds@osdl.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The @fnac.net will be shut down within a couple of months, so fix my
email address.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

diff --git a/drivers/ide/qd65xx.c b/drivers/ide/qd65xx.c
index 5b2e3af..08c4fa3 100644
--- a/drivers/ide/qd65xx.c
+++ b/drivers/ide/qd65xx.c
@@ -16,7 +16,7 @@
 
 /*
  * Rewritten from the work of Colten Edwards <pje120@cs.usask.ca> by
- * Samuel Thibault <samuel.thibault@fnac.net>
+ * Samuel Thibault <samuel.thibault@ens-lyon.org>
  */
 
 #include <linux/module.h>
diff --git a/drivers/ide/qd65xx.h b/drivers/ide/qd65xx.h
index 6636f96..d7e67a1 100644
--- a/drivers/ide/qd65xx.h
+++ b/drivers/ide/qd65xx.h
@@ -4,7 +4,7 @@
 
 /*
  * Authors:	Petr Soucek <petr@ryston.cz>
- * 		Samuel Thibault <samuel.thibault@fnac.net>
+ * 		Samuel Thibault <samuel.thibault@ens-lyon.org>
  */
 
 /* truncates a in [b,c] */
