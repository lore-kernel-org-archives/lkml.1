Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbXGZQhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbXGZQhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934018AbXGZQeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:34:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35461 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934409AbXGZQea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:34:30 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] ia64 time.c: ANSIfy
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1IE6IH-0005Ho-MU@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:34:29 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/ia64/kernel/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 627785c..1169d46 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -255,7 +255,7 @@ ia64_init_itm (void)
 	}
 }
 
-static cycle_t itc_get_cycles()
+static cycle_t itc_get_cycles(void)
 {
 	u64 lcycle, now, ret;
 
-- 
1.5.3.GIT


