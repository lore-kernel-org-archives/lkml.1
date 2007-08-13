Return-Path: <linux-kernel-owner+w=401wt.eu-S1765459AbXHMGn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765459AbXHMGn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936319AbXHMGXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:07 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3573 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965817AbXHMGXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:01 -0400
Date: Sun, 12 Aug 2007 23:22:48 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, nicolas@boichat.ch,
       mactel-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [45/2many] MAINTAINERS - APPLE SMC DRIVER
Message-ID: <46bff8b8.F4X7gFDAh6aqCX3y%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index da9bc6d..e9a72f3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -437,6 +437,7 @@ P:	Nicolas Boichat
 M:	nicolas@boichat.ch
 L:	mactel-linux-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/hwmon/applesmc.c
 
 APPLETALK NETWORK LAYER
 P:	Arnaldo Carvalho de Melo
