Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968646Ab0B0RD6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:03:58 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030348Ab0B0QyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:54:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=P2eHoRo54XGak/8YtBWm6OxKhGyNPiAnDVI3IfdXp1M1hNekso9rhq68X3nLQg/kcu
         1zHRbuoCFkHmlHULaTaGJXXSxuqY/Tf94Iw0qQydqrwG6EQTBWMmmKs2M43uh9hvdZZH
         DB5uWfGtv66sFid0iCe3OBjigjHKrAMxfPbzs=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 23/66] arch/cris/include/arch-v10/arch/pgtable.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:04 +0100
Message-Id: <1267289508-31031-24-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/cris/include/arch-v10/arch/pgtable.h:5: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/cris/include/arch-v10/arch/pgtable.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/cris/include/arch-v10/arch/pgtable.h b/arch/cris/include/arch-v10/arch/pgtable.h
index 2a2576d..1975118 100644
--- a/arch/cris/include/arch-v10/arch/pgtable.h
+++ b/arch/cris/include/arch-v10/arch/pgtable.h
@@ -2,7 +2,7 @@
 #define _CRIS_ARCH_PGTABLE_H
 
 /*
- * Kernels own virtual memory area. 
+ * Kernels own virtual memory area.
  */
 
 #ifdef CONFIG_CRIS_LOW_MAP
@@ -14,4 +14,3 @@
 #endif
 
 #endif
-
-- 
1.7.0.90.g251a4

