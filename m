Return-Path: <linux-kernel-owner+w=401wt.eu-S932643AbZKYRIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643AbZKYRIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759232AbZKYRII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:08:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:24999 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644AbZKYRH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:07:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=hAfI60OKW4SKcmi06XFzZUbGvzIkLoHX24Ti5fT+dV0WAWDEKxh2ygEVe3hxkw10Cn
         Hc2mMGPKFMrg4Bmu61Ob1yaViqjoMfkM4WFIpG7xz2T7JRXpDqIJig/Bgw5uf++pWd13
         8wivoLpeMhrVORGNb+iFHcFyj4lDWW+9I/qD0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:07:19 +0100
Message-Id: <20091125170719.5446.53452.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 42/86] pata_it8213: fix it8213_pre_reset() documentation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_it8213: fix it8213_pre_reset() documentation

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_it8213.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_it8213.c
===================================================================
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -22,7 +22,7 @@
 #define DRV_VERSION	"0.0.3"
 
 /**
- *	it8213_pre_reset	-	check for 40/80 pin
+ *	it8213_pre_reset	-	probe begin
  *	@link: link
  *	@deadline: deadline jiffies for the operation
  *
