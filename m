Return-Path: <linux-kernel-owner+w=401wt.eu-S943551AbXHMJex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943551AbXHMJex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967032AbXHMGcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:47 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1208 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966961AbXHMGcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:39 -0400
Date: Sun, 12 Aug 2007 23:32:24 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, thockin@hockin.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [330/2many] MAINTAINERS - NATSEMI ETHERNET DRIVER
 (DP8381x)
Message-ID: <46bffaf8.au4hoecwfhUxLYGu%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 409dd81..5b7039c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3160,9 +3160,10 @@ F:	drivers/char/isicom.c
 F:	include/linux/isicom.h
 
 NATSEMI ETHERNET DRIVER (DP8381x)
-P: 	Tim Hockin
+P:	Tim Hockin
 M:	thockin@hockin.org
 S:	Maintained
+F:	drivers/net/natsemi.c
 
 NCP FILESYSTEM
 P:	Petr Vandrovec
