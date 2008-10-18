Return-Path: <linux-kernel-owner+w=401wt.eu-S1751898AbYJRM4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbYJRM4x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 08:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbYJRM4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 08:56:45 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:55006 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbYJRM4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 08:56:44 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Eric Miao <eric.miao@marvell.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm: balance parenthesis in header file
Date: Sat, 18 Oct 2008 14:56:43 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810181456.44273.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	Introduced by:

commit fff147208b48680cb7b627a144113a6585828a0e
Author: Eric Miao <eric.miao@marvell.com>
Date:   Fri Sep 5 22:15:23 2008 +0800

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

--- a/arch/arm/mach-pxa/include/mach/spitz.h
+++ b/arch/arm/mach-pxa/include/mach/spitz.h
@@ -142,7 +142,7 @@

 #define SPITZ_SCP2_GPIO_BASE		(NR_BUILTIN_GPIO + 12)
 #define SPITZ_GPIO_IR_ON		(SPITZ_SCP2_GPIO_BASE + 0)
-#define SPITZ_GPIO_AKIN_PULLUP		(SPITZ_SCP2_GPIO_BASE + 1
+#define SPITZ_GPIO_AKIN_PULLUP		(SPITZ_SCP2_GPIO_BASE + 1)
 #define SPITZ_GPIO_RESERVED_1		(SPITZ_SCP2_GPIO_BASE + 2)
 #define SPITZ_GPIO_RESERVED_2		(SPITZ_SCP2_GPIO_BASE + 3)
 #define SPITZ_GPIO_RESERVED_3		(SPITZ_SCP2_GPIO_BASE + 4)

