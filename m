Return-Path: <linux-kernel-owner+w=401wt.eu-S939050AbXHMHH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939050AbXHMHH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965965AbXHMGYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:30 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3807 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965298AbXHMGYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:24 -0400
Date: Sun, 12 Aug 2007 23:24:10 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       aubrey.li@analog.com, akpm@linux-foundation.org
Subject: [PATCH] [88/2many] MAINTAINERS - BLACKFIN SERIAL DRIVER
Message-ID: <46bff90a.vPTyO4LoajDyBpkU%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 36a0c0a..641791f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -903,6 +903,7 @@ M:	aubrey.li@analog.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
+F:	drivers/serial/bfin_5xx.c
 
 BLACKFIN WATCHDOG DRIVER
 P:	Mike Frysinger
