Return-Path: <linux-kernel-owner+w=401wt.eu-S965899AbXHMGXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965899AbXHMGXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964905AbXHMGVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:21:55 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3391 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938083AbXHMGVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:21:53 -0400
Date: Sun, 12 Aug 2007 23:21:40 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-hams@vger.kernel.org, akpm@linux-foundation.org,
       ajk@iehk.rwth-aachen.de
Subject: [PATCH] [9/2many] MAINTAINERS - 6PACK NETWORK DRIVER FOR AX.25
Message-ID: <46bff874.VWfwdJpJrRFP796r%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ad55112..ef6c7c3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -140,6 +140,7 @@ P:	Andreas Koensgen
 M:	ajk@iehk.rwth-aachen.de
 L:	linux-hams@vger.kernel.org
 S:	Maintained
+F:	drivers/net/hamradio/6pack.c
 
 8139CP 10/100 FAST ETHERNET DRIVER
 P:	Jeff Garzik
