Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbZEXCkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbZEXCkk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 22:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbZEXCiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 22:38:12 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1433 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbZEXCiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 22:38:04 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/18] MAINTAINERS - Swap mismarked ECRYPT FS M: and P: entries
Date: Sat, 23 May 2009 19:37:42 -0700
Message-Id: <778d62ddab9f8ce5559ef114e89dd149c4811972.1243131992.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1243131992.git.joe@perches.com>
References: <cover.1243131992.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 77cbfb1..1bf74c9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1951,8 +1951,8 @@ F:	net/bridge/netfilter/ebt*.c
 ECRYPT FILE SYSTEM
 P:	Tyler Hicks
 M:	tyhicks@linux.vnet.ibm.com
-M:	Dustin Kirkland
-P:	kirkland@canonical.com
+P:	Dustin Kirkland
+M:	kirkland@canonical.com
 L:	ecryptfs-devel@lists.launchpad.net
 W:	https://launchpad.net/ecryptfs
 S:	Supported
-- 
1.6.3.1.10.g659a0.dirty

