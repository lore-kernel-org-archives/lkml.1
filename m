Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030246Ab0B0QxF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:53:05 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968629Ab0B0Qw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:52:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=MQoUeX8xhcliHU8BAPwUiCMGnHNYJgRkwtmw+8cJwVjaYo2zGVYaucegx4h/eZFBGX
         qfrjQfwVDThBRdjHbgpHL6RSB59jG2gsqznuhIxxOmWdjFWbQNE61s7L799Ae+bakhSK
         fYhsYmwfW2OdE2LnIq7y/3UA7NhcmI/YJLUGg=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 11/66] arch/um/drivers/stdio_console.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:50:52 +0100
Message-Id: <1267289508-31031-12-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/drivers/stdio_console.h:1: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/drivers/stdio_console.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/stdio_console.h b/arch/um/drivers/stdio_console.h
index 6d8275f..587cd2d 100644
--- a/arch/um/drivers/stdio_console.h
+++ b/arch/um/drivers/stdio_console.h
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
  * Licensed under the GPL
  */
@@ -8,4 +8,3 @@
 
 extern void save_console_flags(void);
 #endif
-
-- 
1.7.0.90.g251a4

