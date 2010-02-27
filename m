Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030233Ab0B0QwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:52:19 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030226Ab0B0QwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:52:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=j/5SDORt0LGbtyQQ5Smg+LW3a1y0WEOMBRX5lCWW+IdOjRihVeywxt3FypJEG+xzFw
         q/LEtRi/qygxPLCy73z3HiN9QvyR9q5jDv7Lux03vOvIIy5+FRMwTiEkaFiDSp8nGcjx
         pKPj848JY8PerEakRTMH4xGT3mrkrp1iKpo68=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 03/66] arch/um/include/asm/mmu.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:50:44 +0100
Message-Id: <1267289508-31031-4-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/include/asm/mmu.h:1: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/include/asm/mmu.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/um/include/asm/mmu.h b/arch/um/include/asm/mmu.h
index cf259de..2b201d9 100644
--- a/arch/um/include/asm/mmu.h
+++ b/arch/um/include/asm/mmu.h
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
  * Licensed under the GPL
  */
@@ -9,4 +9,3 @@
 #include "um_mmu.h"
 
 #endif
-
-- 
1.7.0.90.g251a4

