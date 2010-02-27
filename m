Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030310Ab0B0QxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:53:21 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030301Ab0B0QxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:53:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=mvorFzfFTbMyLKqlvZQjlZmYLHPT/HDOtAGuSbJXu3tVgmees+cSvZVgPlalT5rIgG
         E/E5bxj+ZyC/8JWjLstWZJoODArLzZvsBr+wmsoSjt9dFz4Uc8m0Gx1nQfpurd8nAm+D
         OoMnzBTrEhJB7nlgyr/y4wmD5I1/RjK13oOlw=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 14/66] arch/um/sys-ia64/sysdep/ptrace.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:50:55 +0100
Message-Id: <1267289508-31031-15-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/sys-ia64/sysdep/ptrace.h:1: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/sys-ia64/sysdep/ptrace.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/um/sys-ia64/sysdep/ptrace.h b/arch/um/sys-ia64/sysdep/ptrace.h
index 0f0f4e6..8e85f09 100644
--- a/arch/um/sys-ia64/sysdep/ptrace.h
+++ b/arch/um/sys-ia64/sysdep/ptrace.h
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
  * Licensed under the GPL
  */
@@ -13,4 +13,3 @@ struct sys_pt_regs {
 #define EMPTY_REGS { 0 }
 
 #endif
-
-- 
1.7.0.90.g251a4

