Return-Path: <linux-kernel-owner+w=401wt.eu-S936194AbXHMKh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936194AbXHMKh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967297AbXHMGgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:09 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1807 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967209AbXHMGf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:57 -0400
Date: Sun, 12 Aug 2007 23:35:44 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Lionel.Bouton@inet6.fr
Subject: [PATCH] [433/2many] MAINTAINERS - SIS 5513 IDE CONTROLLER DRIVER
Message-ID: <46bffbc0.Ettk8Q1XcMX1P3NI%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 38f1b0d..228e077 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4127,6 +4127,7 @@ M:	Lionel.Bouton@inet6.fr
 W:	http://inet6.dyn.dhs.org/sponsoring/sis5513/index.html
 W:	http://gyver.homeip.net/sis5513/index.html
 S:	Maintained
+F:	drivers/ide/pci/sis5513.c
 
 SIS 900/7016 FAST ETHERNET DRIVER
 P:	Daniele Venzano
