Return-Path: <linux-kernel-owner+w=401wt.eu-S967778AbXHMGmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967778AbXHMGmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965824AbXHMGXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:01 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3466 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965573AbXHMGWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:31 -0400
Date: Sun, 12 Aug 2007 23:21:42 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, akpm@linux-foundation.org
Subject: [PATCH] [10/2many] MAINTAINERS - 8139CP 10/100 FAST ETHERNET
 DRIVER
Message-ID: <46bff876.cEFDXwjL9wbCBGjZ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ef6c7c3..f4342cc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -146,6 +146,7 @@ F:	drivers/net/hamradio/6pack.c
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
 S:	Maintained
+F:	drivers/net/8139cp.c
 
 8139TOO 10/100 FAST ETHERNET DRIVER
 P:	Jeff Garzik
