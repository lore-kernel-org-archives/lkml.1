Return-Path: <linux-kernel-owner+w=401wt.eu-S943778AbXHMLCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943778AbXHMLCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967304AbXHMGhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:37:22 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2005 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967303AbXHMGhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:08 -0400
Date: Sun, 12 Aug 2007 23:34:46 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dipankar@in.ibm.com, akpm@linux-foundation.org
Subject: [PATCH] [403/2many] MAINTAINERS - READ-COPY UPDATE (RCU)
Message-ID: <46bffb86.JycvgrEDCcjNfcuu%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 776ca59..5377742 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3843,6 +3843,11 @@ M:	dipankar@in.ibm.com
 W:	http://www.rdrop.com/users/paulmck/rclock/
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	Documentation/RCU/rcu.txt
+F:	Documentation/RCU/rcuref.txt
+F:	include/linux/rcupdate.h
+F:	include/linux/srcu.h
+F:	kernel/rcupdate.c
 
 RCUTORTURE MODULE
 P:	Josh Triplett
