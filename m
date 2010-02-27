Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030281Ab0B0Qwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:52:51 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030261Ab0B0Qwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:52:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=lOlMonCbTgBIDPV2pQmzPmzAXrMdXnpRDDzMjcPlK/MPdIQwMGJOE0Qmp1vdivR8gf
         5hsaHJd+wpjNdZQBXnp8QIfxE1ZAKHiS6lY/6qI5zFfzCa9RuiYyhMdS+RtOohj6Y9mH
         B6+J6uHxhvZuUS0cETCoiZlO6cN8BYPqMfa2U=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 09/66] arch/um/drivers/xterm.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:50:50 +0100
Message-Id: <1267289508-31031-10-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/drivers/xterm.h:1: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/drivers/xterm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/drivers/xterm.h b/arch/um/drivers/xterm.h
index 56b9c4a..c5c8aac 100644
--- a/arch/um/drivers/xterm.h
+++ b/arch/um/drivers/xterm.h
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
  * Licensed under the GPL
  */
-- 
1.7.0.90.g251a4

