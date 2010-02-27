Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030377Ab0B0RFA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:05:00 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968632Ab0B0QxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:53:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Y3c639loUAtB8l0a4gS/UKnRQPgVKx6STfo12un50ZaT79fSe8uUOKa5006vnJSvzB
         6D7elKmwH7ebbOoeC28Tif1ldMEnEsTTPtfRErxgIUjNb3FHX4doowJ8rMe7I+i51F9d
         AeUYt9U/yW76aDQiABVqiaF7yirrr5iwAg6ic=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH 13/66] arch/h8300/include/asm/md.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:50:54 +0100
Message-Id: <1267289508-31031-14-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/h8300/include/asm/md.h:2: ERROR: trailing whitespace
arch/h8300/include/asm/md.h:5: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/h8300/include/asm/md.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/h8300/include/asm/md.h b/arch/h8300/include/asm/md.h
index 1b7300e..d2f78f2 100644
--- a/arch/h8300/include/asm/md.h
+++ b/arch/h8300/include/asm/md.h
@@ -1,8 +1,8 @@
 /*
- * md.h: High speed xor_block operation for RAID4/5 
+ * md.h: High speed xor_block operation for RAID4/5
  *
  */
- 
+
 #ifndef __ASM_MD_H
 #define __ASM_MD_H
 
-- 
1.7.0.90.g251a4

