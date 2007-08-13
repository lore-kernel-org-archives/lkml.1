Return-Path: <linux-kernel-owner+w=401wt.eu-S1759147AbXHMHBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbXHMHBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965864AbXHMGYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:10 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3762 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965834AbXHMGYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:09 -0400
Date: Sun, 12 Aug 2007 23:23:51 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       hskinnemoen@atmel.com, akpm@linux-foundation.org
Subject: [PATCH] [78/2many] MAINTAINERS - ATMEL SPI DRIVER
Message-ID: <46bff8f7.3VCxdqz51HT2DfiI%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index fba8f0c..44ab6e3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -782,6 +782,7 @@ ATMEL SPI DRIVER
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
 S:	Supported
+F:	drivers/api/atmel_spi.*
 
 ATMEL WIRELESS DRIVER
 P:	Simon Kelley
