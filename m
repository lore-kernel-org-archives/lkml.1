Return-Path: <linux-kernel-owner+w=401wt.eu-S1765711AbXHMIsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765711AbXHMIsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966817AbXHMGab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:30:31 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4794 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966421AbXHMGa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:30:26 -0400
Date: Sun, 12 Aug 2007 23:30:13 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, openipmi-developer@lists.sourceforge.net,
       minyard@acm.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [264/2many] MAINTAINERS - IPMI SUBSYSTEM
Message-ID: <46bffa75.qEmjEDgYnspaocFg%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 4157218..c1a9131 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2524,6 +2524,9 @@ M:	minyard@acm.org
 L:	openipmi-developer@lists.sourceforge.net
 W:	http://openipmi.sourceforge.net/
 S:	Supported
+F:	Documentation/IPMI.txt
+F:	drivers/char/ipmi/
+F:	include/linux/ipmi*
 
 IPX NETWORK LAYER
 P:	Arnaldo Carvalho de Melo
