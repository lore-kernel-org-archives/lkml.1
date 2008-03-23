Return-Path: <linux-kernel-owner+w=401wt.eu-S1761896AbYCWIxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761896AbYCWIxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760143AbYCWILm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:42 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2336 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760104AbYCWILg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:36 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 028/148] include/asm-x86/dwarf2_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:03 -0700
Message-Id: <1206259443-13210-29-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/dwarf2_64.h |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/asm-x86/dwarf2_64.h b/include/asm-x86/dwarf2_64.h
index eedc085..c950519 100644
--- a/include/asm-x86/dwarf2_64.h
+++ b/include/asm-x86/dwarf2_64.h
@@ -1,16 +1,15 @@
 #ifndef _DWARF2_H
 #define _DWARF2_H 1
 
-
 #ifndef __ASSEMBLY__
 #warning "asm/dwarf2.h should be only included in pure assembly files"
 #endif
 
-/* 
+/*
    Macros for dwarf2 CFI unwind table entries.
-   See "as.info" for details on these pseudo ops. Unfortunately 
-   they are only supported in very new binutils, so define them 
-   away for older version. 
+   See "as.info" for details on these pseudo ops. Unfortunately
+   they are only supported in very new binutils, so define them
+   away for older version.
  */
 
 #ifdef CONFIG_AS_CFI
-- 
1.5.4.rc2

