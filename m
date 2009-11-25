Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbZKYRIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbZKYRIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932970AbZKYRIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:08:44 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:60004 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933060AbZKYRIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:08:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=NH0YWk2TOeaJtMWOyB7ktp3gykOkJl1E+nPck4/IY1fePBKTDrtG2bSLcTBiarj88L
         2TD+jAmjayTgIMXReOhTe2LltOH1Fvqo4Sv6x7LS5SEYY7e3pHOJs5/bvZjozqal5e2W
         kjwgDwo72sya5tFKT+6BKyjL/SxgxkINTONy8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:08:02 +0100
Message-Id: <20091125170802.5446.46013.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 48/86] pata_legacy: add pointers to QDI65x0 documentation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_legacy: add pointers to QDI65x0 documentation

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_legacy.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: b/drivers/ata/pata_legacy.c
===================================================================
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -25,6 +25,13 @@
  *		http://www.ryston.cz/petr/vlb/pdc20230b.html
  *		http://www.ryston.cz/petr/vlb/pdc20230c.html
  *		http://www.ryston.cz/petr/vlb/pdc20630.html
+ *	QDI65x0:
+ *		http://www.ryston.cz/petr/vlb/qd6500.html
+ *		http://www.ryston.cz/petr/vlb/qd6580.html
+ *
+ *	QDI65x0 probe code based on drivers/ide/legacy/qd65xx.c
+ *	Rewritten from the work of Colten Edwards <pje120@cs.usask.ca> by
+ *	Samuel Thibault <samuel.thibault@ens-lyon.org>
  *
  *  Unsupported but docs exist:
  *	Appian/Adaptec AIC25VL01/Cirrus Logic PD7220
@@ -35,7 +42,7 @@
  *  the MPIIX where the tuning is PCI side but the IDE is "ISA side".
  *
  *  Specific support is included for the ht6560a/ht6560b/opti82c611a/
- *  opti82c465mv/promise 20230c/20630/winbond83759A
+ *  opti82c465mv/promise 20230c/20630/qdi65x0/winbond83759A
  *
  *  Use the autospeed and pio_mask options with:
  *	Appian ADI/2 aka CLPD7220 or AIC25VL01.
