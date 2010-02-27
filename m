Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030488Ab0B0RC2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:02:28 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968653Ab0B0QzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:55:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=PgGfh6CntKgz3+OVc8IV0fcQHi8Y3rwm1zbMxYmfT5hgGuNKKURuMzLhrQUC/4lbud
         4ul7JXISqrGttpliTs/8yoUy6r1abdvj9kCTEMYWO/MG1fiqOIlWaXBg14NO66mtEzZY
         m4LYxe3Er7ugUHnfuFSJa/PpiK/mDJJIK6lpE=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 36/66] arch/um/include/shared/ubd_user.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:17 +0100
Message-Id: <1267289508-31031-37-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/include/shared/ubd_user.h:1: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/include/shared/ubd_user.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/um/include/shared/ubd_user.h b/arch/um/include/shared/ubd_user.h
index 3845051..9198fa3 100644
--- a/arch/um/include/shared/ubd_user.h
+++ b/arch/um/include/shared/ubd_user.h
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
  * Copyright (C) 2001 RidgeRun, Inc (glonnon@ridgerun.com)
  * Licensed under the GPL
@@ -13,4 +13,3 @@ extern int io_thread(void *arg);
 extern int kernel_fd;
 
 #endif
-
-- 
1.7.0.90.g251a4

