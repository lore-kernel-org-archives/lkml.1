Return-Path: <linux-kernel-owner+w=401wt.eu-S1760808AbXHMHEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808AbXHMHEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965783AbXHMGYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:20 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3782 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966082AbXHMGYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:15 -0400
Date: Sun, 12 Aug 2007 23:23:58 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       hskinnemoen@atmel.com, akpm@linux-foundation.org
Subject: [PATCH] [82/2many] MAINTAINERS - AVR32/AT32AP MACHINE SUPPORT
Message-ID: <46bff8fe.E3zBzX/jU4F01AJf%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f8272b5..cb74477 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -825,6 +825,8 @@ AVR32/AT32AP MACHINE SUPPORT
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
 S:	Supported
+F:	arch/avr32/mach-at32ap/
+F:	include/asm-avr32/arch-at32ap/
 
 AX.25 NETWORK LAYER
 P:	Ralf Baechle
