Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030251Ab0B0Qw7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:52:59 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030282Ab0B0Qww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:52:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=wPAp5bExjXFovncDWNZbiEAnZQUAQeNWtiy6OkJ7tECZsDmbsGCpn6LQfneIeOZNdQ
         8UlJXHayaCBbTNInwfXy8C19NrrpdNILLlFPH0yAXFZzPaNOMCp3zzqcyFrsvI/2Mh4J
         WYrRw6HWYpdPmtVQ0zBlhtn9U5TtG8DKprlBY=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 10/66] arch/um/kernel/gprof_syms.c: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:50:51 +0100
Message-Id: <1267289508-31031-11-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/kernel/gprof_syms.c:1: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/kernel/gprof_syms.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/kernel/gprof_syms.c b/arch/um/kernel/gprof_syms.c
index e2f043d..ec82929 100644
--- a/arch/um/kernel/gprof_syms.c
+++ b/arch/um/kernel/gprof_syms.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
-- 
1.7.0.90.g251a4

