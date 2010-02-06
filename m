Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab0BFRre (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 12:47:34 -0500
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:64490 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932360Ab0BFRr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 12:47:27 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Cc: Frans Pop <elendil@planet.nl>, microblaze-uclinux@itee.uq.edu.au,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 05/16] microblaze: remove trailing space in messages
Date: Sat,  6 Feb 2010 18:47:12 +0100
Message-Id: <1265478443-31072-5-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <201002061844.45212.elendil@planet.nl>
References: <201002061844.45212.elendil@planet.nl>
X-OriginalArrivalTime: 06 Feb 2010 17:47:25.0501 (UTC) FILETIME=[7164E6D0:01CAA754]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: microblaze-uclinux@itee.uq.edu.au
Cc: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/cpu/cache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/kernel/cpu/cache.c b/arch/microblaze/kernel/cpu/cache.c
index d9d6383..a2c8009 100644
--- a/arch/microblaze/kernel/cpu/cache.c
+++ b/arch/microblaze/kernel/cpu/cache.c
@@ -504,7 +504,7 @@ const struct scache wt_nomsr_noirq = {
 #define CPUVER_7_20_A	0x0c
 #define CPUVER_7_20_D	0x0f
 
-#define INFO(s)	printk(KERN_INFO "cache: " s " \n");
+#define INFO(s)	printk(KERN_INFO "cache: " s "\n");
 
 void microblaze_cache_init(void)
 {
-- 
1.6.6.1

