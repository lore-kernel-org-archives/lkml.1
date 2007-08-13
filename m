Return-Path: <linux-kernel-owner+w=401wt.eu-S943282AbXHMINo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943282AbXHMINo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966654AbXHMG2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:32 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4487 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966403AbXHMG23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:29 -0400
Date: Sun, 12 Aug 2007 23:28:12 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       hskinnemoen@atmel.com, akpm@linux-foundation.org
Subject: [PATCH] [206/2many] MAINTAINERS - GENERIC GPIO I2C DRIVER
Message-ID: <46bff9fc.i+o8WMM7bF8WiNL9%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 6597718..bdfbda0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1967,6 +1967,8 @@ GENERIC GPIO I2C DRIVER
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
 S:	Supported
+F:	Documentation/gpio.txt
+F:	drivers/i2c/busses/i2c-gpio.c
 
 GENERIC HDLC DRIVER, N2, C101, PCI200SYN and WANXL DRIVERS
 P:	Krzysztof Halasa
