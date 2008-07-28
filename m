Return-Path: <linux-kernel-owner+w=401wt.eu-S1761458AbYG1VNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761458AbYG1VNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756732AbYG1VJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:09:40 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:49591 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066AbYG1VJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:09:39 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 11/24] x86: kernel/kprobes.c cleanup
Date: Mon, 28 Jul 2008 18:09:18 -0300
Message-Id: <1217279371-4410-12-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217279371-4410-11-git-send-email-gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
 <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-3-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-4-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-5-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-6-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-7-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-8-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-9-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-10-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-11-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove additional whitespaces.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/kprobes.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 6c27679..d3190dc 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -30,14 +30,14 @@
  *		<jkenisto@us.ibm.com> and Prasanna S Panchamukhi
  *		<prasanna@in.ibm.com> added function-return probes.
  * 2005-May	Rusty Lynch <rusty.lynch@intel.com>
- * 		Added function return probes functionality
+ *		Added function return probes functionality
  * 2006-Feb	Masami Hiramatsu <hiramatu@sdl.hitachi.co.jp> added
- * 		kprobe-booster and kretprobe-booster for i386.
+ *		kprobe-booster and kretprobe-booster for i386.
  * 2007-Dec	Masami Hiramatsu <mhiramat@redhat.com> added kprobe-booster
- * 		and kretprobe-booster for x86-64
+ *		and kretprobe-booster for x86-64
  * 2007-Dec	Masami Hiramatsu <mhiramat@redhat.com>, Arjan van de Ven
- * 		<arjan@infradead.org> and Jim Keniston <jkenisto@us.ibm.com>
- * 		unified x86 kprobes code.
+ *		<arjan@infradead.org> and Jim Keniston <jkenisto@us.ibm.com>
+ *		unified x86 kprobes code.
  */
 
 #include <linux/kprobes.h>
-- 
1.5.4.5

