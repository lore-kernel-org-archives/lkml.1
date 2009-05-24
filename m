Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbZEXCkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbZEXCkW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 22:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbZEXCiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 22:38:11 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1436 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbZEXCiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 22:38:04 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 12/18] MAINTAINERS - Pair EDAC-E752X P: and M: entries
Date: Sat, 23 May 2009 19:37:43 -0700
Message-Id: <11c456215019f290680d92b1fc27ed479a1751c6.1243131992.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1243131992.git.joe@perches.com>
References: <cover.1243131992.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Entries should be P: name then M: email address

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1bf74c9..2ae5a2e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1971,8 +1971,8 @@ F:	include/linux/edac.h
 
 EDAC-E752X
 P:	Mark Gross
-P:	Doug Thompson
 M:	mark.gross@intel.com
+P:	Doug Thompson
 M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	bluesmoke.sourceforge.net
-- 
1.6.3.1.10.g659a0.dirty

