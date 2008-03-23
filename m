Return-Path: <linux-kernel-owner+w=401wt.eu-S1764336AbYCWIs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764336AbYCWIs0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760052AbYCWILV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:21 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2326 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760032AbYCWILS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:18 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:24 -0700
Message-Id: <1206259443-13210-110-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/serial.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/serial.h b/include/asm-x86/serial.h
index 628c801..ae8370f 100644
--- a/include/asm-x86/serial.h
+++ b/include/asm-x86/serial.h
@@ -8,7 +8,7 @@
  * clock, since the 16550A is capable of handling a top speed of 1.5
  * megabits/second; but this requires the faster clock.
  */
-#define BASE_BAUD ( 1843200 / 16 )
+#define BASE_BAUD (1843200 / 16)
 
 /* Standard COM flags (except for COM4, because of the 8514 problem) */
 #ifdef CONFIG_SERIAL_DETECT_IRQ
-- 
1.5.4.rc2

