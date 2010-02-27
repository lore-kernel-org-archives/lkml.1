Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030279Ab0B0RG3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:06:29 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030243Ab0B0Qwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:52:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=dfEKBWnx2So5D4xsm5gSsP4+HGSKBtIgLSixrsIcpGpv3ps+dcj0UFAvS+f+c4w3nn
         7BZiV3xT5P04GNB3j9SI/FpkiR9WVY03OXW4DJ4CAadP3OryC5s7O58/KFRwvrTSJ6K8
         zE8Af0ZEyFBP5Y2mrq5xRIP0XiIvO39o6usr0=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 06/66] arch/um/sys-ia64/sysdep/syscalls.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:50:47 +0100
Message-Id: <1267289508-31031-7-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/sys-ia64/sysdep/syscalls.h:1: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/sys-ia64/sysdep/syscalls.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/sys-ia64/sysdep/syscalls.h b/arch/um/sys-ia64/sysdep/syscalls.h
index 5f6700c..e6f6994 100644
--- a/arch/um/sys-ia64/sysdep/syscalls.h
+++ b/arch/um/sys-ia64/sysdep/syscalls.h
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
  * Licensed under the GPL
  */
-- 
1.7.0.90.g251a4

