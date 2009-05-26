Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbZEZJRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbZEZJRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbZEZJQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:16:00 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37417 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbZEZJP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:15:59 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 5/7] Blackfin: ignore generated vmlinux.lds
Date: Tue, 26 May 2009 05:15:54 -0400
Message-Id: <1243329356-12644-6-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243329356-12644-1-git-send-email-vapier@gentoo.org>
References: <1243329356-12644-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
 create mode 100644 arch/blackfin/kernel/.gitignore

diff --git a/arch/blackfin/kernel/.gitignore b/arch/blackfin/kernel/.gitignore
new file mode 100644
index 0000000..c5f676c
--- /dev/null
+++ b/arch/blackfin/kernel/.gitignore
@@ -0,0 +1 @@
+vmlinux.lds
-- 
1.6.3.1

