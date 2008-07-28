Return-Path: <linux-kernel-owner+w=401wt.eu-S1761540AbYG1VNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761540AbYG1VNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756846AbYG1VJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:09:41 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:49590 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257AbYG1VJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:09:40 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 12/24] x86: kernel/microcode.c cleanup
Date: Mon, 28 Jul 2008 18:09:19 -0300
Message-Id: <1217279371-4410-13-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217279371-4410-12-git-send-email-gustavo@las.ic.unicamp.br>
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
 <1217279371-4410-12-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove additional whitespaces.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/microcode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index 6994c75..24a82ea 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -98,10 +98,10 @@ MODULE_DESCRIPTION("Intel CPU (IA-32) Microcode Update Driver");
 MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
 MODULE_LICENSE("GPL");
 
-#define MICROCODE_VERSION 	"1.14a"
+#define MICROCODE_VERSION	"1.14a"
 
-#define DEFAULT_UCODE_DATASIZE 	(2000) 	  /* 2000 bytes */
-#define MC_HEADER_SIZE		(sizeof (microcode_header_t))  	  /* 48 bytes */
+#define DEFAULT_UCODE_DATASIZE	(2000)	  /* 2000 bytes */
+#define MC_HEADER_SIZE		(sizeof (microcode_header_t))	  /* 48 bytes */
 #define DEFAULT_UCODE_TOTALSIZE (DEFAULT_UCODE_DATASIZE + MC_HEADER_SIZE) /* 2048 bytes */
 #define EXT_HEADER_SIZE		(sizeof (struct extended_sigtable)) /* 20 bytes */
 #define EXT_SIGNATURE_SIZE	(sizeof (struct extended_signature)) /* 12 bytes */
-- 
1.5.4.5

