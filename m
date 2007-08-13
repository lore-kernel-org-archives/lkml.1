Return-Path: <linux-kernel-owner+w=401wt.eu-S939259AbXHMKkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939259AbXHMKkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965988AbXHMGgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:15 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1800 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967292AbXHMGfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:55 -0400
Date: Sun, 12 Aug 2007 23:35:42 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, romieu@fr.zoreil.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [432/2many] MAINTAINERS - SIS 190 ETHERNET DRIVER
Message-ID: <46bffbbe.0ZQs53IlZYhKFIZf%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 71be2f5..38f1b0d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4119,6 +4119,7 @@ P:	Francois Romieu
 M:	romieu@fr.zoreil.com
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/sis190.c
 
 SIS 5513 IDE CONTROLLER DRIVER
 P:	Lionel Bouton
