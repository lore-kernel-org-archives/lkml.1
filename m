Return-Path: <linux-kernel-owner+w=401wt.eu-S1765716AbXHMHBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765716AbXHMHBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965523AbXHMGYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:11 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3768 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966069AbXHMGYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:10 -0400
Date: Sun, 12 Aug 2007 23:23:49 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       hskinnemoen@atmel.com, akpm@linux-foundation.org
Subject: [PATCH] [77/2many] MAINTAINERS - ATMEL MACB ETHERNET DRIVER
Message-ID: <46bff8f5.Cbg5zPNRrngJ/Bm3%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3568f85..fba8f0c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -776,6 +776,7 @@ ATMEL MACB ETHERNET DRIVER
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
 S:	Supported
+F:	drivers/net/macb.*
 
 ATMEL SPI DRIVER
 P:	Haavard Skinnemoen
