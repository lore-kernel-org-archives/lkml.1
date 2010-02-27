Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030262Ab0B0Qwl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:52:41 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030248Ab0B0Qwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:52:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=LG5bLoRYtL8NnTVobhgU8QTcwoxsq55shKeAflxXYu7xiXzKSvUpON1bfvdsP3rzAP
         U95sqylTH/tYzgV37jr5BS6i/GXkBL9bs6jWAk1gBWwBJSjDnU7afQ/zhvO2KDRjPEWS
         +7z3vS4CrqiSo4F2ziFoEk9K2bgbUxZUMbfNg=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 07/66] arch/um/sys-ia64/sysdep/sigcontext.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:50:48 +0100
Message-Id: <1267289508-31031-8-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/sys-ia64/sysdep/sigcontext.h:1: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/sys-ia64/sysdep/sigcontext.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/um/sys-ia64/sysdep/sigcontext.h b/arch/um/sys-ia64/sysdep/sigcontext.h
index 76b4316..f3caa4c 100644
--- a/arch/um/sys-ia64/sysdep/sigcontext.h
+++ b/arch/um/sys-ia64/sysdep/sigcontext.h
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
  * Licensed under the GPL
  */
@@ -7,4 +7,3 @@
 #define __SYSDEP_IA64_SIGCONTEXT_H
 
 #endif
-
-- 
1.7.0.90.g251a4

