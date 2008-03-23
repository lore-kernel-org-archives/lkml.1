Return-Path: <linux-kernel-owner+w=401wt.eu-S1763811AbYCWIa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763811AbYCWIa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759507AbYCWIJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:43 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2285 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758907AbYCWIJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:41 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 103/148] include/asm-x86/reboot.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:18 -0700
Message-Id: <1206259443-13210-104-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/reboot.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/reboot.h b/include/asm-x86/reboot.h
index e9e3ffc..6b5233b 100644
--- a/include/asm-x86/reboot.h
+++ b/include/asm-x86/reboot.h
@@ -3,8 +3,7 @@
 
 struct pt_regs;
 
-struct machine_ops
-{
+struct machine_ops {
 	void (*restart)(char *cmd);
 	void (*halt)(void);
 	void (*power_off)(void);
-- 
1.5.4.rc2

