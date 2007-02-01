Return-Path: <linux-kernel-owner+w=401wt.eu-S1751796AbXBAPuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbXBAPuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbXBAPuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:50:08 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:52117 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751830AbXBAPuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:50:07 -0500
Date: Thu, 1 Feb 2007 16:49:31 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Linus Torvalds <torvalds@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: [PATCH] Remove avr32@atmel.com from MAINTAINERS
Message-ID: <20070201164931.24d3b615@dhcp-252-105.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

avr32@atmel.com is a technical support address and is not really
appropriate for sending patches. Lots of annoying automatics getting
in the way.

I'm still the maintainer of all the entries touched by this patch, so
nothing changes with regard to the "Supported" status of the AVR32
architecture or the macb driver.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 MAINTAINERS |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a275f72..465e083 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -598,8 +598,6 @@ W:	http://linux-atm.sourceforge.net
 S:	Maintained
 
 ATMEL MACB ETHERNET DRIVER
-P:	Atmel AVR32 Support Team
-M:	avr32@atmel.com
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
 S:	Supported
@@ -620,8 +618,6 @@ T:	git kernel.org:/pub/scm/linux/kernel/git/dwmw2/audit-2.6.git
 S:	Maintained
 
 AVR32 ARCHITECTURE
-P:	Atmel AVR32 Support Team
-M:	avr32@atmel.com
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
 W:	http://www.atmel.com/products/AVR32/
@@ -630,8 +626,6 @@ W:	http://avrfreaks.net/
 S:	Supported
 
 AVR32/AT32AP MACHINE SUPPORT
-P:	Atmel AVR32 Support Team
-M:	avr32@atmel.com
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
 S:	Supported
-- 
1.4.4.3

