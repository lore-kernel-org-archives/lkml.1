Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbZBPANK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbZBPANK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858AbZBPAMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:12:07 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:35554 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbZBPAMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:12:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=HwtfqhmvIIOZFXhTC2AH4y63WE6ZaqppFR/ayHRe+u1ywfF2Pzsv4H+NnevZZzAULw
         +vs47b3FYdWTkqvaVwdnA6CD7l3N9CMr/RS/x5ROWAD6T7EHYpToxCZ4qw9sTQO4x870
         2XEbUjdl6wOZeuvU+qBtZAMSLqrOovG3/phXk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 16 Feb 2009 01:13:29 +0100
Message-Id: <20090216001329.27491.49628.sendpatchset@localhost.localdomain>
In-Reply-To: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
References: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
Subject: [PATCH 03/20] ide-cd: remove dead URLs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: remove dead URLs

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -12,12 +12,9 @@
  * See Documentation/cdrom/ide-cd for usage information.
  *
  * Suggestions are welcome. Patches that work are more welcome though. ;-)
- * For those wishing to work on this driver, please be sure you download
- * and comply with the latest Mt. Fuji (SFF8090 version 4) and ATAPI
- * (SFF-8020i rev 2.6) standards. These documents can be obtained by
- * anonymous ftp from:
- * ftp://fission.dt.wdc.com/pub/standards/SFF_atapi/spec/SFF8020-r2.6/PS/8020r26.ps
- * ftp://ftp.avc-pioneer.com/Mtfuji4/Spec/Fuji4r10.pdf
+ *
+ * Documentation:
+ *	Mt. Fuji (SFF8090 version 4) and ATAPI (SFF-8020i rev 2.6) standards.
  *
  * For historical changelog please see:
  *	Documentation/ide/ChangeLog.ide-cd.1994-2004
