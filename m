Return-Path: <linux-kernel-owner+w=401wt.eu-S1763276AbXJEQ7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763276AbXJEQ7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 12:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757083AbXJEQ70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 12:59:26 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:55430 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759316AbXJEQ7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:59:25 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: apw@shadowen.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
Cc: linux-kernel@vger.kernel.org, Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 1/3] CHECKPATCH: update usage string for checkpatch.pl
Date: Fri,  5 Oct 2007 12:56:06 -0400
Message-Id: <11916033681419-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11916033681196-git-send-email-ezk@cs.sunysb.edu>
References: <11916033681196-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 scripts/checkpatch.pl |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index dae7d30..ecbb030 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -33,6 +33,7 @@ if ($#ARGV < 0) {
 	print "version: $V\n";
 	print "options: -q           => quiet\n";
 	print "         --no-tree    => run without a kernel tree\n";
+	print "         --no-signoff => don't check for signed-off-by\n";
 	exit(1);
 }
 
-- 
1.5.2.2

