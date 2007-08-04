Return-Path: <linux-kernel-owner+w=401wt.eu-S933061AbXHDSeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061AbXHDSeq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 14:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765535AbXHDSdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 14:33:11 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:45415 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765095AbXHDSdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 14:33:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:user-agent:cc:mime-version:content-disposition:date:content-type:content-transfer-encoding:message-id;
        b=kLPAD9HIfWNnPvxZlAXScyjL72+Z+J8of83YEWvBMu2k8dtWvesbbZ34NCc8gsY58e4EhMc3m20hFhv+fZMtys4Fboqio7e4lqaLqwioyy7PM4nWALrzT+Hq6W4iRPdwHS7V8yc99Wu6cLw4kUpG/WXE3NVHmM/89uRvUXH702k=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][RESEND][Trivial] fix tiny spelling error in comment in cfi_cmdset_0001.c
User-Agent: KMail/1.9.7
Cc: trivial@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jesper.juhl@gmail.com, dwmw2@infradead.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Sat, 4 Aug 2007 20:31:12 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708042031.12758.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(resending old patch from 5/7-2007 02:18)


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


