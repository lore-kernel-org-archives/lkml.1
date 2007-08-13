Return-Path: <linux-kernel-owner+w=401wt.eu-S970358AbXHMInu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970358AbXHMInu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966356AbXHMGaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:30:15 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4737 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966801AbXHMGaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:30:02 -0400
Date: Sun, 12 Aug 2007 23:29:47 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dsaxena@plexity.net, akpm@linux-foundation.org
Subject: [PATCH] [254/2many] MAINTAINERS - INTEL IXP4XX RANDOM NUMBER
 GENERATOR SUPPORT
Message-ID: <46bffa5b.rjTKKxHhoZP0sssm%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index da059b9..dccbaba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2416,6 +2416,7 @@ INTEL IXP4XX RANDOM NUMBER GENERATOR SUPPORT
 P:	Deepak Saxena
 M:	dsaxena@plexity.net
 S:	Maintained
+F:	drivers/char/hw_random/ixp4xx-rng.c
 
 INTEL IXP2000 ETHERNET DRIVER
 P:	Lennert Buytenhek
