Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968656Ab0B0Qz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:55:26 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030278Ab0B0QzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:55:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=dBPfXIePGGsVMH7/HTjYVA7nV15EhpMr7pjpshI8W27BP2mSZWV9CriBjFPgQE/X3r
         XnQg4GQzmXt9UfkHZ4D2GCVZ4UVIyKeZgJ1SYd50IUFbZgaiU/YWgB+zxCPfN1vXb4pl
         5EplDZ4x0x09g8lMHXki2fIML3t4Voo/9YvKI=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Maxim Krasnyansky <maxk@qualcomm.com>, Jeff Dike <jdike@addtoit.com>,
       vtun@office.satix.net, user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 34/66] arch/um/os-Linux/drivers/etap.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:15 +0100
Message-Id: <1267289508-31031-35-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/os-Linux/drivers/etap.h:1: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/os-Linux/drivers/etap.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/os-Linux/drivers/etap.h b/arch/um/os-Linux/drivers/etap.h
index ddffd41..0df8526 100644
--- a/arch/um/os-Linux/drivers/etap.h
+++ b/arch/um/os-Linux/drivers/etap.h
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
-- 
1.7.0.90.g251a4

