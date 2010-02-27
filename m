Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968666Ab0B0RDR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:03:17 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030387Ab0B0QzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:55:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ZGVHOPZ4amoB5SatHTOUDilFiZnMylAE8d8ZIAPEovwJdt4wEPZsTpVAxGNxKuy6HQ
         7544ymyLcMTMuiQbPlO0nuuzKpqnZV850/CawNaBRfMzu5gaQ3MPSGnVCB9CmLA+iDxq
         LppYwR2qwAVc4G1B3r3QvI1ODrlXJVYYDDfuI=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH 33/66] include/linux/uts.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:14 +0100
Message-Id: <1267289508-31031-34-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/uts.h:5: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 include/linux/uts.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/uts.h b/include/linux/uts.h
index 73eb1ed..2ad5582 100644
--- a/include/linux/uts.h
+++ b/include/linux/uts.h
@@ -2,7 +2,7 @@
 #define _LINUX_UTS_H
 
 /*
- * Defines for what uname() should return 
+ * Defines for what uname() should return
  */
 #ifndef UTS_SYSNAME
 #define UTS_SYSNAME "Linux"
-- 
1.7.0.90.g251a4

