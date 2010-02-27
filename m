Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030519Ab0B0Q51 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:57:27 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030442Ab0B0Q5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:57:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=B0RxtfPGyc136cYbG2ih8GdtG7ZcO596e8rB5b1kaYbNILgyuEvIF3S0EWbcL0d2Sg
         kcwHdK2OqGoFFr7Ecfd9Rb44Ai43dcWgY2gXhuK+Ad2JIv+9qB77aKbvQIqj/zJojmv9
         ozbRbWz5558MhIw2wpQ4q4D/fzuKNWF66z5/M=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Arnd Bergmann <arnd@arndb.de>,
       linux-arch@vger.kernel.org
Subject: [PATCH 54/66] include/asm-generic/kdebug.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:35 +0100
Message-Id: <1267289508-31031-55-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/asm-generic/kdebug.h:6: ERROR: spaces required around that '=' (ctx:VxV)

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 include/asm-generic/kdebug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/kdebug.h b/include/asm-generic/kdebug.h
index 11e57b6..832be39 100644
--- a/include/asm-generic/kdebug.h
+++ b/include/asm-generic/kdebug.h
@@ -3,7 +3,7 @@
 
 enum die_val {
 	DIE_UNUSED,
-	DIE_OOPS=1
+	DIE_OOPS = 1
 };
 
 #endif /* _ASM_GENERIC_KDEBUG_H */
-- 
1.7.0.90.g251a4

