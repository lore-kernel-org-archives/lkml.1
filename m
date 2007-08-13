Return-Path: <linux-kernel-owner+w=401wt.eu-S944440AbXHMLTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944440AbXHMLTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965938AbXHMGiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:10 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2108 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966447AbXHMGhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:45 -0400
Date: Sun, 12 Aug 2007 23:37:01 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, hadi@cyberus.ca,
       akpm@linux-foundation.org
Subject: [PATCH] [469/2many] MAINTAINERS - TC CLASSIFIER
Message-ID: <46bffc0d.KtaxHSXc/hUmQUps%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f00640b..fc0589f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4457,6 +4457,9 @@ P:	Jamal Hadi Salim
 M:	hadi@cyberus.ca
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	include/linux/pkt_cls.h
+F:	include/net/pkt_cls.h
+F:	net/sched/
 
 TCP LOW PRIORITY MODULE
 P:	Wong Hoi Sing, Edison
