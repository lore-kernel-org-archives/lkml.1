Return-Path: <linux-kernel-owner+w=401wt.eu-S933233AbYBTPga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233AbYBTPga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765533AbYBTPaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:30:09 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:38524
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567AbYBTPaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:30:01 -0500
From: Avi Kivity <avi@qumranet.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: complete segment descriptor unification
Date: Wed, 20 Feb 2008 17:26:20 +0200
Message-Id: <1203521180-21489-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the final line in asm-x86/desc_64.h

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-x86/desc_64.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)
 delete mode 100644 include/asm-x86/desc_64.h

diff --git a/include/asm-x86/desc_64.h b/include/asm-x86/desc_64.h
deleted file mode 100644
index 8b13789..0000000
--- a/include/asm-x86/desc_64.h
+++ /dev/null
@@ -1 +0,0 @@
-
-- 
1.5.4.1

