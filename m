Return-Path: <linux-kernel-owner+w=401wt.eu-S1765242AbYCWI5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765242AbYCWI5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758206AbYCWIL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:56 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2349 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760156AbYCWILp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:45 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 051/148] include/asm-x86/ipcbuf.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:26 -0700
Message-Id: <1206259443-13210-52-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/ipcbuf.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/ipcbuf.h b/include/asm-x86/ipcbuf.h
index 2adf8b3..ee678fd 100644
--- a/include/asm-x86/ipcbuf.h
+++ b/include/asm-x86/ipcbuf.h
@@ -11,8 +11,7 @@
  * - 2 miscellaneous 32-bit values
  */
 
-struct ipc64_perm
-{
+struct ipc64_perm {
 	__kernel_key_t		key;
 	__kernel_uid32_t	uid;
 	__kernel_gid32_t	gid;
-- 
1.5.4.rc2

