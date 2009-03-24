Return-Path: <linux-kernel-owner+w=401wt.eu-S1761605AbZCXOTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761605AbZCXOTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760259AbZCXOLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:11:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37605 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760806AbZCXOLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:11:48 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>
Subject: [PATCH 3/7] dlm: comment typo fixes
Date: Tue, 24 Mar 2009 09:07:48 -0500
Message-Id: <1237903672-18913-4-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lowcomms.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index bf09262..982314c 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -21,7 +21,7 @@
  *
  * Cluster nodes are referred to by their nodeids. nodeids are
  * simply 32 bit numbers to the locking module - if they need to
- * be expanded for the cluster infrastructure then that is it's
+ * be expanded for the cluster infrastructure then that is its
  * responsibility. It is this layer's
  * responsibility to resolve these into IP address or
  * whatever it needs for inter-node communication.
@@ -36,9 +36,9 @@
  * of high load. Also, this way, the sending thread can collect together
  * messages bound for one node and send them in one block.
  *
- * lowcomms will choose to use wither TCP or SCTP as its transport layer
+ * lowcomms will choose to use either TCP or SCTP as its transport layer
  * depending on the configuration variable 'protocol'. This should be set
- * to 0 (default) for TCP or 1 for SCTP. It shouldbe configured using a
+ * to 0 (default) for TCP or 1 for SCTP. It should be configured using a
  * cluster-wide mechanism as it must be the same on all nodes of the cluster
  * for the DLM to function.
  *
-- 
1.5.5.6

