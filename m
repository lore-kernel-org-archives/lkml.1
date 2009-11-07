Return-Path: <linux-kernel-owner+w=401wt.eu-S1752079AbZKGSur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbZKGSur (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 13:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZKGSul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 13:50:41 -0500
Received: from mail.perches.com ([173.55.12.10]:1253 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbZKGSu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 13:50:27 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] MAINTAINERS: Correct NETFILTER git entry format
Date: Sat,  7 Nov 2009 10:50:30 -0800
Message-Id: <aafd2f268da889c093d4f80b9739f38ddbd50ae5.1257618926.git.joe@perches.com>
X-Mailer: git-send-email 1.6.5.2.153.g6e31f
In-Reply-To: <cover.1257618926.git.joe@perches.com>
References: <cover.1257618926.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 44a172d..53f416a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3618,7 +3618,7 @@ L:	netfilter@vger.kernel.org
 L:	coreteam@netfilter.org
 W:	http://www.netfilter.org/
 W:	http://www.iptables.org/
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.git
 S:	Supported
 F:	include/linux/netfilter*
 F:	include/linux/netfilter/
-- 
1.6.5.1.65.gc2fd

