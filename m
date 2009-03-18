Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbZCRUfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbZCRUfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZCRUby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:31:54 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:56225 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753133AbZCRUbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:31:43 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 12/57] microblaze_v7: lmb include file
Date: Wed, 18 Mar 2009 21:30:39 +0100
Message-Id: <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/lmb.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/lmb.h

diff --git a/arch/microblaze/include/asm/lmb.h b/arch/microblaze/include/asm/lmb.h
new file mode 100644
index 0000000..a0a0a92
--- /dev/null
+++ b/arch/microblaze/include/asm/lmb.h
@@ -0,0 +1,17 @@
+/*
+ * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_LMB_H
+#define _ASM_MICROBLAZE_LMB_H
+
+/* LMB limit is OFF */
+#define LMB_REAL_LIMIT	0xFFFFFFFF
+
+#endif /* _ASM_MICROBLAZE_LMB_H */
+
+
-- 
1.5.5.1

