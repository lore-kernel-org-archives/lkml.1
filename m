Return-Path: <linux-kernel-owner+w=401wt.eu-S939547AbXHMJSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939547AbXHMJSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966642AbXHMGcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:07 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1097 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967009AbXHMGb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:59 -0400
Date: Sun, 12 Aug 2007 23:31:38 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, jbenc@suse.cz, flamingice@sourmilk.net,
       akpm@linux-foundation.org
Subject: [PATCH] [307/2many] MAINTAINERS - MAC80211
Message-ID: <46bffaca.H40xpVULANwnAvQA%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f7943f0..07fb80f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2957,6 +2957,9 @@ L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/jbenc/mac80211.git
 S:	Maintained
+F:	net/mac80211/
+F:	Documentation/networking/mac80211-injection.txt
+F:	include/net/mac80211.h
 
 MACVLAN DRIVER
 P:	Patrick McHardy
