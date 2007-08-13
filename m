Return-Path: <linux-kernel-owner+w=401wt.eu-S966236AbXHMG02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966236AbXHMG02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965485AbXHMGWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:22:25 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3444 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965400AbXHMGWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:23 -0400
Date: Sun, 12 Aug 2007 23:21:46 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, romieu@fr.zoreil.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [12/2many] MAINTAINERS - 8169 10/100/1000 GIGABIT
 ETHERNET DRIVER
Message-ID: <46bff87a.9UvGZLBGxL0o/dZe%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ac5ba41..2fc85df 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -160,6 +160,7 @@ P:	Francois Romieu
 M:	romieu@fr.zoreil.com
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/r8169.c
 
 8250/16?50 (AND CLONE UARTS) SERIAL DRIVER
 L:	linux-serial@vger.kernel.org
