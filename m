Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbXGEATF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbXGEATF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 20:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbXGEASy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 20:18:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:15577 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbXGEASx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 20:18:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=CwlZOFJmGEHeDNU1Jarmnt0LjeLWacgayoT22KeAxfF6iuBGFnImLDcFqOyPEIIsxaVwnpf2DjuuJQzqrfUNj6UZb2CXv2SlXndYfcgBCZiF5rml0DxrzhEhtjMAXZkDDIIR82oT4XU3HgW+3RAU7kwz46lgValgGpoTgyAtekw=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: trivial@vger.kernel.org
Subject: [PATCH][Trivial] fix tiny spelling error in comment in cfi_cmdset_0001.c
Date: Thu, 5 Jul 2007 02:18:34 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jesper.juhl@gmail.com, dwmw2@infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707050218.34610.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial fix of a spelling error in a comment in cfi_cmdset_0001.c
s/ships/chips/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/mtd/chips/cfi_cmdset_0001.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
index 2f19fa7..c266ebc 100644
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -526,7 +526,7 @@ static int cfi_intelext_partition_fixup(struct mtd_info *mtd,
 	struct cfi_pri_intelext *extp = cfi->cmdset_priv;
 
 	/*
-	 * Probing of multi-partition flash ships.
+	 * Probing of multi-partition flash chips.
 	 *
 	 * To support multiple partitions when available, we simply arrange
 	 * for each of them to have their own flchip structure even if they


