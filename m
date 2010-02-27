Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030491Ab0B0Q5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:57:20 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030442Ab0B0Q5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:57:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=YfFRrSyaPuCDf2jIpjHQBdEtxrepJeN1GBOldFFmkkJlO53fWqkuloIQ02ZAifGx/6
         eTBXMjy4joK7dLEPWK4KxSdMXRvfZoqf9YCwOR56jxNRGVsPTnHslwrgFMwIbkCkFFEg
         PMVUodUZ+cCyVY1gBN8+J8SIyCMuq0+QSjDyo=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Philip Blundell <philb@gnu.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH 52/66] arch/m68k/hp300/time.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:33 +0100
Message-Id: <1267289508-31031-53-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/m68k/hp300/time.h:2: WARNING: space prohibited between function name and open parenthesis '('

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/m68k/hp300/time.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/hp300/time.h b/arch/m68k/hp300/time.h
index f5b3d09..7b98242 100644
--- a/arch/m68k/hp300/time.h
+++ b/arch/m68k/hp300/time.h
@@ -1,4 +1,2 @@
 extern void hp300_sched_init(irq_handler_t vector);
-extern unsigned long hp300_gettimeoffset (void);
-
-
+extern unsigned long hp300_gettimeoffset(void);
-- 
1.7.0.90.g251a4

