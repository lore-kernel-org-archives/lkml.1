Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030320Ab0B0Qxj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:53:39 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030314Ab0B0Qx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:53:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=nzK/WhDIJCtLUYeDziu7xgRZSJX58OaPsRXpmg5bEgCgvWw3uxdQRwjut3rqvRtN+P
         ErXguWlkyH3dnaCng1hWPRLgG/IG+jp8kCoVsGfneA8+TqIcTWB10AgSliAuaW5t0WZD
         2uhoIQbUrCvRF5Tedfy0hKTAyoPhnnDAVBM5g=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH 16/66] arch/sparc/include/asm/setup.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:50:57 +0100
Message-Id: <1267289508-31031-17-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/sparc/include/asm/setup.h:2: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/sparc/include/asm/setup.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/include/asm/setup.h b/arch/sparc/include/asm/setup.h
index 2643c62..b1597f1 100644
--- a/arch/sparc/include/asm/setup.h
+++ b/arch/sparc/include/asm/setup.h
@@ -1,5 +1,5 @@
 /*
- *	Just a place holder. 
+ *	Just a place holder.
  */
 
 #ifndef _SPARC_SETUP_H
-- 
1.7.0.90.g251a4

