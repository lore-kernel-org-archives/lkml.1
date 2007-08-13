Return-Path: <linux-kernel-owner+w=401wt.eu-S942455AbXHMK53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942455AbXHMK53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966783AbXHMGgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:55 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1942 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967369AbXHMGgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:48 -0400
Date: Sun, 12 Aug 2007 23:36:35 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, shemminger@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [455/2many] MAINTAINERS - SKGE, SKY2 10/100/1000 GIGABIT
 ETHERNET DRIVERS
Message-ID: <46bffbf3.rv8NyuKEk/VVKvwd%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index a40c7ed..cb9f9da 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4348,6 +4348,8 @@ P:	Stephen Hemminger
 M:	shemminger@linux-foundation.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/skge.*
+F:	drivers/net/sky2.*
 
 SOEKRIS NET48XX LED SUPPORT
 P:	Chris Boot
