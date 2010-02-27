Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968642Ab0B0Qxu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:53:50 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030304Ab0B0Qxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:53:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ZjqvuaEaOqTv6KUI806X79XsR5qgPyr++dFbW0+BnwM/xo+VQkqVmZgh2Zkhu18MSU
         TqjMiqWDTjupt2sBtwRGpANdcVfj5yt792MWWqdfWiwrWHafIJu2v8iRrs2zDkkBNAIC
         jWPIEElC/NK4wmJJR6Rrj2eu6BZGxTUqkBvuY=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 18/66] arch/um/include/shared/skas_ptrace.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:50:59 +0100
Message-Id: <1267289508-31031-19-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/include/shared/skas_ptrace.h:1: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/include/shared/skas_ptrace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/include/shared/skas_ptrace.h b/arch/um/include/shared/skas_ptrace.h
index 3d31bba..38dfbd2 100644
--- a/arch/um/include/shared/skas_ptrace.h
+++ b/arch/um/include/shared/skas_ptrace.h
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
-- 
1.7.0.90.g251a4

