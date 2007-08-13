Return-Path: <linux-kernel-owner+w=401wt.eu-S942221AbXHMHiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942221AbXHMHiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966276AbXHMG0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:17 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4123 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966259AbXHMG0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:10 -0400
Date: Sun, 12 Aug 2007 23:23:56 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       hskinnemoen@atmel.com, akpm@linux-foundation.org
Subject: [PATCH] [81/2many] MAINTAINERS - AVR32 ARCHITECTURE
Message-ID: <46bff8fc.JnBSoLyTirRfULRC%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 9e28325..f8272b5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -818,6 +818,8 @@ W:	http://www.atmel.com/products/AVR32/
 W:	http://avr32linux.org/
 W:	http://avrfreaks.net/
 S:	Supported
+F:	arch/avr32/
+F:	include/asm-avr32/
 
 AVR32/AT32AP MACHINE SUPPORT
 P:	Haavard Skinnemoen
