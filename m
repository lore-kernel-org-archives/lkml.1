Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968638Ab0B0Qxd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:53:33 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030306Ab0B0QxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:53:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ewQNMADiqcj7IIFsVsXTyJ7pWLHeHeDk+79PP8BlZL5ZNKRVBXMS3xMSOcAxJJvB9U
         7plILuUXBib99osXeda3waZzOqJwoQfMc24Uz5/8Ju+8955Z2+wkpkdTGQrEOk1H1BJJ
         GbZ5oHRXNQvjIlXCVLdJ7wMSkwVpx79a1NeKk=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 15/66] arch/um/drivers/ssl.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:50:56 +0100
Message-Id: <1267289508-31031-16-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/drivers/ssl.h:1: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/drivers/ssl.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/ssl.h b/arch/um/drivers/ssl.h
index 314d177..de82843 100644
--- a/arch/um/drivers/ssl.h
+++ b/arch/um/drivers/ssl.h
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
  * Licensed under the GPL
  */
@@ -10,4 +10,3 @@ extern int ssl_read(int fd, int line);
 extern void ssl_receive_char(int line, char ch);
 
 #endif
-
-- 
1.7.0.90.g251a4

