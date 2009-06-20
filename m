Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbZFTSs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbZFTSs6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbZFTSqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:46:36 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48124 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757954AbZFTSqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:46:36 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Philippe Gerum <rpm@xenomai.org>
Subject: [PATCH 15/25] Blackfin: update I-pipe patch level
Date: Sat, 20 Jun 2009 14:44:38 -0400
Message-Id: <1245523488-26536-16-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Gerum <rpm@xenomai.org>

Signed-off-by: Philippe Gerum <rpm@xenomai.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/ipipe.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/include/asm/ipipe.h b/arch/blackfin/include/asm/ipipe.h
index ffa5e60..87ba9ad 100644
--- a/arch/blackfin/include/asm/ipipe.h
+++ b/arch/blackfin/include/asm/ipipe.h
@@ -35,9 +35,9 @@
 #include <asm/atomic.h>
 #include <asm/traps.h>
 
-#define IPIPE_ARCH_STRING     "1.10-00"
+#define IPIPE_ARCH_STRING     "1.11-00"
 #define IPIPE_MAJOR_NUMBER    1
-#define IPIPE_MINOR_NUMBER    10
+#define IPIPE_MINOR_NUMBER    11
 #define IPIPE_PATCH_NUMBER    0
 
 #ifdef CONFIG_SMP
-- 
1.6.3.1

