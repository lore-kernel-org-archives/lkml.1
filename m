Return-Path: <linux-kernel-owner+w=401wt.eu-S932986AbYDBUl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986AbYDBUl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762040AbYDBU0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:26:25 -0400
Received: from ns1.suse.de ([195.135.220.2]:39341 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764125AbYDBU0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:26:24 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>
Subject: [PATCH 61/62] ocfs2: Put tree in MAINTAINERS
Date: Wed,  2 Apr 2008 13:24:57 -0700
Message-Id: <1207167903811-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: 12071673121124-git-send-email-mfasheh@suse.com
References: 12071673121124-git-send-email-mfasheh@suse.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel Becker <joel.becker@oracle.com>

The ocfs2 MAINTAINERS entry should have the git tree URL.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 90dcbbc..5c76ad3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2946,6 +2946,7 @@ P:	Joel Becker
 M:	joel.becker@oracle.com
 L:	ocfs2-devel@oss.oracle.com
 W:	http://oss.oracle.com/projects/ocfs2/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git
 S:	Supported
 
 OMNIKEY CARDMAN 4000 DRIVER
-- 
1.5.4.1

