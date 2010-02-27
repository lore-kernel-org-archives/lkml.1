Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030247Ab0B0QxO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:53:14 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030291Ab0B0QxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:53:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=DSctxmRM+9MsJX0UkuYYiGc3aWDPxxRPOg3j2YW1QNCUu265Fsk0s+RWSaydQtrpJH
         3bDasoj4u6bDCMeesE3f3X+vz5dOw7eAqKKlXBUr09NBCbeJTSQXSkjXEeNJ6tgYJvTx
         rmIqFd32Ls9H2M7UUQY9cAnjGGTt1dv2Kbta8=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-cris-kernel@axis.com
Subject: [PATCH 12/66] arch/cris/include/asm/kmap_types.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:50:53 +0100
Message-Id: <1267289508-31031-13-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/cris/include/asm/kmap_types.h:5: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/cris/include/asm/kmap_types.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/cris/include/asm/kmap_types.h b/arch/cris/include/asm/kmap_types.h
index d2d643c..eff255e 100644
--- a/arch/cris/include/asm/kmap_types.h
+++ b/arch/cris/include/asm/kmap_types.h
@@ -2,7 +2,7 @@
 #define _ASM_KMAP_TYPES_H
 
 /* Dummy header just to define km_type.  None of this
- * is actually used on cris. 
+ * is actually used on cris.
  */
 
 #include <asm-generic/kmap_types.h>
-- 
1.7.0.90.g251a4

