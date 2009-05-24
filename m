Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbZEXClX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbZEXClX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 22:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271AbZEXCiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 22:38:15 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1437 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbZEXCiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 22:38:04 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 13/18] MAINTAINERS - Add file patterns to "THE REST"
Date: Sat, 23 May 2009 19:37:44 -0700
Message-Id: <81304a63bda751d53c83036049e44aee83e90565.1243131992.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1243131992.git.joe@perches.com>
References: <cover.1243131992.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These file patterns match all sources.
By default, scripts/get_maintainers.pl excludes Linus Torvalds
from the CC: list.  Option --git-chief-penguins will include him.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2ae5a2e..1f18bbf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6387,5 +6387,10 @@ F:	drivers/serial/zs.*
 
 THE REST
 P:	Linus Torvalds
+M:	torvalds@linux-foundation.org
+L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
 S:	Buried alive in reporters
+F:	*
+F:	*/
+
-- 
1.6.3.1.10.g659a0.dirty

