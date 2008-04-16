Return-Path: <linux-kernel-owner+w=401wt.eu-S1765681AbYDPPYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765681AbYDPPYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 11:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbYDPPYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 11:24:18 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:44199 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756287AbYDPPYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:24:17 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: cooloney@kernel.org
Subject: [PATCH] Blackfin: add include/boot .gitignore files
Date: Wed, 16 Apr 2008 11:24:16 -0400
Message-Id: <1208359456-2109-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/boot/.gitignore   |    1 +
 include/asm-blackfin/.gitignore |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)
 create mode 100644 arch/blackfin/boot/.gitignore
 create mode 100644 include/asm-blackfin/.gitignore

diff --git a/arch/blackfin/boot/.gitignore b/arch/blackfin/boot/.gitignore
new file mode 100644
index 0000000..64386a8
--- /dev/null
+++ b/arch/blackfin/boot/.gitignore
@@ -0,0 +1 @@
+vmImage
diff --git a/include/asm-blackfin/.gitignore b/include/asm-blackfin/.gitignore
new file mode 100644
index 0000000..fc6ac35
--- /dev/null
+++ b/include/asm-blackfin/.gitignore
@@ -0,0 +1 @@
+mach
-- 
1.5.5

