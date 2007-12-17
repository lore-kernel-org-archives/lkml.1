Return-Path: <linux-kernel-owner+w=401wt.eu-S935934AbXLQTxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935934AbXLQTxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763984AbXLQTkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:40:52 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3173 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763967AbXLQTkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:40:51 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] drivers/nubus/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:09 -0800
Message-Id: <1197920439-5455-3-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918892.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/nubus/nubus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/nubus/nubus.c b/drivers/nubus/nubus.c
index e503c9c..f4076ae 100644
--- a/drivers/nubus/nubus.c
+++ b/drivers/nubus/nubus.c
@@ -352,7 +352,7 @@ nubus_find_rsrc(struct nubus_dir* dir, unsigned char rsrc_type,
    resource blocks. */
 
 /* FIXME: A lot of this stuff will eventually be useful after
-   initializaton, for intelligently probing Ethernet and video chips,
+   initialization, for intelligently probing Ethernet and video chips,
    among other things.  The rest of it should go in the /proc code.
    For now, we just use it to give verbose boot logs. */
 
-- 
1.5.3.7.949.g2221a6

