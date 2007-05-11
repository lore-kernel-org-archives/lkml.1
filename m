Return-Path: <linux-kernel-owner+w=401wt.eu-S933159AbXEKTmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbXEKTmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966001AbXEKTk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:40:59 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45920 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965967AbXEKTk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:40:57 -0400
Message-ID: <4644C6C3.7020000@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:40:51 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       hskinnemoen@atmel.com, trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/avr32/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/avr32/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/avr32/kernel/irq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/avr32/kernel/irq.c b/arch/avr32/kernel/irq.c
index fd31124..d83c6b9 100644
--- a/arch/avr32/kernel/irq.c
+++ b/arch/avr32/kernel/irq.c
@@ -9,12 +9,12 @@
  * published by the Free Software Foundation.
  *
  * This file contains the code used by various IRQ handling routines:
- * asking for different IRQ's should be done through these routines
+ * asking for different IRQs should be done through these routines
  * instead of just grabbing them. Thus setups with different IRQ numbers
  * shouldn't result in any weird surprises, and installing new handlers
  * should be easier.
  *
- * IRQ's are in fact implemented a bit like signal handlers for the kernel.
+ * IRQs are in fact implemented a bit like signal handlers for the kernel.
  * Naturally it's not a 1:1 relation, but there are similarities.
  */
 
-- 
1.5.0.1

-- 
Simon Arlott
