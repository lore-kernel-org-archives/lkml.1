Return-Path: <linux-kernel-owner+w=401wt.eu-S1760307AbYG1VKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307AbYG1VKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbYG1VJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:09:33 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:49589 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbYG1VJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:09:33 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 01/24] x86: kernel/alternative.c cleanup
Date: Mon, 28 Jul 2008 18:09:08 -0300
Message-Id: <1217279371-4410-2-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
 <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove additional whitespaces.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/alternative.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 2763cb3..f5c48c4 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -458,7 +458,7 @@ void __init alternative_instructions(void)
 			alternatives_smp_switch(0);
 	}
 #endif
- 	apply_paravirt(__parainstructions, __parainstructions_end);
+	apply_paravirt(__parainstructions, __parainstructions_end);
 
 	if (smp_alt_once)
 		free_init_pages("SMP alternatives",
-- 
1.5.4.5

