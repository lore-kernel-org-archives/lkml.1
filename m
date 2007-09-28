Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbXI1Vca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbXI1Vca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbXI1VcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:32:14 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:55848 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608AbXI1VcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:32:11 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 2/3] Update usage string for checkpatch.pl
Date: Fri, 28 Sep 2007 17:32:01 -0400
Message-Id: <11910151231405-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11910151223214-git-send-email-ezk@cs.sunysb.edu>
References: <11910151223214-git-send-email-ezk@cs.sunysb.edu>
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

