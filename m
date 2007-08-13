Return-Path: <linux-kernel-owner+w=401wt.eu-S932524AbXHMKLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524AbXHMKLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967199AbXHMGeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:31 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1547 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967193AbXHMGe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:27 -0400
Date: Sun, 12 Aug 2007 23:34:14 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mostrows@speakeasy.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [386/2many] MAINTAINERS - PPP OVER ETHERNET
Message-ID: <46bffb66.U/JNrao8gxVFeVBR%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 216a280..e8d706b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3691,6 +3691,8 @@ PPP OVER ETHERNET
 P:	Michal Ostrowski
 M:	mostrows@speakeasy.net
 S:	Maintained
+F:	drivers/net/pppoe.c
+F:	drivers/net/pppox.c
 
 PPP OVER L2TP
 P:	James Chapman
