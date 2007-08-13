Return-Path: <linux-kernel-owner+w=401wt.eu-S970855AbXHMI7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970855AbXHMI7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966669AbXHMGbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:10 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4910 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966826AbXHMGbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:06 -0400
Date: Sun, 12 Aug 2007 23:30:53 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, maxextreme@gmail.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [283/2many] MAINTAINERS - KS0108 LCD CONTROLLER DRIVER
Message-ID: <46bffa9d.KmZJgBW4fj2hb2jU%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 534403d..5c4d564 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2718,6 +2718,9 @@ M:	maxextreme@gmail.com
 L:	linux-kernel@vger.kernel.org
 W:	http://auxdisplay.googlepages.com/
 S:	Maintained
+F:	Documentation/auxdisplay/ks0108
+F:	drivers/auxdisplay/ks0108.c
+F:	include/linux/ks0108.h
 
 LAPB module
 L:	linux-x25@vger.kernel.org
