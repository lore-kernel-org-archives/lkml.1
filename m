Return-Path: <linux-kernel-owner+w=401wt.eu-S1760538AbYG1VK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760538AbYG1VK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYG1VJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:09:35 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:49590 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbYG1VJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:09:34 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 02/24] x86: kernel/apm_32.c cleanup
Date: Mon, 28 Jul 2008 18:09:09 -0300
Message-Id: <1217279371-4410-3-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217279371-4410-2-git-send-email-gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
 <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-2-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove additional whitespaces and tabs.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/apm_32.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 9ee24e6..b0c049c 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -435,7 +435,7 @@ static const char * const apm_event_name[] = {
 
 typedef struct lookup_t {
 	int	key;
-	char 	*msg;
+	char *msg;
 } lookup_t;
 
 /*
@@ -1679,8 +1679,8 @@ static int apm(void *unused)
 	unsigned short	cx;
 	unsigned short	dx;
 	int		error;
-	char 		*power_stat;
-	char 		*bat_stat;
+	char	*power_stat;
+	char	*bat_stat;
 
 #ifdef CONFIG_SMP
 	/* 2002/08/01 - WT
-- 
1.5.4.5

