Return-Path: <linux-kernel-owner+w=401wt.eu-S1761785AbYG1VOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761785AbYG1VOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757426AbYG1VJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:09:43 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:49591 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257AbYG1VJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:09:41 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 15/24] x86: kernel/probe_roms_32.c cleanup
Date: Mon, 28 Jul 2008 18:09:22 -0300
Message-Id: <1217279371-4410-16-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217279371-4410-15-git-send-email-gustavo@las.ic.unicamp.br>
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
 <1217279371-4410-13-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-14-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-15-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove additional whitespaces.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/probe_roms_32.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/probe_roms_32.c b/arch/x86/kernel/probe_roms_32.c
index 675a48c..00ff4fa 100644
--- a/arch/x86/kernel/probe_roms_32.c
+++ b/arch/x86/kernel/probe_roms_32.c
@@ -35,39 +35,39 @@ static struct resource extension_rom_resource = {
 };
 
 static struct resource adapter_rom_resources[] = { {
-	.name 	= "Adapter ROM",
+	.name	= "Adapter ROM",
 	.start	= 0xc8000,
 	.end	= 0,
 	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
 }, {
-	.name 	= "Adapter ROM",
+	.name	= "Adapter ROM",
 	.start	= 0,
 	.end	= 0,
 	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
 }, {
-	.name 	= "Adapter ROM",
+	.name	= "Adapter ROM",
 	.start	= 0,
 	.end	= 0,
 	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
 }, {
-	.name 	= "Adapter ROM",
+	.name	= "Adapter ROM",
 	.start	= 0,
 	.end	= 0,
 	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
 }, {
-	.name 	= "Adapter ROM",
+	.name	= "Adapter ROM",
 	.start	= 0,
 	.end	= 0,
 	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
 }, {
-	.name 	= "Adapter ROM",
+	.name	= "Adapter ROM",
 	.start	= 0,
 	.end	= 0,
 	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
 } };
 
 static struct resource video_rom_resource = {
-	.name 	= "Video ROM",
+	.name	= "Video ROM",
 	.start	= 0xc0000,
 	.end	= 0xc7fff,
 	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
-- 
1.5.4.5

