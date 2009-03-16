Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbZCPHXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbZCPHXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 03:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755996AbZCPHWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 03:22:51 -0400
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:35629 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbZCPHWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 03:22:50 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #2 28/28] kbuild aufs
Date: Mon, 16 Mar 2009 16:20:40 +0900
Message-Id: <1237188040-11404-29-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/Kconfig  |    1 +
 fs/Makefile |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 93945dd..75156dd 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -222,6 +222,7 @@ source "fs/qnx4/Kconfig"
 source "fs/romfs/Kconfig"
 source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
+source "fs/aufs/Kconfig"
 
 endif # MISC_FILESYSTEMS
 
diff --git a/fs/Makefile b/fs/Makefile
index dc20db3..a4e9a65 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -124,3 +124,4 @@ obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_BTRFS_FS)		+= btrfs/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
+obj-$(CONFIG_AUFS_FS)           += aufs/
-- 
1.6.1.284.g5dc13

