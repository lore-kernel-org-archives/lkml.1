Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbZLHMxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbZLHMxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 07:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbZLHMxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 07:53:47 -0500
Received: from cantor.suse.de ([195.135.220.2]:59881 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269AbZLHMxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 07:53:46 -0500
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: new kbuild maintainer
Date: Tue,  8 Dec 2009 13:52:31 +0100
Message-Id: <1260276751-19501-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam was fine with handing over kbuild maintainership to me. The git
trees are already in linux-next, a merge request will follow shortly.

Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 MAINTAINERS |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4f96ac8..9206e04 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3015,8 +3015,11 @@ S:	Maintained
 F:	fs/autofs4/
 
 KERNEL BUILD
+M:	Michal Marek <mmarek@suse.cz>
+T:	git git://repo.or.cz/linux-kbuild.git for-next
+T:	git git://repo.or.cz/linux-kbuild.git for-linus
 L:	linux-kbuild@vger.kernel.org
-S:	Orphan
+S:	Maintained
 F:	Documentation/kbuild/
 F:	Makefile
 F:	scripts/Makefile.*
-- 
1.6.5.3

