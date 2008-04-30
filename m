Return-Path: <linux-kernel-owner+w=401wt.eu-S934365AbYEAAAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934365AbYEAAAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933454AbYD3X6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:58:21 -0400
Received: from mx1.suse.de ([195.135.220.2]:47446 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765716AbYD3X6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:58:20 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/11] DEBUGFS: Correct location of debugfs API documentation.
Date: Wed, 30 Apr 2008 16:57:44 -0700
Message-Id: <1209599870-22919-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080430235701.GA20981@suse.de>
References: <20080430235701.GA20981@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert P. J. Day <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/debugfs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index fddffe4..159a5ef 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -9,7 +9,7 @@
  *	2 as published by the Free Software Foundation.
  *
  *  debugfs is for people to use instead of /proc or /sys.
- *  See Documentation/DocBook/kernel-api for more details.
+ *  See Documentation/DocBook/filesystems for more details.
  *
  */
 
-- 
1.5.5.1

