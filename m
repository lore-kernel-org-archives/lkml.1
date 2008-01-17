Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbYAQVrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbYAQVrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758262AbYAQVlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:41:52 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:44814 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928AbYAQVlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:41:50 -0500
Date: Thu, 17 Jan 2008 16:40:45 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Joe Perches <joe@perches.com>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/20] UML - Spelling fix
Message-ID: <20080117214045.GA6752@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Spelling fix

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/sys-x86_64/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-git/arch/um/sys-x86_64/signal.c
===================================================================
--- linux-2.6-git.orig/arch/um/sys-x86_64/signal.c	2008-01-02 11:25:13.000000000 -0500
+++ linux-2.6-git/arch/um/sys-x86_64/signal.c	2008-01-02 12:01:05.000000000 -0500
@@ -112,7 +112,7 @@ static int copy_sc_to_user(struct sigcon
 	err |= PUTREG(regs, RSI, to, rsi);
 	err |= PUTREG(regs, RBP, to, rbp);
 	/*
-	 * Must use orignal RSP, which is passed in, rather than what's in
+	 * Must use original RSP, which is passed in, rather than what's in
 	 * the pt_regs, because that's already been updated to point at the
 	 * signal frame.
 	 */
