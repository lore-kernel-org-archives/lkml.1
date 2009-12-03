Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbZLCTxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbZLCTxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbZLCTxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:53:18 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:40945 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbZLCTxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:53:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Os4nhOp91W6EhkyBRlpeF138tTyoSnxX/sWaAbvf0ywMVIS1APqbS+SQrYrTCa6Yer
         epeGV7KOtkhz8DvRvXn2QWu+y+fAS03eUXPLMolvMYaAxYrFx7rr1AJbDIjgMWT77gRq
         etS3akgloFu3tRqaLlhPGSEQv5UfxzL53Slg0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Date: Thu, 03 Dec 2009 20:52:28 +0100
Message-Id: <20091203195228.9093.40016.sendpatchset@localhost>
In-Reply-To: <20091203195145.9093.88261.sendpatchset@localhost>
References: <20091203195145.9093.88261.sendpatchset@localhost>
Subject: [PATCH 5/6] sis5513: remove stale TODO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] sis5513: remove stale TODO

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/sis5513.c |    9 ---------
 1 file changed, 9 deletions(-)

Index: b/drivers/ide/sis5513.c
===================================================================
--- a/drivers/ide/sis5513.c
+++ b/drivers/ide/sis5513.c
@@ -632,12 +632,3 @@ module_exit(sis5513_ide_exit);
 MODULE_AUTHOR("Lionel Bouton, L C Chang, Andre Hedrick, Vojtech Pavlik");
 MODULE_DESCRIPTION("PCI driver module for SIS IDE");
 MODULE_LICENSE("GPL");
-
-/*
- * TODO:
- *	- CLEANUP
- *	- More checks in the config registers (force values instead of
- *	  relying on the BIOS setting them correctly).
- *	- Further optimisations ?
- *	  . for example ATA66+ regs 0x48 & 0x4A
- */
