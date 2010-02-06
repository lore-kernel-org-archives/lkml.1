Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363Ab0BFRuU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 12:50:20 -0500
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:54862 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932347Ab0BFRr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 12:47:27 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Cc: Frans Pop <elendil@planet.nl>, linux-alpha@vger.kernel.org
Subject: [PATCH 01/16] alpha: remove trailing spaces in messages
Date: Sat,  6 Feb 2010 18:47:08 +0100
Message-Id: <1265478443-31072-1-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <201002061844.45212.elendil@planet.nl>
References: <201002061844.45212.elendil@planet.nl>
X-OriginalArrivalTime: 06 Feb 2010 17:47:25.0627 (UTC) FILETIME=[717820B0:01CAA754]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: linux-alpha@vger.kernel.org
---
 arch/alpha/kernel/sys_dp264.c |    2 +-
 arch/alpha/kernel/sys_titan.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/kernel/sys_dp264.c b/arch/alpha/kernel/sys_dp264.c
index d64e1e4..4026502 100644
--- a/arch/alpha/kernel/sys_dp264.c
+++ b/arch/alpha/kernel/sys_dp264.c
@@ -224,7 +224,7 @@ static void
 dp264_device_interrupt(unsigned long vector)
 {
 #if 1
-	printk("dp264_device_interrupt: NOT IMPLEMENTED YET!! \n");
+	printk("dp264_device_interrupt: NOT IMPLEMENTED YET!!\n");
 #else
 	unsigned long pld;
 	unsigned int i;
diff --git a/arch/alpha/kernel/sys_titan.c b/arch/alpha/kernel/sys_titan.c
index 2880533..9008d0f 100644
--- a/arch/alpha/kernel/sys_titan.c
+++ b/arch/alpha/kernel/sys_titan.c
@@ -171,7 +171,7 @@ titan_set_irq_affinity(unsigned int irq, const struct cpumask *affinity)
 static void
 titan_device_interrupt(unsigned long vector)
 {
-	printk("titan_device_interrupt: NOT IMPLEMENTED YET!! \n");
+	printk("titan_device_interrupt: NOT IMPLEMENTED YET!!\n");
 }
 
 static void 
-- 
1.6.6.1

