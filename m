Return-Path: <linux-kernel-owner+w=401wt.eu-S966100AbXHMGYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966100AbXHMGYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939159AbXHMGWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:22:01 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3403 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939121AbXHMGWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:00 -0400
Date: Sun, 12 Aug 2007 23:21:44 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, akpm@linux-foundation.org
Subject: [PATCH] [11/2many] MAINTAINERS - 8139TOO 10/100 FAST ETHERNET
 DRIVER
Message-ID: <46bff878.a4nmfLl5Kd3/C7ph%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f4342cc..ac5ba41 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -153,6 +153,7 @@ P:	Jeff Garzik
 M:	jgarzik@pobox.com
 W:	http://sourceforge.net/projects/gkernel/
 S:	Maintained
+F:	drivers/net/8139too.c
 
 8169 10/100/1000 GIGABIT ETHERNET DRIVER
 P:	Francois Romieu
