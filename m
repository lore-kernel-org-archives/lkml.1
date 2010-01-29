Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000Ab0A2QHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab0A2QHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653Ab0A2QHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:07:30 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab0A2QHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:07:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=h5he4DDcOt8rI9VmJBnu6lnwvATQhSjds4dW5Zy9wa6ia/pwtCXpdAgDHtwTOLq6Od
         e3+dkL/VocaELmzbTb2u2InE8ZiVSXa1MG/tuRsgIqfmjEcL2AHHKjiHRL6kzd1nQmVM
         kS4BNalPqxu5eZIt26xHmGUWWC90shYbOjeZk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:07:18 +0100
Message-Id: <20100129160718.21495.19709.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 39/68] pata_cmd64x: documentation fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cmd64x: documentation fix

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cmd64x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_cmd64x.c
===================================================================
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -113,7 +113,7 @@ out:
 }
 
 /**
- *	cmd64x_set_piomode	-	set PIO and MWDMA timing
+ *	cmd64x_set_timing	-	set PIO and MWDMA timing
  *	@ap: ATA interface
  *	@adev: ATA device
  *	@mode: mode
