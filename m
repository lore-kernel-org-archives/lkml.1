Return-Path: <linux-kernel-owner+w=401wt.eu-S936961AbXLQUGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936961AbXLQUGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934261AbXLQTmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:42:07 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3239 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934039AbXLQTle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:41:34 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul.moore@hp.com>,
       netdev@vger.kernel.org
Subject: [PATCH] net/netlabel/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:35 -0800
Message-Id: <1197920439-5455-29-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918894.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 net/netlabel/netlabel_mgmt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
index 5648337..9c41464 100644
--- a/net/netlabel/netlabel_mgmt.c
+++ b/net/netlabel/netlabel_mgmt.c
@@ -71,7 +71,7 @@ static const struct nla_policy netlbl_mgmt_genl_policy[NLBL_MGMT_A_MAX + 1] = {
 };
 
 /*
- * NetLabel Misc Managment Functions
+ * NetLabel Misc Management Functions
  */
 
 /**
-- 
1.5.3.7.949.g2221a6

