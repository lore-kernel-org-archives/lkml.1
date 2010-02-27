Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030347Ab0B0REm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:04:42 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030316Ab0B0Qxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:53:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=nmaqLwhYzT2Hhky8RFg+4SN42UXyw87cBNqvn3cmXT0pQsNNPj+xsLLvVG3KHHW1oa
         OdoNMrMFdTFu2tusAmTFZ2FggiQunsGYzGrI37nCX76aUz76FwpTMACD0dm33inHyeYY
         ds7SG3V70U75MlEIdhfUZNy9GpMXnhTQ0DOhM=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 17/66] arch/um/sys-i386/asm/archparam.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:50:58 +0100
Message-Id: <1267289508-31031-18-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/sys-i386/asm/archparam.h:1: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/sys-i386/asm/archparam.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/um/sys-i386/asm/archparam.h b/arch/um/sys-i386/asm/archparam.h
index 2a18a88..32f7253 100644
--- a/arch/um/sys-i386/asm/archparam.h
+++ b/arch/um/sys-i386/asm/archparam.h
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2000 - 2003 Jeff Dike (jdike@addtoit.com)
  * Licensed under the GPL
  */
@@ -13,4 +13,3 @@
 #endif
 
 #endif
-
-- 
1.7.0.90.g251a4

