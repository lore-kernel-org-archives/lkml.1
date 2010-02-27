Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030364Ab0B0Qzg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:55:36 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030397Ab0B0QzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:55:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=IKG3PHoWftUMBgbG+QXJL2U+8hms89cm6tI/ww8DQ8X0BTjT5qBzojMfrO20WS180Q
         RPjhZwnhBHj1QX7lMa31PqZ5S4J72oqLNgO0IegIJZXd2YC1C4QMwmWvvFOc9iGhMfoT
         e4QCz+l3p1kvL0Ky73+2ELNmTukpSl2e9tY9o=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 35/66] arch/cris/include/arch-v10/arch/tlb.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:16 +0100
Message-Id: <1267289508-31031-36-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/cris/include/arch-v10/arch/tlb.h:6: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/cris/include/arch-v10/arch/tlb.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/cris/include/arch-v10/arch/tlb.h b/arch/cris/include/arch-v10/arch/tlb.h
index 31525bb..d565bd8 100644
--- a/arch/cris/include/arch-v10/arch/tlb.h
+++ b/arch/cris/include/arch-v10/arch/tlb.h
@@ -3,7 +3,7 @@
 
 /* The TLB can host up to 64 different mm contexts at the same time.
  * The last page_id is never running - it is used as an invalid page_id
- * so we can make TLB entries that will never match. 
+ * so we can make TLB entries that will never match.
  */
 #define NUM_TLB_ENTRIES 64
 #define NUM_PAGEID 64
-- 
1.7.0.90.g251a4

