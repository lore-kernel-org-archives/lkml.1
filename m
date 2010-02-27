Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030541Ab0B0Q5m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:57:42 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030487Ab0B0Q5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:57:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=eWwjpZgGX8SurKPwEkVTq6ww25ZEN8pHj42PutF47+bzAsVVI2zjj+udFXwXW13g09
         WJlT4aLRCn5LgUN73HzAZkviU0KTZwtng5GZNz7aZJaXT+WHamQsmMMyw9zR0nk0GyDU
         A6QTpE8l8VtzodXSon/JpwD8gpfbfuoSS1uxg=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH 56/66] include/linux/mtd/mtdram.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:37 +0100
Message-Id: <1267289508-31031-57-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/mtd/mtdram.h:6: ERROR: code indent should use tabs where possible

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 include/linux/mtd/mtdram.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mtd/mtdram.h b/include/linux/mtd/mtdram.h
index 04fdc07..6889131 100644
--- a/include/linux/mtd/mtdram.h
+++ b/include/linux/mtd/mtdram.h
@@ -3,6 +3,6 @@
 
 #include <linux/mtd/mtd.h>
 int mtdram_init_device(struct mtd_info *mtd, void *mapped_address,
-                       unsigned long size, char *name);
+			unsigned long size, char *name);
 
 #endif /* __MTD_MTDRAM_H__ */
-- 
1.7.0.90.g251a4

