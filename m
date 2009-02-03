Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbZBCMNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbZBCMNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 07:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZBCMNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 07:13:01 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:27971 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791AbZBCMNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 07:13:00 -0500
X-IronPort-AV: E=Sophos;i="4.37,372,1231110000"; 
   d="scan'208";a="20566510"
Date: Tue, 3 Feb 2009 13:12:58 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, torvalds@osdl.org
Subject: Re: replaces [PATCH, TRIVIAL] Fix my email address in qd65xx.[ch]
Message-ID: <20090203121258.GD4996@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	torvalds@osdl.org
References: <20090203115712.GC4996@const.bordeaux.inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090203115712.GC4996@const.bordeaux.inria.fr>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault, le Tue 03 Feb 2009 12:57:12 +0100, a écrit :
> The @fnac.net will be shut down within a couple of months, so fix my
> email address.

Oops, missed the duplicated pata file, here it is again.



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
diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
index 3080f37..f1b26f7 100644
--- a/drivers/ata/pata_qdi.c
+++ b/drivers/ata/pata_qdi.c
@@ -12,7 +12,7 @@
  *
  * Probe code based on drivers/ide/legacy/qd65xx.c
  * Rewritten from the work of Colten Edwards <pje120@cs.usask.ca> by
- * Samuel Thibault <samuel.thibault@fnac.net>
+ * Samuel Thibault <samuel.thibault@ens-lyon.org>
  */
 
 #include <linux/kernel.h>
