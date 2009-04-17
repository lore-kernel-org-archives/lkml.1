Return-Path: <linux-kernel-owner+w=401wt.eu-S1760119AbZDQGkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119AbZDQGkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759758AbZDQGjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:39:37 -0400
Received: from gw.goop.org ([64.81.55.164]:56733 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757192AbZDQGjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:39:36 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: mathieu.desnoyers@polymtl.ca
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 4/5] x86/paravirt: add forward-decl for task_struct
Date: Thu, 16 Apr 2009 23:39:33 -0700
Message-Id: <1239950374-1252-5-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1239950374-1252-1-git-send-email-jeremy@goop.org>
References: <1239950374-1252-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt_types.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 9121aed..e174549 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -42,6 +42,7 @@
 
 struct page;
 struct thread_struct;
+struct task_struct;
 struct desc_ptr;
 struct tss_struct;
 struct mm_struct;
-- 
1.6.0.6

