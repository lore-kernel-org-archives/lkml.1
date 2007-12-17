Return-Path: <linux-kernel-owner+w=401wt.eu-S934826AbXLQTtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934826AbXLQTtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759633AbXLQTcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:32:12 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3047 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761443AbXLQTcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:32:05 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "LinuxTV.org Project" <v4l-dvb-maintainer@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       video4linux-list@redhat.com
Subject: [PATCH] include/media/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:41 -0800
Message-Id: <1197919875-5288-42-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918891.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/media/rds.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/media/rds.h b/include/media/rds.h
index 951c1ae..a894266 100644
--- a/include/media/rds.h
+++ b/include/media/rds.h
@@ -4,7 +4,7 @@
     saa6588.c and every driver (e.g. bttv-driver.c) that wants
     to use the saa6588 module.
 
-    Instead of having a seperate rds.h, I'd prefer to include
+    Instead of having a separate rds.h, I'd prefer to include
     this stuff in one of the already existing files like tuner.h
 
     (c) 2005 by Hans J. Koch
-- 
1.5.3.7.949.g2221a6

