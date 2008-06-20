Return-Path: <linux-kernel-owner+w=401wt.eu-S1761539AbYFTQAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761539AbYFTQAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 12:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbYFTQAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 12:00:42 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:46495 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbYFTQAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 12:00:41 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] procfs-guide: drop pointless &nbsp; entities
Date: Fri, 20 Jun 2008 12:00:39 -0400
Message-Id: <1213977639-8229-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.5.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having trailing &nbsp; entities in a revision numer seems pretty pointless
to me.  More so, it's causing me pains, so just drop them since no other
guide is doing this.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 Documentation/DocBook/procfs-guide.tmpl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/procfs-guide.tmpl b/Documentation/DocBook/procfs-guide.tmpl
index 1fd6a1e..8a5dc6e 100644
--- a/Documentation/DocBook/procfs-guide.tmpl
+++ b/Documentation/DocBook/procfs-guide.tmpl
@@ -29,12 +29,12 @@
 
     <revhistory>
       <revision>
-	<revnumber>1.0&nbsp;</revnumber>
+	<revnumber>1.0</revnumber>
 	<date>May 30, 2001</date>
 	<revremark>Initial revision posted to linux-kernel</revremark>
       </revision>
       <revision>
-	<revnumber>1.1&nbsp;</revnumber>
+	<revnumber>1.1</revnumber>
 	<date>June 3, 2001</date>
 	<revremark>Revised after comments from linux-kernel</revremark>
       </revision>
-- 
1.5.5.3

